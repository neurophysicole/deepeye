function ck_replicate_eye_movement_features
% Extracting fixation and saccade statistics from the edf files..


%% --------- %%
%% init vars %%
%% --------- %%

data_dir            = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/E1-8/LaurenElise/Exp1/exp1_v4/data';
eye_dir             = sprintf('%s/data_eyelink', data_dir);
eye_files_struct    = dir([eye_dir '/*.edf']);
eye_files           = extractfield(eye_files_struct,'name');
txt_dir             = sprintf('%s/data_text', data_dir);
% text_files_struct   = dir([txt_dir '/*.txt']);
% txt_files           = extractfield(text_files_struct,'name');

toolbox_path        = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/mrj_matlab_scripts/uzh-edf-converter-fae25ca';
addpath(toolbox_path);

subj_data = cell(length(eye_files), 9);

% current_subj    = 0;
data_size       = 0;


%% ------------------ %%
%% Calc Stim Saliency %%
%% ------------------ %%
% calculating the average saliency for each pixel location of each image
% the mapping of the fixations onto the image pixels is done in the saliency_fix function later on..

% ---------
% init vars
stim_dir        = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/E1-8/LaurenElise/Exp1/exp1_v4/resources/images/';
stim_dir_struct = dir([stim_dir]);
stim_dir_names  = extractfield(stim_dir_struct, 'name');
stim_dir_dirs   = extractfield(stim_dir_struct, 'isdir');
% assign names to dirs, get rid of fnames
for i = 1:length(stim_dir_names)
    if stim_dir_dirs{i} == 1
        stim_dir_dirs{i} = stim_dir_names{i};
    else
        stim_dir_dirs{i} = [];
    end
end

% ---------
% get stims
stim_count = 0;
stim_subdirs = cell(length(stim_dir_dirs), 1);
for dirs = 1:length(stim_dir_dirs)
    % get subdir names
    subdir              = sprintf(stim_dir, stim_dir_dirs{dirs});
    subdir_struct       = dir([subdir]);
    subdir_names        = extractfield(subdir_struct, 'name');
    subdir_folder       = unique(extractfield(subdir_struct, 'folder'));
    ftypes              = { 'jpg', 'JPG', 'png' };

    % get file names, no dirs
    subdir_contents = {};
    for i = 1:length(ftypes)
        ftype_contents      = regexp(subdir_names, ftypes{i});

        for j = 1:length(ftype_contents)
            if length(ftype_contents{j} > 0)
                subdir_contents = { subdir_contents; subdir_names{j} };
            end
        end
    end

    % loop through subdir to assign prefix to each item
    subdir_files = length(subdir_contents);
    for dirs_files = 1:length(subdir_contents)
        subdir_files{dirs_files} = sprintf('%s/%s', subdir_folder{1}, subdir_contents{dirs_files}{2}); %get files
    end

    stim_subdirs{dirs}  = subdir_files; %logit

    stim_count = stim_count + length(subdir_contents);
end

% stack stim file names
stim_fnames = cell(stim_count, 1);
stim_count_counter = 1;
for dirs = 1:length(stim_dir_dirs) %loop through dirs
    subdir_files = stim_dir_dirs{dirs}; %get dir
    for dirs_files = 1:length(subdir_files) %loop through subdirs
        stim_fnames{stim_count_counter} = subdir_files{dirs_files}; %assign fnames
        stim_count_counter              = stim_count_counter + 1; %update counter
    end
end

% ------------------
% calculate saliency
saliency = cell(stim_count, 1);
for img = 1:length(stim_fnames)
    saliency{img} = img_saliency_calculation(stim_fnames{img});
end


%% ------------------------ %%
%% cycle through data files %%
%% ------------------------ %%

for current_file = 1:length(eye_files)
    data_file = eye_files{current_file};
    
    % -----------------------------------------
    % some of these files are busted, skip them
    try
        owd = pwd;
        cd(eye_dir);
        edf_data = Edf2Mat( data_file );
        cd(owd);
        fprintf('Loaded: %s\n', data_file);
    catch
        fprintf('\n\nproblem importing: %s -- skipping this file.\n\n', data_file );
        continue
    end

    % -----------------
    % define the trials
    edf_info_strings = edf_data.Events.Messages.info';
    start_inds  = ~cellfun('isempty',strfind(edf_info_strings,'START TRIAL'));
    end_inds    = ~cellfun('isempty',strfind(edf_info_strings,'STOP TRIAL'));

    start_inds  = find(start_inds);
    end_inds    = find(end_inds);

    start_times = edf_data.Events.Messages.time( start_inds );
    end_times   = edf_data.Events.Messages.time( end_inds ); %#ok<FNDSB>

    n_trials    = numel(start_inds);

    % ----------------------------------------
    % extract stim imgs per trial (.txt files)
    txt_file    = sprintf(txt_dir, data_file(1:end-4), '.txt'); %change from .edf to .txt
    txt_data    = readtable(txt_file); %get data
    stim_imgs   = txt_data.imagename; %isolate stim imgs

    % ---------------
    % init trial vars
    trial_types         = nan(n_trials, 1);
    init_time           = nan(n_trials, 1);
    num_fixations       = nan(n_trials, 1);
    entropy_attn        = nan(n_trials, 1);
    mean_sacc_amplitude = nan(n_trials, 1);
    mean_fix_dur        = nan(n_trials, 1);
    area_fixated        = nan(n_trials, 1);
    saliency_fix        = nan(n_trials, 1);


    % -------------------
    % loop through trials
    % -------------------

    for i = 1:n_trials

        % mark the borders
        trial_start = start_times(i);
        trial_end = end_times(i);

        trial_inds = (edf_data.Samples.time >= trial_start) & (edf_data.Samples.time <= trial_end);
        % trial_data{i} = [edf_data.Samples.posX(trial_inds) edf_data.Samples.posY(trial_inds) edf_data.Samples.pupilSize(trial_inds)];
        
        % get meta info
        trial_info_str = edf_info_strings{start_inds(i)};
        tt_ind = strfind(trial_info_str,'TRIALTYPE');
        trial_types(i) = str2double( trial_info_str( (tt_ind+9):(tt_ind+11) )); %works in very limited circumstances

        
        % --------------
        % aggregate data
        fixations   = edf_data.Events.Efix;
        saccades    = edf_data.Events.Esacc;

        % fix_start    = fixations.start((fixations.start >= trial_start) & (fixations.end <= trial_end));
        % fix_end      = fixations.end((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_dur      = fixations.duration((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_x        = fixations.posX((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_y        = fixations.posY((fixations.start >= trial_start) & (fixations.end <= trial_end));

        sacc_start   = saccades.start((saccades.start >= trial_start) & (saccades.end <= trial_end));
        % sacc_end     = saccades.end((saccades.start >= trial_start) & (saccades.end <= trial_end));
        % sacc_dur     = saccades.duration((saccades.start >= trial_start) & (saccades.end <= trial_end));
        % sacc_x       = saccades.posX((saccades.start >= trial_start) & (saccades.end <= trial_end));
        % sacc_y       = saccades.posY((saccades.start >= trial_start) & (saccades.end <= trial_end));
        % sacc_x_end   = saccades.posXend((saccades.start >= trial_start) & (saccades.end <= trial_end));
        % sacc_y_end   = saccades.posYend((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_hypot   = saccades.hypot((saccades.start >= trial_start) & (saccades.end <= trial_end));

        %% -------------- %%
        %% clean the data %%
        %% -------------- %%
    
        % clean_fixations(input);
        % clean_saccades(input);
    
    
        %% ------------- %%
        %% calc features %%
        %% ------------- %%
        % calculate the features to be used in the analysis
        % all defined in functions at the end of the script
        % listed in order of importance, as determined by Coco & Keller
    
        init_time(i)           = initiation_time( trial_start, sacc_start );
        num_fixations(i)       = number_of_fixations( fix_dur );
        entropy_attn(i)        = entropy_of_attentional_landscape(fix_x, fix_y, fix_dur, stim_imgs);
        mean_sacc_amplitude(i) = mean_sacade_amplitude( sacc_hypot );
        mean_fix_dur(i)        = mean_fixation_duration( fix_dur );
        area_fixated(i)        = percent_area_fixated( fix_x, fix_y );
        saliency_fix(i)        = saliency_at_fixation( fix_x, fix_y, saliency(saliency{:,2} == stim_imgs{i}, 1) );

    end


    %% ------------------- %%
    %% assign to subj data %%
    %% ------------------- %%

    subj_data{current_file, 1}  = current_file; %subject number
    subj_data{current_file, 2}  = 1:n_trials; %trial numbers
    subj_data{current_file, 3}  = trialtype;
    subj_data{current_file, 4}  = init_time;
    subj_data{current_file, 5}  = num_fixations;
    subj_data{current_file, 6}  = entropy_attn;
    subj_data{current_file, 7}  = mean_sacc_amplitude;
    subj_data{current_file, 8}  = mean_fix_dur;
    subj_data{current_file, 9}  = area_fixated;
    subj_data{current_file, 10} = saliency_fix;
    subj_data{current_file, 11} = stim_imgs;

    % need to know how many rows to make
    data_size = data_size + n_trials;
end


%% -------------- %%
%% stack the data %%
%% -------------- %%

% init vars
eye_data    = nan(data_size, 11);
x_start     = 1;
iter_size   = length(subj_data{i, 1});

% iterate through files
for i = 1:length(eye_files)
    eye_data(x_start:iter_size, 1)  = subj_data{i, 1}; %subj_num
    eye_data(x_start:iter_size, 2)  = subj_data{i, 2}; %trialnum
    eye_data(x_start:iter_size, 3)  = subj_data{i, 3}; %trialtype
    eye_data(x_start:iter_size, 4)  = subj_data{i, 4}; %init_time
    eye_data(x_start:iter_size, 5)  = subj_data{i, 5}; %num_fixations
    eye_data(x_start:iter_size, 6)  = subj_data{i, 6}; %entropy_attn
    eye_data(x_start:iter_size, 7)  = subj_data{i, 7}; %mean_sacc_amplitude
    eye_data(x_start:iter_size, 8)  = subj_data{i, 8}; %mean_fix_dur
    eye_data(x_start:iter_size, 9)  = subj_data{i, 9}; %area_fixated
    eye_data(x_start:iter_size, 10) = subj_data{i, 10}; %saliency_fix
    eye_data(x_start:iter_size, 11) = subj_data{i, 11}; %stim_imgs

    x_start = x_start + iter_size;
end


%% --------- %%
%% gen table %%
%% --------- %%

eye_data_table = table(eye_data{:, 1}, eye_data{:, 2}, eye_data{:, 3}, eye_data{:, 4}, eye_data{:, 5}, eye_data{:, 6}, eye_data{:, 7}, eye_data{:, 8}, eye_data{:, 9}, eye_data{:, 10}, eye_data{:, 11}, 'VariableNames', {'subj_num', 'trialnum', 'trialtype', 'init_time', 'num_fixations', 'entropy_attn', 'mean_sacc_amplitude', 'mean_fix_dur', 'area_fixated', 'saliency_fix', 'stim_imgs'});


%% ----------- %%
%% save output %%
%% ----------- %%

% .mat file
save('ck_features.mat', 'eye_data_table', '-v7.3');

% csv
save('ck_features.csv', 'eye_data_table');


%% ==================== %%
%% Process Data (Clean) %%
%% ==================== %%

% Definitions
% -----------
% Fixation: Castelhano limited to 90-2000ms
% Saccade: Castelhano limited to shifts in eye position greater than 8 pixels (8.8 arcmins) in 15ms or less
% Note: Just going to go with what was calculated, but can use these as a reference if we decide that the data needs to be cleaner.. Coco & Keller don't mention anything about data clearning, so not going to do anything here..

% function clean_fixations(input)


% function clean_saccades(input)



%% ------------ ADDL FUNCTIONS -------------- %%
%% ========================================== %%
%% Calculate additional eye movement features %%
%% ========================================== %%
%% ------------------------------------------ %%

%==============================================================
function init_time = initiation_time( trial_start, first_sacc )
% the amount of time it takes to make the first saccade in the trial

init_time = first_sacc - trial_start;


%================================================================
function num_fixations = number_of_fixations( fixation_duration )
% the total number of fixations in the trial

num_fixations = length(fixation_duration);


%===========================================================================================
function entropy_attn = entropy_of_attentional_landscape( x, y, fixation_duration, stim_imgs )
% (1) compute attentional landscapes by fitting 2D Gaussians on the (x,y) coords of each fixation, with the height of the Gaussian weighted by fixation duration and the 1 degree radius of visual angle.
% (2) Entropy of map is calculated with equation: \sum$_{x,y}$p(L$_{x,y}$)log$_{2}$p(L$_{x,y}$), where p(L$_{x,y}$) is the normalized fixation probability at point (x,y) in the landscape L.
% higher entropy should be related to more spread of the scenes.

% ---------
% init vars
w       = 1024; %stim width in pixels
h       = 768; %stim height in pixels
w_deg   = 23.8; %stim width in degrees of visual angle
h_deg   = 18.0; %stim height in degrees of visual angle

% ---------------------------------------------------------
% calculate the amount of pixels foveated for each fixation
foveated_radius = mean((w / w_deg), (h / h_deg)); %radius (in pixels) of the circle spanning 1 degree of visual angle at the fovea
foveated_pixels = pi * foveated_radius^2; %area (in pixels) of the circle spanning 1 degree of visual angle at the fovea

% -----------------
% map all fixations
% loop through each sample
fixations = cell(length(x), 2);
[cols, rows] = meshgrid(1:h, 1:w); %create the circle
for i = 1:length(x)
    fixations{i,1} = (cols - x(i)).^2 + (rows - y(i)).^2 <= foveated_radius.^2; %logical array of the pixels in the circle
    %! should ^^ use foveated pixels instead of foveated radius?
    fixations{i,2} = fixation_duration(i);
end

fix_map = zeros(h, w);
for i = 1:length(fixations)
    fix_vals    = fixations{i, 1} * fixations{i, 2}; %ones multiplied by the duration (weighting)
    fix_map     = fix_map + fix_vals; %add to the map
end

% ------------------
% calc 2-D Gaussians
% using the multivariate normal probability density function :: mvnpdf -- I think this is the same?
fixations_norm = mvnpdf(fix_map);

% -----------------
% calculate entropy
% using MATLAB entropy function (matches up with equation provided in C&K manuscript)
entropy_attn = entropy(fixations_norm);


%==========================================================================
function mean_sacc_amplitude = mean_saccade_amplitude( saccade_hypotenuse )
% the average distance covered by the saccades within the trial

mean_sacc_amplitude = mean(saccade_hypotenuse);


%==================================================================
function mean_fix_dur = mean_fixation_duration( fixation_duration )
% the average length of time of the fixations in the trial

mean_fix_dur = mean(fixation_duration);


%===================================================
function area_fixated = percent_area_fixated( x, y )
% percentage of the image covered by fixations, assuming a 1deg circle of foveated area. Overlapping areas are subtracted.

% ---------
% init vars
w       = 1024; %stim width in pixels
h       = 768; %stim height in pixels
w_deg   = 23.8; %stim width in degrees of visual angle
h_deg   = 18.0; %stim height in degrees of visual angle

% ---------------------------------------------------------
% calculate the amount of pixels foveated for each fixation
foveated_radius = mean((w / w_deg), (h / h_deg)); %radius (in pixels) of the circle spanning 1 degree of visual angle at the fovea
foveated_pixels = pi * foveated_radius^2; %area (in pixels) of the circle spanning 1 degree of visual angle at the fovea

% ------------------------
% determine if overlapping
fixation_location   = [x, y];
fixation_area       = length(x) * foveated_pixels; %the total area covered by fixations

% loop through each sample to map each fixation
pixels = cell(length(x), 1);
[cols, rows] = meshgrid(1:h, 1:w); %create the circle
for fixation = 1:length(x)
    pixels{fixation} = (cols - x(fixation)).^2 + (rows - y(fixation)).^2 <= foveated_radius.^2; %logical array of the pixels in the circle
end

% get the overlap
% the circle pixels will be ones, and everything else is zero, so we'll add them up to find the overlap
overlap = zeros(h, w);
for i = 1:length(pixels)
    overlap = overlap + pixels{i};
end

overlapping_pixels  = length(overlap(overlap > 1)); %this is the number of overlapping pixels

% ------------------------
% determine the percentage
total_area      = w * h; %total area of the stim
area_fixated    = fixation_area - overlapping_pixels; %total area fixated

area_fixated    = area_fixated / total_area;


%========================================================
%! ...not working... !%
function saliencyMap = img_saliency_calculation( img )
% calculate a saliency value for each pixel of each image

% stolen -- borrowed -- functions :: https://people.csail.mit.edu/tjudd/WherePeopleLook/Code/JuddSaliencyModel/  

% ---------------------------
% torralba et al. (2009) code
function saliencyMap = torralbaSaliency(img)
%
% written by Antonio Torralba 
% saliencyMap = saliency(img);
%
% If you call it without output arguments it will show two images.
% saliency = Product_i (hist(featuremap_i))

edges = 'reflect1';
pyrFilters = 'sp3Filters';

[nrows, ncols, cc]=size(img);
Nsc = 4;%maxPyrHt([nrows ncols], [15 15])-1; % Number of scales

[pyr, ind] = buildSpyr(double(mean(img,3)), Nsc, pyrFilters, edges);

weight = 2.^(1:Nsc);
sal = zeros(size(pyr));
saliencyMap = 1;
for b=2:size(ind,1)-1
    out =  pyrBand(pyr,ind,b);
    scale = floor((b-2)/6);

    [h,x] = hist(out(:), 100);
    h = h+1; h = h/sum(h);

    probOut = interp1(x, 1./h, out, 'nearest', min(h));   
    probOutR = imresize(probOut, [nrows ncols], 'bilinear');
    saliencyMap = saliencyMap + log(probOutR)*weight(scale+1);
end


if nargout == 0
    th = sort(saliencyMap(:));

    p = [0 .5 1];
    for n = 1:length(p)-1
        th1 = th(1+round(nrows*ncols*p(n)));
        th2 = th(round(nrows*ncols*p(n+1)));

        subplot(1,2,n)
        imagesc(img.*uint8(repmat((saliencyMap>th1).*(saliencyMap<=th2),[1 1 cc])))
        axis('equal'); axis('tight')
    end
end
    


%=============================================================
function saliency_fix = saliency_at_fixation( x, y, saliency )
% compute the saliency map of each scene using the model developed by Torralba, Oliva, Castelhano, and Henderson (2006), then map the (x,y) coordinates of each fixation onto the saliency map (assign saliency values to each coordinate location)
% use the saliency part of the equation, not the context part of the equation

saliency_fix = saliency(y, x);

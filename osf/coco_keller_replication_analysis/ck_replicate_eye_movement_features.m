function ck_replicate_eye_movement_features
% Replicating the Coco & Keller classification of eye movement data
% This script extracts the fixation/saccade statistics used by Coco &
% Keller to decode the eye movements.
% The features are saved at the end of this script, and the decoding models
% are run using R scripts (to replicate Coco & Keller).


%% NOTE %%
% This script calculates a bunch of eye movement features, including
% saliency. Saliency is calculated from a Torralba script that uses A TON 
% other .m and MEX files. In order for this to work, you might have to
% first compile the MEX files (even if this isn't fully necessary, the
% data will be processed much faster if these are compiled..).

% In order to compile, see the saliency calculation function (below), where
% the necessary steps to run the script are detailed (if need more info,
% the folder containing the Torralba scripts has READMEs that contain all
% of the necessary information.

% Also, make sure to add the folder (and subfolders) containing the
% Torralba saliency scripts to the path..!!


%% NOTE NOTE %%
% It is also worth noting that there are lines commented out that are
% dedicated to cleaning the data. The data cleaning steps are skipped
% because there was no mention in the Coco & Keller manuscript of data
% cleaning / processing besides the feature extraction.


%% --------- %%
%% init vars %%
%% --------- %%

% ------------------
% get absolute paths
% relative paths
data_dir            = '../exploratory';
toolbox_path        = '../uzh-edf-converter-fae25ca';

% get data dir
owd = pwd;
cd(data_dir);
data_dir = what(pwd);
data_dir = data_dir.path;

% get toolbox dir
cd(owd);
cd(toolbox_path);
toolbox_path = what(pwd);
toolbox_path = toolbox_path.path;

cd(owd);

% setup dirs
eye_dir             = sprintf('%s/data_eye', data_dir);
eye_files_struct    = dir([eye_dir '/*.edf']);
eye_files           = extractfield(eye_files_struct,'name');
txt_dir             = sprintf('%s/data_text', data_dir);

addpath(toolbox_path);

% vars
subj_data = cell(length(eye_files), 12);
data_size       = 0;

% text file options
probe_block_opt       = [ {'_probe_blocked'}, {'_noprobe_mixed'}, {'_probe_mixed'}, {'_noprobe_blocked'} ];


%% ------------------ %%
%% Calc Stim Saliency %%
%% ------------------ %%
% calculating the average saliency for each pixel location of each image
% the mapping of the fixations onto the image pixels is done in the saliency_fix function later on..

% ------------------
% calculate saliency
% saliency = cell(length(stim_fnames), 2);
% for img = 1:length(stim_fnames)
%     saliencyMap       = img_saliency_calculation(stim_fnames{img}); %stolen function
%     saliency{img, 1}  = saliencyMap; %assign saliency
%     saliency{img, 2}  = stim_fnames{img}; %assign img name
% end

% !-----------------------------------
% saliency values ^^ calculation above
saliency = load('ck_replication_img_saliency.mat');

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
    
    % cycle through probe types and block options
    for probe_opt = 1:length(probe_block_opt)
        txt_probe_block = probe_block_opt{probe_opt};
        txt_file        = sprintf( '%s/%s%s.txt', txt_dir, data_file(1:end-4), txt_probe_block ); %change from .edf to .txt
        
        if isfile(txt_file) %break away if is a file
            break
        else %assign zero val if not file
            txt_file = 0;
        end
    end
        
    % check file validity
    if txt_file == 0
        continue %if no good, need to cut bait
    end
    
    % read the data in
    txt_data    = readtable(txt_file); %get data
    stim_imgs   = txt_data.imagename; %isolate stim imgs
    stim_chng   = txt_data.imagechange; %label to denote anything added to the original img
    
    % ---------------------------------------------
    % get the stim name to match the stim file name
    for i = 1:length(stim_imgs)
        
        % determine if the img was modified
        if ~isempty(stim_chng{i})
            mod = 'b'; %all of the modified stims have a 'b'
        else
            mod = 'a';
        end
        
        % modify the fname to match
        stim_imgs{i} = erase(stim_imgs{i}, '_'); %remove the underscore
        
        % add in the mod
        if strcmp(mod, 'b')
            mod = sprintf('%s(%s)', mod, stim_chng{i});
        end
            
        % rename the img
        stim_imgs{i} = sprintf('%s%s', stim_imgs{i}, mod);
    end

    % ---------------
    % init trial vars
    trial_types             = nan(n_trials, 1);
    init_time               = nan(n_trials, 1);
    num_fixations           = nan(n_trials, 1);
    entropy_attn            = nan(n_trials, 1);
    mean_sacc_amplitude     = nan(n_trials, 1);
    mean_fix_dur            = nan(n_trials, 1);
    area_fixated            = nan(n_trials, 1);
    mean_fixation_saliency  = nan(n_trials, 1);

    % init other vars
    subj_num        = nan(n_trials, 1);
    subj_datfile    = cell(n_trials, 1);
    
    % assign other vars
    subj_num(:)     = current_file;
    subj_datfile(:) = {data_file};

    % -------------------
    % loop through trials
    % -------------------

    for i = 1:n_trials
        
        % get stim name and assign saliency
        for j = 1:length(saliency(:,2))
            % find the stim name within the filenames
            if contains(saliency{j,2}, stim_imgs{i})
                trial_saliency  = saliency{j,1};
                break
            end   
        end

        % mark the borders
        trial_start = start_times(i);
        trial_end = end_times(i);

        % get meta info
        trial_info_str = edf_info_strings{start_inds(i)};
        tt_ind = strfind(trial_info_str,'TRIALTYPE');
        trial_types(i) = str2double( trial_info_str( (tt_ind+9):(tt_ind+11) )); %works in very limited circumstances

        
        % --------------
        % aggregate data
        fixations   = edf_data.Events.Efix;
        saccades    = edf_data.Events.Esacc;

        fix_dur      = fixations.duration((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_x        = fixations.posX((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_y        = fixations.posY((fixations.start >= trial_start) & (fixations.end <= trial_end));

        sacc_start   = saccades.start((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_hypot   = saccades.hypot((saccades.start >= trial_start) & (saccades.end <= trial_end));
        
        
        %% -------------- %%
        %% clean the data %%
        %% -------------- %%
        % catch bad trials
        if isempty(sacc_start) %saccades
            fprintf('\n--Skipping bad trial (%i)', i);
            continue
        end
        
        if isempty(fix_dur) %fixations (just in case)
            fprintf('\n--Skipping bad trial (%i)', i);
            continue
        end
        
        % clean_fixations(input);
        % clean_saccades(input);
    
    
        %% ------------- %%
        %% calc features %%
        %% ------------- %%
        % calculate the features to be used in the analysis
        % all defined in functions at the end of the script
        % listed in order of importance, as determined by Coco & Keller
    
        init_time(i)                = initiation_time( trial_start, sacc_start(1) );
        num_fixations(i)            = number_of_fixations( fix_dur );
        entropy_attn(i)             = entropy_of_attentional_landscape( fix_x, fix_y, fix_dur );
        mean_sacc_amplitude(i)      = mean_saccade_amplitude( sacc_hypot );
        mean_fix_dur(i)             = mean_fixation_duration( fix_dur );
        area_fixated(i)             = percent_area_fixated( fix_x, fix_y );
        mean_fixation_saliency(i)   = saliency_at_fixation( fix_x, fix_y, trial_saliency );

    end


    %% ------------------- %%
    %% assign to subj data %%
    %% ------------------- %%

    subj_data{current_file, 1}  = subj_num; %subject number
    subj_data{current_file, 2}  = 1:n_trials; %trial numbers
    subj_data{current_file, 3}  = trial_types; %trial type (0,1,2)
    subj_data{current_file, 4}  = init_time; %time to initiate the first saccade
    subj_data{current_file, 5}  = num_fixations; %total number of fixations per trial
    subj_data{current_file, 6}  = entropy_attn; %entropy for the attentional landscape
    subj_data{current_file, 7}  = mean_sacc_amplitude; %mean saccade amplitude
    subj_data{current_file, 8}  = mean_fix_dur; %mean fixation duration
    subj_data{current_file, 9}  = area_fixated; %percent of area fixated
    subj_data{current_file, 10} = mean_fixation_saliency; %mean saliency at the fixation points of the trial
    subj_data{current_file, 11} = stim_imgs; %stim img
    subj_data{current_file, 12} = subj_datfile; %name of the subj data file

    % need to know how many rows to make
    data_size = data_size + n_trials;
end


%% -------------- %%
%% stack the data %%
%% -------------- %%

% clean out data (throw away the empties)
n_cols      = length(subj_data(1,:)); %number of columns in the dataset
subj_data   = reshape(subj_data(~cellfun('isempty',subj_data)), [], n_cols); %clean

% get new n_rows
n_rows      = length(subj_data(:,1));

% init vars
eye_data    = nan(data_size, 10); %data
eye_info    = cell(data_size, 2); %for cell features
iter_size   = length(subj_data{1,1});
x_inds      = 1;
y_inds      = x_inds + iter_size - 1;

% iterate through files
for i = 1:n_rows
    
    % update iteration length
    iter_size   = length(subj_data{i, 1});
    
    % x/y indices
    if i == 1 %set the initial indices
        x_inds = 1;
        y_inds = iter_size;
    else
        y_inds = y_inds + iter_size; %update y indices
    end
    
    % data
    eye_data(x_inds:y_inds, 1)  = subj_data{i, 1}; %subj_num
    eye_data(x_inds:y_inds, 2)  = subj_data{i, 2}; %trialnum
    eye_data(x_inds:y_inds, 3)  = subj_data{i, 3}; %trial_types
    eye_data(x_inds:y_inds, 4)  = subj_data{i, 4}; %init_time
    eye_data(x_inds:y_inds, 5)  = subj_data{i, 5}; %num_fixations
    eye_data(x_inds:y_inds, 6)  = subj_data{i, 6}; %entropy_attn
    eye_data(x_inds:y_inds, 7)  = subj_data{i, 7}; %mean_sacc_amplitude
    eye_data(x_inds:y_inds, 8)  = subj_data{i, 8}; %mean_fix_dur
    eye_data(x_inds:y_inds, 9)  = subj_data{i, 9}; %area_fixated
    eye_data(x_inds:y_inds, 10) = subj_data{i, 10}; %mean_fixation_saliency
    
    % info
    eye_info(x_inds:y_inds, 1) = subj_data{i, 11}; %stim_imgs
    eye_info(x_inds:y_inds, 2) = subj_data{i, 12}; %name of subj data file

    % update iter
    x_inds = x_inds + iter_size; %update x indices
end


%% --------- %%
%% gen table %%
%% --------- %%

eye_data_table = table(eye_data(:, 1), eye_data(:, 2), eye_data(:, 3), eye_data(:, 4), eye_data(:, 5), eye_data(:, 6), eye_data(:, 7), eye_data(:, 8), eye_data(:, 9), eye_data(:, 10), eye_info(:, 1), eye_info(:, 2), 'VariableNames', {'subj_num', 'trialnum', 'trialtype', 'init_time', 'num_fixations', 'entropy_attn', 'mean_sacc_amplitude', 'mean_fix_dur', 'area_fixated', 'mean_fixation_saliency', 'stim_imgs', 'datfile_name'});


%% ----------- %%
%% save output %%
%% ----------- %%

% .mat file
save('ck_features.mat', 'eye_data_table', '-v7.3');

% csv
writetable(eye_data_table, 'ck_features.csv', 'Delimiter', ' ');
writetable(eye_data_table, 'ck_features.csv', 'Delimiter', ',');






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
function entropy_attn = entropy_of_attentional_landscape( x, y, fixation_duration )
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
foveated_radius = mean( [(w / w_deg), (h / h_deg)] ); %radius (in pixels) of the circle spanning 1 degree of visual angle at the fovea

% --------------------------------
% map 2-D Gaussians onto fixations
% loop through each fixation
% fixations = cell(length(x), 2);
gaussians = cell(length(x), 1);
[cols, rows] = meshgrid(1:w, 1:h); %create the circle
for i = 1:length(x)
    gaussians{i,1} = fixation_duration(i) * exp( -((cols - x(i)).^2 + (rows - y(i)).^2) ./ (2 * foveated_radius.^2) );
end

gauss_map = zeros(h, w);
for i = 1:length(gaussians)
    gauss_map(gauss_map == 0) = gauss_map(gauss_map == 0) + gaussians{i}(gauss_map == 0);
    gauss_map(gauss_map ~= 0) = ( gauss_map(gauss_map ~= 0) + gaussians{i}(gauss_map ~= 0) ) ./ 2;
end

% -----------------
% calculate entropy
% using MATLAB entropy function (matches up with equation provided in C&K manuscript)
entropy_attn = entropy(gauss_map);


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
foveated_radius = mean([ (w / w_deg), (h / h_deg) ]); %radius (in pixels) of the circle spanning 1 degree of visual angle at the fovea
foveated_pixels = pi * foveated_radius^2; %area (in pixels) of the circle spanning 1 degree of visual angle at the fovea

% ------------------------
% determine if overlapping
% fixation_location   = [x, y];
fixation_area       = length(x) * foveated_pixels; %the total area covered by fixations

% loop through each sample to map each fixation
pixels = cell(length(x), 1);
[cols, rows] = meshgrid(1:w, 1:h); %create the circle
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


%=====================================================
function saliencyMap = img_saliency_calculation( img )
% calculate a saliency value for each pixel of each image
% NOTE: For this to work, need to make sure the folder containing the
% collection of scripts that this function uses are included in the MATLAB
% path.
% Also, need to complile the MEX files with the script provided in the MEX
% folder: compilePyrTools.m

% read in the img
img = imread(img); 

% borrowed functions :: https://people.csail.mit.edu/tjudd/WherePeopleLook/Code/JuddSaliencyModel/  
saliencyMap = torralbaSaliency( img );

% ---------------------------
% torralba et al. (2009) code
function saliencyMap = torralbaSaliency( img )
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
    


%=======================================================================
function mean_fixation_saliency = saliency_at_fixation( x, y, saliency )
% compute the saliency map of each scene using the model developed by Torralba, Oliva, Castelhano, and Henderson (2006), then map the (x,y) coordinates of each fixation onto the saliency map (assign saliency values to each coordinate location)
% use the saliency part of the equation, not the context part of the equation
% take the mean saliency of all mean saliency values for each fixations in the trial

% ---------
% init vars
w_sal   = size(saliency, 2); %width of the saliency obj
h_sal   = size(saliency, 1); %height of saliency obj
w       = 1028; %width of the stim img
h       = 768; %height of the stim img
w_deg   = 23.8; %stim width in degrees of visual angle
h_deg   = 18.0; %stim height in degrees of visual angle

% ---------------------------------------------------------
% calculate the amount of pixels foveated for each fixation
foveated_radius = mean([ (w / w_deg), (h / h_deg) ]); %radius (in pixels) of the circle spanning 1 degree of visual angle at the fovea

% -------------------
% get saliency values
% loop through each sample to map each fixation
fixation_saliency = nan(length(x), 1);
[cols, rows] = meshgrid(1:w_sal, 1:h_sal); %create the circle (with the saliency size parameters)
for fixation = 1:length(x)
    % get fixation location
    fovea                       = (cols - x(fixation)).^2 + (rows - y(fixation)).^2 <= foveated_radius.^2; %logical array of the pixels in the circle
    
    % get saliency values at the fixation location
    fovea_saliency              = saliency(fovea);
    fixation_saliency(fixation) = mean(fovea_saliency); %average
end

mean_fixation_saliency = mean(fixation_saliency);

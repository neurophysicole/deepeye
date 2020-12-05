function ck_replicate_eye_movement_features
% Extracting fixation and saccade statistics from the edf files..


%% --------- %%
%% init vars %%
%% --------- %%

data_dir            = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/E1-8/LaurenElise/Exp1/exp1_v4/data/data_eyelink';
all_files_struct    = dir([data_dir '/*.edf']);
all_files           = extractfield(all_files_struct,'name');
toolbox_path        = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/mrj_matlab_scripts/uzh-edf-converter-fae25ca';
addpath(toolbox_path);

subj_data = cell(length(all_files), 9);

current_subj = 0;


%% ------------------------ %%
%% cycle through data files %%
%% ------------------------ %%

for current_file = 1:length(all_files)
    data_file = all_files{current_file};
    
    % -----------------------------------------
    % some of these files are busted, skip them
    try
        % edf_data = Edf2Mat( join([data_dir,'/',data_file]) );
        owd = pwd;
        cd(data_dir);
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

    % ---------------
    % init trial vars
    trial_types         = nan(n_trials,1);
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
        trial_data{i} = [edf_data.Samples.posX(trial_inds) edf_data.Samples.posY(trial_inds) edf_data.Samples.pupilSize(trial_inds)];
        
        % get meta info
        trial_info_str = edf_info_strings{start_inds(i)};
        tt_ind = strfind(trial_info_str,'TRIALTYPE');
        trial_types(i) = str2double( trial_info_str( (tt_ind+9):(tt_ind+11) )); %works in very limited circumstances
        %! bt_ind = strfind(trial_info_str,'BLOCKTYPE');
        %! block_types(i) = str2double( trial_info_str( (bt_ind+9):end )); %works in very limited circumstances

        
        % --------------
        % aggregate data
        fixations   = edf_data.Events.Efix;
        saccades    = edf_data.Events.Esacc;

        fix_start    = fixations.start((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_end      = fixations.end((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_dur      = fixations.duration((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_x        = fixations.posX((fixations.start >= trial_start) & (fixations.end <= trial_end));
        fix_y        = fixations.posY((fixations.start >= trial_start) & (fixations.end <= trial_end));

        sacc_start   = saccades.start((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_end     = saccades.end((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_dur     = saccades.duration((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_x       = saccades.posX((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_y       = saccades.posY((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_x_end   = saccades.posXend((saccades.start >= trial_start) & (saccades.end <= trial_end));
        sacc_y_end   = saccades.posYend((saccades.start >= trial_start) & (saccades.end <= trial_end));
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
        entropy_attn(i)        = entropy_of_attentional_landscape(input);
        mean_sacc_amplitude(i) = mean_sacade_amplitude( sacc_hypot );
        mean_fix_dur(i)        = mean_fixation_duration( fix_dur );
        area_fixated(i)        = percent_area_fixated( fix_x, fix_y );
        saliency_fix(i)        = saliency_at_fixation(input);

    end




    %% ------------------- %%
    %% assign to subj data %%
    %% ------------------- %%

    %! will need to stack it then assign it...

    %? trialnum

    subj_data{current_file, 1} = clean_fixations;
    subj_data{current_file, 2} = clean_saccades;
    subj_data{current_file, 3} = init_time;
    subj_data{current_file, 4} = num_fixations;
    subj_data{current_file, 5} = entropy_attn;
    subj_data{current_file, 6} = mean_sacc_amplitude;
    subj_data{current_file, 7} = mean_fix_dur;
    subj_data{current_file, 8} = area_fixated;
    subj_data{current_file, 9} = saliency_fix;

end


%% --------- %%
%% gen table %%
%% --------- %%

eye_data = table(trialnum, trial_type, subj_data{:, 1}, subj_data{:, 2}, subj_data{:, 3}, subj_data{:, 4}, subj_data{:, 5}, subj_data{:, 6}, subj_data{:, 7}, subj_data{:, 8}, subj_data{:, 9}, 'VariableNames', {'trialnum', 'trial_type', 'clean_fixations', 'clean_saccades', 'init_time', 'num_fixations', 'entropy_attn', 'mean_sacc_amplitude', 'mean_fix_dur', 'area_fixated', 'saliency_fix'});


%% ----------- %%
%% save output %%
%% ----------- %%

% .mat file
save('ck_features.mat', 'eye_data', '-v7.3');

% csv
save('ck_features.csv', 'eye_data');


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

initiation_time = first_sacc - trial_start;


%================================================================
function num_fixations = number_of_fixations( fixation_duration )
% the total number of fixations in the trial

num_fixations = length(fixation_duration);


%!===========================
function entropy_attn(input)


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
fixation_location   = (x, y);
fixation_area       = length(x) * foveated_pixels; %the total area covered by fixations

% loop through each sample
pixels = cell(length(x), 1);
[cols, rows] = meshgrid(1:h, 1:w); %create the circle
for f = 1:length(x)
    pixels{f} = (cols - x(f)).^2 + (rows - y(f)).^2 <= foveated_radius.^2; %logical array of the pixels in the circle
end

% get the overlap
overlap             = pixels + pixels; %the circle pixels will be ones, and everything else is zero, so we'll add them up to find the overlap
overlapping_pixels  = length(overlap(overlap > 1)); %this is the number of overlapping pixels

% ------------------------
% determine the percentage
total_area      = w * h; %total area of the stim
area_fixated    = fixation_area - overlapping_pixels; %total area fixated

area_fixated    = area_fixated / total_area;


%!===========================
function fix_saliency(input)

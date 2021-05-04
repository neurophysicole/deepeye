function edf_to_mat_only_y

% ------------------
% get absolute paths
% relative paths
data_dir        = '../../data_eye';
toolbox_path    = '../../../uzh-edf-converter-fae25ca';

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

% get output dir
output_dir = pwd;

all_files_struct    = dir([data_dir '/*.edf']);
all_files           = extractfield(all_files_struct,'name');
addpath(toolbox_path);

% end config
current_subj = 0;
imdata = [];
good_trial_data_interp_flat = [];
good_trial_data_trialtype_labels = [];
good_trial_data_subject_labels = [];

for current_file = 1:length(all_files)
    data_file = all_files{current_file};
    
    %some of these files are busted, skip them
    try
        owd = pwd;
        cd(data_dir);
        edf_data = Edf2Mat( data_file );
        cd(owd);
        fprintf('Loaded: %s\n', data_file);
    catch
        fprintf('\n\nproblem importing: %s -- skipping this file.\n\n', data_file );
        continue
    end

    edf_info_strings = edf_data.Events.Messages.info';
    start_inds = ~cellfun('isempty',strfind(edf_info_strings,'START TRIAL'));
    end_inds = ~cellfun('isempty',strfind(edf_info_strings,'STOP TRIAL'));

    start_inds = find(start_inds);
    end_inds = find(end_inds);

    start_times = edf_data.Events.Messages.time( start_inds );
    end_times = edf_data.Events.Messages.time( end_inds ); %#ok<FNDSB>

    n_trials = numel(start_inds);

    trial_data = cell(n_trials,1);
    trial_types = nan(n_trials,1);
    block_types = nan(n_trials,1);
    for i = 1:n_trials
        this_start = start_times(i);
        this_end = end_times(i);

        samp_inds = (edf_data.Samples.time >= this_start) & (edf_data.Samples.time <= this_end);
        trial_data{i} = [zeros(length(edf_data.Samples.posX(samp_inds)),1) edf_data.Samples.posY(samp_inds) zeros(length(edf_data.Samples.pupilSize(samp_inds)),1)];

        this_info_str = edf_info_strings{start_inds(i)};
        tt_ind = strfind(this_info_str,'TRIALTYPE');
        trial_types(i) = str2double( this_info_str( (tt_ind+9):(tt_ind+11) )); %works in very limited circumstances
        bt_ind = strfind(this_info_str,'BLOCKTYPE');
        block_types(i) = str2double( this_info_str( (bt_ind+9):end )); %works in very limited circumstances

    end

    for i = 1:length(trial_data)
        trial_length = size(trial_data{i},1);
        if (trial_length < 6000) || (all(isnan(trial_data{i}(1:2000)))) || (all(trial_data{i}(:,1)<-32000)) || (all(trial_data{i}(:,2)<-32000))
            trial_data{i} = [];
        else 
            trial_data{i} = trial_data{i}(1:6000,:);
        end
    end
        
    good_trial_data = trial_data(~cellfun('isempty',trial_data));
    good_trial_types = trial_types(~cellfun('isempty',trial_data));
    
    %first loop: split out various nan-handling streams
    set(groot, 'DefaultFigureVisible', 'off');
    for i = 1:length(good_trial_data)
        good_trial_data_interp{i} = fillmissing(good_trial_data{i},'linear',1,'EndValues','nearest');
        %image versions
        scatter(good_trial_data_interp{i}(:,1),good_trial_data_interp{i}(:,2),good_trial_data_interp{i}(:,3));
        %some trials are a flat -32768, but the next minimum is up at -1017ish so those are definitely some kind of bad data
        xlim([-1050 2100]);
        ylim([-1050 2100]);
        axis('off')
        cdata = print('-RGBImage');
        gscale(i,:,:) = rgb2gray(cdata);
        close all
    end
    set(groot, 'DefaultFigureVisible', 'on');
    
    %second loop: stack data
    for i = 1:length(good_trial_data)
        imdata = [imdata; gscale(i,:,:)];
        good_trial_data_interp_flat = [good_trial_data_interp_flat; reshape(good_trial_data_interp{i},1,18000)];
        good_trial_data_trialtype_labels = [good_trial_data_trialtype_labels; trial_types(i)];
        good_trial_data_subject_labels = [good_trial_data_subject_labels; current_subj];
    end
    
    current_subj = current_subj+1;
end
% presumably save output here or whatnot
fname = sprintf('%s/confirmatory_timeline_only_y_eyelink_data_interp_flat.mat', output_dir);
save(fname,'good_trial_data_interp_flat', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3');

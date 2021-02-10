function edf_to_mat_only_y

data_dir = '../../data_eye';
all_files_struct = dir([data_dir '/*.edf']);
all_files = extractfield(all_files_struct,'name');
toolbox_path = '../../../uzh-edf-converter-fae25ca';
addpath(toolbox_path);

%data_file = 'jg2.edf';

% end config
current_subj = 0;
imdata = [];
good_trial_data_coded_flat = [];
good_trial_data_interp_flat = [];
good_trial_data_2000_coded_flat = [];
good_trial_data_2000_interp_flat = [];
good_trial_data_trialtype_labels = [];
good_trial_data_subject_labels = [];

for current_file = 1:length(all_files)
    data_file = all_files{current_file};
    
%some of these files are busted, skip them
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

    edf_info_strings = edf_data.Events.Messages.info';
    start_inds = ~cellfun('isempty',strfind(edf_info_strings,'START TRIAL'));
    end_inds = ~cellfun('isempty',strfind(edf_info_strings,'STOP TRIAL'));

    start_inds = find(start_inds);
    end_inds = find(end_inds);

    start_times = edf_data.Events.Messages.time( start_inds );
    end_times = edf_data.Events.Messages.time( end_inds ); %#ok<FNDSB>

    n_trials = numel(start_inds);

    %figure;

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

        %scatter(trial_data{i}(:,1),trial_data{i}(:,2));
        %pause(.1);
    end

    %for i = 1:120; trial_length(i)=size(trial_data{i},1); end

    %this is grossly inefficient but I am too sleepy and lazy to clean it
    %up right now
    for i = 1:length(trial_data)
        trial_length = size(trial_data{i},1);
        if (trial_length < 6000) || (all(isnan(trial_data{i}(1:2000)))) || (all(trial_data{i}(:,1)<-32000)) || (all(trial_data{i}(:,2)<-32000))
            trial_data{i} = [];
            trial_data_2000{i} = [];
        else 
            trial_data{i} = trial_data{i}(1:6000,:);
            trial_data_2000{i} = trial_data{i}(1:2000,:);
        end
    end
    
    %for i = 1:120; temp(i,:) = size(find(all(isnan(trial_data_2000{i})))); end
    
    good_trial_data = trial_data(~cellfun('isempty',trial_data));
    good_trial_data_2000 = trial_data_2000(~cellfun('isempty',trial_data_2000));
    good_trial_types = trial_types(~cellfun('isempty',trial_data));
    
    %first loop: split out various nan-handling streams
    set(groot, 'DefaultFigureVisible', 'off');
    for i = 1:length(good_trial_data)
        %[good_trial_data_trimmed{i}, indices{i}] = rmmissing(good_trial_data{i});
        good_trial_data_coded{i} = fillmissing(good_trial_data{i},'constant',-1);
        good_trial_data_interp{i} = fillmissing(good_trial_data{i},'linear',1,'EndValues','nearest');
        good_trial_data_2000_coded{i} = fillmissing(good_trial_data_2000{i},'constant',-1);
        good_trial_data_2000_interp{i} = fillmissing(good_trial_data_2000{i},'linear',1,'EndValues','nearest');
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
        good_trial_data_coded_flat = [good_trial_data_coded_flat; reshape(good_trial_data_coded{i},1,18000)];
        good_trial_data_interp_flat = [good_trial_data_interp_flat; reshape(good_trial_data_interp{i},1,18000)];
        good_trial_data_2000_coded_flat = [good_trial_data_2000_coded_flat; reshape(good_trial_data_2000_coded{i},1,6000)];
        good_trial_data_2000_interp_flat = [good_trial_data_2000_interp_flat; reshape(good_trial_data_2000_interp{i},1,6000)];
        good_trial_data_trialtype_labels = [good_trial_data_trialtype_labels; trial_types(i)];
        good_trial_data_subject_labels = [good_trial_data_subject_labels; current_subj];
    end
    
    if find(isnan(good_trial_data_2000_interp_flat))
        keyboard
    end
    
    current_subj = current_subj+1;
end
% presumably save output here or whatnot
save('exploratory_timeline_only_y_eyelink_data_coded_flat.mat','good_trial_data_coded_flat', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')
save('exploratory_timeline_only_y_eyelink_data_interp_flat.mat','good_trial_data_interp_flat', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')
save('exploratory_timeline_only_y_eyelink_data_2000_coded_flat.mat','good_trial_data_2000_coded_flat', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')
save('exploratory_timeline_only_y_eyelink_data_2000_interp_flat.mat','good_trial_data_2000_interp_flat', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')
save('exploratory_eyelink_data_img.mat','imdata', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')

%%do some by-feature-type scaling
segments = [1:6000; 6001:12000; 12001:18000];

centered_data = zeros(size(good_trial_data_coded_flat));
standardized_data = zeros(size(good_trial_data_coded_flat));
normalized_data = zeros(size(good_trial_data_coded_flat));
for i = 1:size(segments,1)
    data_segment = good_trial_data_coded_flat(:,segments(i,:));
    univmax(i) = max(data_segment(:));
    univmin(i) = min(data_segment(:));
    univmean(i) = mean(data_segment(:));
    univstd(i) = std(data_segment(:));
    centered_data(:,segments(i,:)) = good_trial_data_coded_flat(:,segments(i,:)) - univmean(i);
    standardized_data(:,segments(i,:)) = (good_trial_data_coded_flat(:,segments(i,:)) - univmean(i))./univstd(i);
    normalized_data(:,segments(i,:)) = (good_trial_data_coded_flat(:,segments(i,:)) - univmin(i))./(univmax(i)-univmin(i));
end

save('exploratory_timeline_only_y_eyelink_data_centered.mat','centered_data', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')
save('exploratory_timeline_only_y_eyelink_data_standardized.mat','standardized_data', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')
save('exploratory_timeline_only_y_eyelink_data_normalized01.mat','normalized_data', 'good_trial_data_trialtype_labels', 'good_trial_data_subject_labels', '-v7.3')


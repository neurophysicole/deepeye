function edf2img_kkequated_noy_filled

data_dir = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/confirming_initial_model/exp_9_nochanges/data_v4';
% data_files = {'jg2.edf' 'jg4.edf' 'jg6.edf' 'jg8.edf' 'jg10.edf' 'jg12.edf' 'jg15.edf' 'jg16.edf' 'jg18.edf'};
data_file_pattern = '*.edf';
toolbox_path = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/mrj_matlab_scripts/uzh-edf-converter-fae25ca';
output_folder = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/confirming_initial_model/exp_9_nochanges/image_set/no_y/filled/images';
min_trial_length = 6000;
marker_size = 1000;
output_file_pattern = 'exp9_img_kkequated_noy_filled_overall_trial_%.5d_subj%.3d_trialtype%d_blocktype%d.png';

% end config

addpath(toolbox_path);

% this seems to crash Matlab for unknown reasons
% this_file = fullfile(data_dir, data_file);
% edf_data = Edf2Mat( this_file );

% weirdly, this seems OK
owd = pwd;
cd(data_dir);

data_files = dir(data_file_pattern);
data_files = {data_files.name};

n_subs = numel(data_files);
cumu_img_ind = 1;

figure;
%change background color
%whitebg('blue');
%turn off inverthardcopy so it will save with background color
%if not set, background color saves as white (or really light gray?)
%set(figure, 'InvertHardcopy', 'off');

% pause; %could comment out for speed

% data_files = {'jm30.edf'};

for i = 1:n_subs
    try
        edf_data = Edf2Mat( data_files{i} );
        fprintf('Loaded: %s\n', data_files{i});
    catch
        fprintf('\n\nproblem importing: %s -- skipping this file.\n\n', data_files{i} );
        continue;
    end
    edf_info_strings = edf_data.Events.Messages.info';
    start_inds = ~cellfun('isempty',strfind(edf_info_strings,'START TRIAL'));
    end_inds = ~cellfun('isempty',strfind(edf_info_strings,'STOP TRIAL'));
    start_inds = find(start_inds);
    end_inds = find(end_inds);
    start_times = edf_data.Events.Messages.time( start_inds );
    end_times = edf_data.Events.Messages.time( end_inds ); %#ok<FNDSB>
    
    n_trials = numel(start_inds);    for j = 1:n_trials
        this_start = start_times(j);
        this_end = end_times(j);
        
        samp_inds = (edf_data.Samples.time >= this_start) & (edf_data.Samples.time <= this_end);
        trial_data = [edf_data.Samples.posX(samp_inds) edf_data.Samples.posY(samp_inds) edf_data.Samples.pupilSize(samp_inds)];
        if size(trial_data,1) < min_trial_length
            %could comment out line below for speed (or could also make more informative)
            disp('short trial -- skipping');
            continue;
        end
        trial_data = trial_data(1:min_trial_length, :);
        
        this_info_str = edf_info_strings{start_inds(j)};
        tt_ind = strfind(this_info_str,'TRIALTYPE');
        trial_type = str2double( this_info_str( (tt_ind+9):(tt_ind+11) )); %works in very limited circumstances
        bt_ind = strfind(this_info_str,'BLOCKTYPE');
        block_type = str2double( this_info_str( (bt_ind+9):end )); %works in very limited circumstances
        
        trial_data = fillmissing(trial_data,'linear',1,'EndValues','nearest');

        %make the pupil size
        datax = trial_data(:,1);
        datay = (trial_data(:,2)*0);
        markerdata = (trial_data(:,3));
        markerSize = ((markerdata/10)+1);%*.01) + 0.01).^2.5; %markers scaled down, then squared(ish) to emphasize pupil size differences
%         badMarkerSize = markerSize == 0;
% 
%         %Remove the bad ones from the arrays before plotting.
%         if ~isempty(badMarkerSize)
%             markerSize(badMarkerSize) = [];
%             datax(badMarkerSize,:) = [];
%             markerdata(badMarkerSize,:) = [];
%         end
        
        colormap(gray);
        %invert scatterplot grayscale
        colormap(1-(gray/255)*255); %only changes data points, not background
        
        try
            %scatter(trial_data(:,1),trial_data(:,2),marker_size,1:numel(trial_data(:,1)),'filled');
            scatter(datax, datay, markerSize, 1:numel(trial_data(:,1)),'filled');
        
            axis equal;
            xlim([0 1024]); ylim([0 768]);
    %         pause(.1); %could comment out for speed
            imgfilename = sprintf(output_file_pattern,cumu_img_ind,i,trial_type,block_type);
            fprintf('writing out: %s\n', imgfilename);
            imgfilename = fullfile(output_folder, imgfilename);
            cumu_img_ind = cumu_img_ind + 1;
            axis off;
            print('-dpng','-r60',imgfilename);
        catch
            disp('\n\nNo good. Not sure why.\n\n');
            continue;
        end
    end
    
end



cd(owd);

% keyboard;

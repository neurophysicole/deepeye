function img_ave_xy

data_dir = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/E1-8/LaurenElise/Exp1/exp1_v4/data/data_eyelink';
% data_files = {'jg2.edf' 'jg4.edf' 'jg6.edf' 'jg8.edf' 'jg10.edf' 'jg12.edf' 'jg15.edf' 'jg16.edf' 'jg18.edf'};
data_file_pattern = '*.edf';
toolbox_path = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/mrj_matlab_scripts/uzh-edf-converter-fae25ca';
output_folder = '/Users/zjcole/Box/projects/deepeye/dev_git/deepeye/images/ave_imgs';
min_trial_length = 6000;
marker_size = 350;
output_file_pattern = 'ave_xy.png';

addpath(toolbox_path);

owd = pwd;
cd(data_dir);

data_files = dir(data_file_pattern);
data_files = {data_files.name};

n_subs = numel(data_files);
cumu_img_ind = 1;

figure;

% added in
datax       = zeros(6000,1);
datay       = zeros(6000,1);
num_files   = 0;

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
    
    n_trials = numel(start_inds);    
    for j = 1:n_trials
        this_start = start_times(j);
        this_end = end_times(j);
        
        samp_inds = (edf_data.Samples.time >= this_start) & (edf_data.Samples.time <= this_end);
        trial_data = [edf_data.Samples.posX(samp_inds) edf_data.Samples.posY(samp_inds) edf_data.Samples.pupilSize(samp_inds)];
        if size(trial_data,1) < min_trial_length
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
        
        
        datax = datax + trial_data(:,1);
        datay = datay + trial_data(:,2);
        
        num_files = num_files + 1;
    end
end
    
% calc averages
datax = datax / num_files;
datay = datay / num_files;
% --

colormap(gray);
colormap(1-(gray/255)*255); %only changes data points, not background

try
    scatter(datax, datay, marker_size, 1:numel(trial_data(:,1)),'filled');

    axis equal;
    xlim([0 1024]); ylim([0 768]);
    imgfilename = sprintf(output_file_pattern,cumu_img_ind,i,trial_type,block_type);
    fprintf('writing out: %s\n', imgfilename);
    imgfilename = fullfile(output_folder, imgfilename);
    axis off;
    print('-dpng','-r60',imgfilename);
catch
    disp('\n\nNo good. Not sure why.\n\n');
end


cd(owd);

% keyboard;

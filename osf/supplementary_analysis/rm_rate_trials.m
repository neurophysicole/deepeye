function rm_search_trials
% --
% E1
data = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/no_mem_trials/data/e1/z_exp1_v4_eyelink_data_interp_flat.mat';
load(data);

good_trial_data_interp_flat     = good_trial_data_interp_flat( good_trial_data_trialtype_labels ~= 2, : ); %cut out mem trials from data
good_trial_data_subject_labels  = good_trial_data_subject_labels( good_trial_data_trialtype_labels ~= 2 ); %cut out mem trials from subjs
good_trial_data_trialtype_labels= good_trial_data_trialtype_labels( good_trial_data_trialtype_labels ~= 2 ); %cut out mem trials


% good_trial_data_trialtype_labels(good_trial_data_trialtype_labels == 1) = 1; %change 2s to 1s

% 0 == Search, 1 == Memorize

save('e1_norate.mat', '-v7.3');
clear all; close all;

% --
% E2
data = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/no_mem_trials/data/e9/z_exp9_v4_eyelink_data_interp_flat.mat';
load(data);

good_trial_data_interp_flat     = good_trial_data_interp_flat( good_trial_data_trialtype_labels ~= 2, : ); %cut out mem trials from data
good_trial_data_subject_labels  = good_trial_data_subject_labels( good_trial_data_trialtype_labels ~= 2 ); %cut out mem trials from subjs
good_trial_data_trialtype_labels= good_trial_data_trialtype_labels( good_trial_data_trialtype_labels ~= 2 ); %cut out mem trials

% good_trial_data_trialtype_labels(good_trial_data_trialtype_labels == 1) = 0; %change 1s to 0s
% good_trial_data_trialtype_labels(good_trial_data_trialtype_labels == 2) = 1; %change 2s to 1s

% 0 == Search, 1 == Rate

save('e9_norate.mat', '-v7.3');
clear all; close all;
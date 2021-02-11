function rm_mem_trials
% --
% E1
data = '../exploratory/scripts_timeline/full/exploratory_timeline_eyelink_data_interp_flat.mat';
load(data);

good_trial_data_interp_flat     = good_trial_data_interp_flat( good_trial_data_trialtype_labels ~= 1, : ); %cut out mem trials from data
good_trial_data_subject_labels  = good_trial_data_subject_labels( good_trial_data_trialtype_labels ~= 1 ); %cut out mem trials from subjs
good_trial_data_trialtype_labels= good_trial_data_trialtype_labels( good_trial_data_trialtype_labels ~= 1 ); %cut out mem trials

good_trial_data_trialtype_labels(good_trial_data_trialtype_labels == 2) = 1; %change 2s to 1s

% 0 == Search, 1 == Rate

save('exploratory/exploratory_nomem.mat', '-v7.3');
clear all; close all;

% --
% E2
data = '../confirmatory/scripts_timeline/full/confirmatory_timeline_data_eyelink_data_interp_flat.mat';
load(data);

good_trial_data_interp_flat     = good_trial_data_interp_flat( good_trial_data_trialtype_labels ~= 1, : ); %cut out mem trials from data
good_trial_data_subject_labels  = good_trial_data_subject_labels( good_trial_data_trialtype_labels ~= 1 ); %cut out mem trials from subjs
good_trial_data_trialtype_labels= good_trial_data_trialtype_labels( good_trial_data_trialtype_labels ~= 1 ); %cut out mem trials

good_trial_data_trialtype_labels(good_trial_data_trialtype_labels == 2) = 1; %change 2s to 1s

% 0 == Search, 1 == Rate

save('confirmatory/confirmatory_nomem.mat', '-v7.3');
clear all; close all;
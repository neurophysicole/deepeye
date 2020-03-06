function z_results_postprocess_confusion_matrices_eye_tracking( file, nits )

% initial parameters
path        = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/confirming_initial_model/';
fname_stem  = string(zeros(46));
nits        = 10;

%in order of how they are in the fname_stem and lists so these
%can be used as the titles
results = [
    {'E1 Image-Filled'}, {'E1 Image-Hollow'},...
    {'E9 Image-Filled'}, {'E9 Image-Hollow'},...
    {'E1 Image NoPupsz-Filled'}, {'E1 Image NoPupsz-Hollow'},...
    {'E9 Image NoPupsz-Filled'}, {'E9 Image NoPupsz-Hollow'},...
    {'E1 Image NoTime-Filled'}, {'E1 Image NoTime-Hollow'},...
    {'E9 Image NoTime-Filled'}, {'E9 image NoTime-Hollow'},...
    {'E1 Image NoX-Filled'}, {'E1 Image NoX-Hollow'},...
    {'E9 Image NoX-Filled'}, {'E9 Image NoX-Hollow'},...
    {'E1 Image NoY-Filled'}, {'E1 Image NoY-Hollow'},...
    {'E9 Image NoY-Filled'}, {'E9 Image_NoY-Hollow'},...
    {'E1 Image OnlyPupsz-Filled'}, {'E1 Image OnlyPupsz-Hollow'},...
    {'E9 Image OnlyPupsz-Filled'}, {'E9 Image OnlyPupsz-Hollow'},...
    {'E1 Image OnlyX-Filled'}, {'E1 Image OnlyX-Hollow'},...
    {'E9 Image OnlyX-Filled'}, {'E9 Image OnlyX-Hollow'},...
    {'E1 Image OnlyY-Filled'}, {'E1 Image OnlyY-Hollow'},...
    {'E9 Image OnlyY-Filled'}, {'E9 Image OnlyY-Hollow'},...
    {'E1 Timeline 6s'}, {'E9 6s Timeline'},...
    {'E1 Timeline NoPupsz'}, {'E9 Timeline NoPupsz'},...
    {'E1 Timeline NoX'}, {'E9 Timeline NoX'},...
    {'E1 Timeline NoY'}, {'E9 Timeline NoY'},...
    {'E1 Timeline OnlyPupsz'}, {'E9 Timeline OnlyPupsz'},...
    {'E1 Timeline OnlyX'}, {'E9 Timeline OnlyX'},...
    {'E1 Timeline OnlyY'}, {'E9 Timeline OnlyY'}
    ];

names = [
    {'XYP_img_e1'}, {'E1 Image-Hollow'},...
    {'XYP_img_e9'}, {'E9 Image-Hollow'},...
    {'XY0_img_e1'}, {'E1 Image NoPupsz-Hollow'},...
    {'XY0_img_e9'}, {'E9 Image NoPupsz-Hollow'},...
    {'E1 Image NoTime-Filled'}, {'E1 Image NoTime-Hollow'},...
    {'E9 Image NoTime-Filled'}, {'E9 image NoTime-Hollow'},...
    {'0YP_img_e1'}, {'E1 Image NoX-Hollow'},...
    {'0YP_img_e9'}, {'E9 Image NoX-Hollow'},...
    {'X0P_img_e1'}, {'E1 Image NoY-Hollow'},...
    {'X0P_img_e9'}, {'E9 Image_NoY-Hollow'},...
    {'00P_img_e1'}, {'E1 Image OnlyPupsz-Hollow'},...
    {'00P_img_e9'}, {'E9 Image OnlyPupsz-Hollow'},...
    {'X00_img_e1'}, {'E1 Image OnlyX-Hollow'},...
    {'X00_img_e9'}, {'E9 Image OnlyX-Hollow'},...
    {'0Y0_img_e1'}, {'E1 Image OnlyY-Hollow'},...
    {'0Y0_img_e9'}, {'E9 Image OnlyY-Hollow'},...
    {'XYP_timeline_e1'}, {'XYP_timeline_e9'},...
    {'XY0_timeline_e1'}, {'XY0_timeline_e9'},...
    {'0YP_timeline_e1'}, {'0YP_timeline_e9'},...
    {'X0P_timeline_e1'}, {'X0P_timeline_e9'},...
    {'00P_timeline_e1'}, {'00P_timeline_e9'},...
    {'X00_timeline_e1'}, {'X00_timeline_e9'},...
    {'0Y0_timeline_e1'}, {'0Y0_timeline_e9'}
    ];

%=======
% IMAGE
%=======

%6s
e1_6s_filled_path   = 'exp_1_img_kkequated/filled/results/';
e1_6s_hollow_path   = 'exp_1_img_kkequated/hollow/results/';
e9_6s_filled_path   = 'exp_9_nochanges/image_set/6s/filled/results/';
e9_6s_hollow_path   = 'exp_9_nochanges/image_set/6s/hollow/results/';

e1_fname_6s_filled  = 'exp1_kkequated_model03b_filledpupilbw_inv_12615_trials';
e1_fname_6s_hollow  = 'exp1_model03b_kkequated_hollowpupilbw_confirmatory_12634_trials';
e9_fname_6s_filled  = 'exp9_kkequated_model03b_filledpupilbw_inv_8301_trials';
e9_fname_6s_hollow  = 'exp9_model03b_kkequated_hollowpupilbw_confirmatory_8301_trials';

fname_stem(1)       = [ e1_6s_filled_path, e1_fname_6s_filled ];
fname_stem(2)       = [ e1_6s_hollow_path, e1_fname_6s_hollow ];
fname_stem(3)       = [ e9_6s_filled_path, e9_fname_6s_filled ];
fname_stem(4)       = [ e9_6s_hollow_path, e9_fname_6s_hollow ];

%nopupsz
e1_nopupsz_filled_path  = 'exp_1_img_kkequated/no_pupsz/filled/results/';
e1_nopupsz_hollow_path  = 'exp_1_img_kkequated/no_pupsz/hollow/results/';
e9_nopupsz_filled_path  = 'exp_9_nochanges/image_set/no_pupsz/filled/results/';
e9_nopupsz_hollow_path  = 'exp_9_nochanges/image_set/no_pupsz/hollow/results/';

e1_fname_nopupsz_filled = 'exp1_model03b_kkequated_no-pupsz_filled_confirmatory_12734_trials';
e1_fname_nopupsz_hollow = 'exp1_model03b_kkequated_no-pupsz_hollow_confirmatory_12734_trials';
e9_fname_nopupsz_filled = 'exp9_model03b_kkequated_no-pupsz_filled_confirmatory_8301_trials';
e9_fname_nopupsz_hollow = 'exp9_model03b_kkequated_no-pupsz_hollow_confirmatory_8301_trials';


fname_stem(5)           = [ e1_nopupsz_filled_path, e1_fname_nopupsz_filled ];
fname_stem(6)           = [ e1_nopupsz_hollow_path, e1_fname_nopupsz_hollow ];
fname_stem(7)           = [ e9_nopupsz_filled_path, e9_fname_nopupsz_filled ];
fname_stem(8)           = [ e9_nopupsz_hollow_path, e9_fname_nopupsz_hollow ];

%notime
e1_notime_filled_path   = 'exp_1_img_kkequated/no_time/filled/results/';
e1_notime_hollow_path   = 'exp_1_img_kkequated/no_time/hollow/results/';
e9_notime_filled_path   = 'exp_9_nochanges/image_set/no_time/filled/results/';
e9_notime_hollow_path   = 'exp_9_nochanges/image_set/no_time/hollow/results/';

e1_fname_notime_filled  = 'exp1_model03b_kkequated_no-time_filled_confirmatory_12634_trials';
e1_fname_notime_hollow  = 'exp1_model03b_kkequated_no-time_hollow_confirmatory_12634_trials';
e9_fname_notime_filled  = 'exp9_model03b_kkequated_no-time_filled_confirmatory_12634_trials';
e9_fname_notime_hollow  = 'exp9_model03b_kkequated_no-time_hollow_confirmatory_12634_trials';

fname_stem(9)           = [ e1_notime_filled_path, e1_fname_notime_filled ];
fname_stem(10)          = [ e1_notime_hollow_path, e1_fname_notime_hollow ];
fname_stem(11)          = [ e9_notime_filled_path, e9_fname_notime_filled ];
fname_stem(12)          = [ e9_notime_hollow_path, e9_fname_notime_hollow ];

%nox
e1_nox_filled_path      = 'exp_1_img_kkequated/no_x/filled/results/';
e1_nox_hollow_path      = 'exp_1_img_kkequated/no_x/hollow/results/';
e9_nox_filled_path      = 'exp_9_nochanges/image_set/no_x/filled/results/';
e9_nox_hollow_path      = 'exp_9_nochanges/image_set/no_x/hollow/results/';

e1_fname_nox_filled     = 'exp1_model03b_kkequated_no-x_filled_confirmatory_12634_trials';
e1_fname_nox_hollow     = 'exp1_model03b_kkequated_no-x_hollow_confirmatory_12634_trials';
e9_fname_nox_filled     = 'exp9_model03b_kkequated_no-x_filled_confirmatory_8301_trials';
e9_fname_nox_hollow     = 'exp9_model03b_kkequated_no-x_hollow_confirmatory_8301_trials';

fname_stem(13)          = [ e1_nox_filled_path, e1_fname_nox_filled ];
fname_stem(14)          = [ e1_nox_hollow_path, e1_fname_nox_hollow ];
fname_stem(15)          = [ e9_nox_filled_path, e9_fname_nox_filled ];
fname_stem(16)          = [ e9_nox_hollow_path, e9_fname_nox_hollow ];

%noy
e1_noy_filled_path      = 'exp_1_img_kkequated/no_y/filled/results/';
e1_noy_hollow_path      = 'exp_1_img_kkequated/no_y/hollow/results/';
e9_noy_filled_path      = 'exp_9_nochanges/image_set/no_y/filled/results/';
e9_noy_hollow_path      = 'exp_9_nochanges/image_set/no_y/hollow/results/';

e1_fname_noy_filled     = 'exp1_model03b_kkequated_no-y_filled_confirmatory_12634_trials';
e1_fname_noy_hollow     = 'exp1_model03b_kkequated_no-y_hollow_confirmatory_12634_trials';
e9_fname_noy_filled     = 'exp9_model03b_kkequated_no-y_filled_confirmatory_8301_trials';
e9_fname_noy_hollow     = 'exp9_model03b_kkequated_no-y_hollow_confirmatory_8301_trials';

fname_stem(17)          = [ e1_noy_filled_path, e1_fname_noy_filled ];
fname_stem(18)          = [ e1_noy_hollow_path, e1_fname_noy_hollow ];
fname_stem(19)          = [ e9_noy_filled_path, e9_fname_noy_filled ];
fname_stem(20)          = [ e9_noy_hollow_path, e9_fname_noy_hollow ];

%onlypupsz
e1_onlypupsz_filled_path    = 'exp_1_img_kkequated/only_pupsz/filled/results/';
e1_onlypupsz_hollow_path    = 'exp_1_img_kkequated/only_pupsz/hollow/results/';
e9_onlypupsz_filled_path    = 'exp_9_nochanges/image_set/only_pupsz/filled/results/';
e9_onlypupsz_hollow_path    = 'exp_9_nochanges/image_set/only_pupsz/hollow/results/';

e1_fname_onlypupsz_filled   = 'exp1_model03b_kkequated_only_pupsz_filled_confirmatory_12634_trials';
e1_fname_onlypupsz_hollow   = 'exp1_model03b_kkequated_only_pupsz_hollow_confirmatory_12634_trials';
e9_fname_onlypupsz_filled   = 'exp9_model03b_kkequated_only_pupsz_filled_confirmatory_8301_trials';
e9_fname_onlypupsz_hollow   = 'exp9_model03b_kkequated_only_pupsz_hollow_confirmatory_8301_trials';

fname_stem(21)              = [ e1_onlypupsz_filled_path, e1_fname_onlypupsz_filled ];
fname_stem(22)              = [ e1_onlypupsz_hollow_path, e1_fname_onlypupsz_hollow ];
fname_stem(23)              = [ e9_onlypupsz_filled_path, e9_fname_onlypupsz_filled ];
fname_stem(24)              = [ e9_onlypupsz_hollow_path, e9_fname_onlypupsz_hollow ];

%onlyx
e1_onlyx_filled_path    = 'exp_1_img_kkequated/only_x/filled/results/';
e1_onlyx_hollow_path    = 'exp_1_img_kkequated/only_x/hollow/results/';
e9_onlyx_filled_path    = 'exp_9_nochanges/image_set/only_x/filled/results/';
e9_onlyx_hollow_path    = 'exp_9_nochanges/image_set/only_x/hollow/results/';

e1_fname_onlyx_filled   = 'exp1_model03b_kkequated_only_x_filled_confirmatory_12734_trials';
e1_fname_onlyx_hollow   = 'exp1_model03b_kkequated_only_x_hollow_confirmatory_12734_trials';
e9_fname_onlyx_filled   = 'exp9_model03b_kkequated_only_x_filled_confirmatory_8301_trials';
e9_fname_onlyx_hollow   = 'exp9_model03b_kkequated_only_x_hollow_confirmatory_8301_trials';

fname_stem(25)          = [ e1_onlyx_filled_path, e1_fname_onlyx_filled ]; 
fname_stem(26)          = [ e1_onlyx_hollow_path, e1_fname_onlyx_hollow ];
fname_stem(27)          = [ e9_onlyx_filled_path, e9_fname_onlyx_filled ];
fname_stem(28)          = [ e9_onlyx_hollow_path, e9_fname_onlyx_hollow ];

%onlyy
e1_onlyy_filled_path    = 'exp_1_img_kkequated/only_y/filled/results/';
e1_onlyy_hollow_path    = 'exp_1_img_kkequated/only_y/hollow/results/';
e9_onlyy_filled_path    = 'exp_9_nochanges/image_set/only_y/filled/results/';
e9_onlyy_hollow_path    = 'exp_9_nochanges/image_set/only_y/hollow/results/';

e1_fname_onlyy_filled   = 'exp1_model03b_kkequated_only_y_filled_confirmatory_12734_trials';
e1_fname_onlyy_hollow   = 'exp1_model03b_kkequated_only_y_hollow_confirmatory_12634_trials';
e9_fname_onlyy_filled   = 'exp9_model03b_kkequated_only_y_filled_confirmatory_8301_trials';
e9_fname_onlyy_hollow   = 'exp9_model03b_kkequated_only_y_hollow_confirmatory_8301_trials';

fname_stem(29)          = [ e1_onlyy_filled_path, e1_fname_onlyy_filled ];
fname_stem(30)          = [ e1_onlyy_hollow_path, e1_fname_onlyy_hollow ];
fname_stem(31)          = [ e9_onlyy_filled_path, e9_fname_onlyy_filled ];
fname_stem(32)          = [ e9_onlyy_hollow_path, e9_fname_onlyy_hollow ];


%==========
% TIMELINE
%==========

%the actual file name is the same for all of the timeline data
timeline_fname_6s   = 'z_kk_6s_data';

%6s
e1_6s_path          = 'exp_1_timeline_kk/6s/results/';
e9_6s_path          = 'exp_9_nochanges/timeline_set/6s/results/';

fname_stem(33)      = [ e1_6s_path, timeline_fname_6s ];
fname_stem(34)      = [ e9_6s_path, timeline_fname_6s ];

%nopupsz
e1_nopupsz_path     = 'exp_1_timeline_kk/no_pupsz/results/';
e9_nopupsz_path     = 'exp_9_nochanges/timeline_set/no_pupsz/results/';

fname_stem(35)      = [ e1_nopupsz_path, timeline_fname_6s ];
fname_stem(36)      = [ e9_nopupsz_path, timeline_fname_6s ];

%nox
e1_nox_path         = 'exp_1_timeline_kk/no_x/results/';
e9_nox_path         = 'exp_9_nochanges/timeline_set/no_x/results/';

fname_stem(37)      = [ e1_nox_path, timeline_fname_6s ];
fname_stem(38)      = [ e9_nox_path, timeline_fname_6s ];

%noy
e1_noy_path         = 'exp_1_timeline_kk/no_y/results/';
e9_noy_path         = 'exp_9_nochanges/timeline_set/no_y/results/';

fname_stem(39)      = [ e1_noy_path, timeline_fname_6s ];
fname_stem(40)      = [ e9_noy_path, timeline_fname_6s ];

%onlypupsz
e1_onlypupsz_path   = 'exp_1_timeline_kk/only_pupsz/results/';
e9_onlypupsz_path   = 'exp_9_nochanges/timeline_set/only_pupsz/results/';

fname_stem(41)      = [ e1_onlypupsz_path, timeline_fname_6s ];
fname_stem(42)      = [ e9_onlypupsz_path, timeline_fname_6s ];

%onlyx
e1_onlyx_path       = 'exp_1_timeline_kk/only_x/results/';
e9_onlyx_path       = 'exp_9_nochanges/timeline_set/only_x/results/';

fname_stem(43)      = [ e1_onlyx_path, timeline_fname_6s ];
fname_stem(44)      = [ e9_onlyx_path, timeline_fname_6s ];

%onlyy
e1_onlyy_path       = 'exp_1_timeline_kk/only_y/results/';
e9_onlyy_path       = 'exp_9_nochanges/timeline_set/only_y/results/';

fname_stem(45)      = [ e1_onlyy_path, timeline_fname_6s ];
fname_stem(46)      = [ e9_onlyy_path, timeline_fname_6s ];


%run the loop for all of the confusion matrices
for data = 1:length(results)
    figure_title    = names(data);
    file            = strcat(path, fname_stem(data));
    
    label_fname     = sprintf('%s_labels.tsv', file);
    score_fname     = sprintf('%s_scores.tsv', file);
    
    labels          = dlmread(label_fname,'\t',1,0);
    scores          = dlmread(score_fname,'\t',1,0);
    
    confusion_matrix = zeros(3,3);

    for i = 1:nits
        ls_ind1     = (i-1)*3+1;
        ls_ind2     = ls_ind1+2;

        these_labs  = labels(ls_ind1:ls_ind2,4:end);
        these_scrs  = scores(ls_ind1:ls_ind2,4:end);

        n_trials = size(these_labs,2);

        for j = 1:n_trials
            temp_labs   = these_labs(:,j);
            temp_scrs   = these_scrs(:,j);

            true_lab    = find(temp_labs==1);
            max_scr     = find(temp_scrs == max(temp_scrs));

            confusion_matrix(true_lab, max_scr) = confusion_matrix(true_lab, max_scr) + 1;
        end
    end

    confusion_matrix(1,:) = confusion_matrix(1,:) / sum(confusion_matrix(1,:));
    confusion_matrix(2,:) = confusion_matrix(2,:) / sum(confusion_matrix(2,:));
    confusion_matrix(3,:) = confusion_matrix(3,:) / sum(confusion_matrix(3,:));

    imagesc(confusion_matrix, [.1 .6]); 

    
    % -- jov doesn't want the axes duplicated in the panel figures --
    
    % will put colorbar on the main fig and the figs to the right
    % will put the x-labs on the bottom row
    % will put the y-labs on the main fig and the left row 
    % all will have a title
    
    y_axis = { 
        'XYP_img_e1', 'XYP_timeline_e1', '0YP_img_e1', '0YP_timeline_e1', 'X00_img_e1', 'X00_timeline_e1',...
        'XYP_img_e9', 'XYP_timeline_e9', '0YP_img_e9', '0YP_timeline_e9', 'X00_img_e9', 'X00_timeline_e9'
        };
    x_axis = { 
        'XYP_img_e1', 'XYP_timeline_e1', 'X00_img_e1', 'X00_timeline_e1', '0Y0_img_e1', '0Y0_timeline_e1', '00P_img_e1', '00P_timeline_e1', ...
        'XYP_img_e9', 'XYP_timeline_e9', 'X00_img_e9', 'X00_timeline_e9', '0Y0_img_e9', '0Y0_timeline_e9', '00P_img_e9', '00P_timeline_e9'
        };
    clrbar = { 
        'XYP_img_e1', 'XYP_timeline_e1', 'XY0_img_e1', 'XY0_timeline_e1', '00P_img_e1', '00P_timeline_e1', ...
        'XYP_img_e9', 'XYP_timeline_e9', 'XY0_img_e9', 'XY0_timeline_e9', '00P_img_e9', '00P_timeline_e9'
        };
    
      
    axis square; colormap(flipud(winter(10))); 
    
    % colorbar
    if any(strcmp(clrbar, figure_title))
        colorbar;
    end
    
    %x axis
    if any(strcmp(x_axis, figure_title))
        xticks([1 2 3]); xticklabels({'Search', 'Memorize', 'Rate'});
    else
        set(gca, 'xtick', []);
        set(gca, 'xticklabel', []);
    end
    
    % y_axis
    if any(strcmp(y_axis, figure_title))  
        yticks([1 2 3]); yticklabels({'Search', 'Memorize', 'Rate'});
    else
        set(gca, 'ytick', []);
        set(gca, 'yticklabel', []);
    end
    
    ax = gca; ax.FontSize = 10; ax.FontName = 'Helvetica'; %ax.FontWeight = 'bold';
    
    new_title = figure_title{1}(1:3); %had to do this to get the filenames and fig title how I wanted them
    title(new_title, 'FontSize', 12, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'Color', 'black');
    
    %x axis
    if any(strcmp(x_axis, figure_title))
        xlabel('Predicted', 'FontSize', 12, 'Color', 'black');
    end
    
    % y_axis
    if any(strcmp(y_axis, figure_title))  
        ylabel('Actual', 'FontSize', 12, 'Color', 'black');
    end

    disp(confusion_matrix); %old fonts were al Trebuchet MS

    for i = 1:3
        for j = 1:3
            str = sprintf('%.3f',confusion_matrix(j,i));
            x = i - .2;
            ids = text(x,j,str);
            ids.FontName = 'Helvetica';
            ids.FontSize = 12;
%             ids.FontWeight = 'bold';
            ids.Color = 'white';
        end
    end
    
    set(0,'DefaultTextInterpreter','none'); %shutdown LaTeX interp for title name

    
    print([names{data} '_fig.png'], '-r300', '-dpng');
%     pause;
end

% keyboard;

end

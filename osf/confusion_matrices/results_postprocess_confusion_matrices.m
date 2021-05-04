function results_postprocess_confusion_matrices( file, nits )

% get absolute path
abs_path    = '../';
owd         = pwd;
cd(abs_path);
abs_path    = what(pwd);
abs_path    = abs_path.path;
cd(owd);
    
% initial parameters
fname_stem  = string(zeros(46));
nits        = 10;

%in order of how they are in the fname_stem and lists so these
%can be used as the titles
results = [
    {'Exploratory Image - Full'}, {'Confirmatory Image - Full'},...
    {'Exploratory Image - No Pupsz'}, {'Confirmatory Image - No Pupsz'},...
    {'Exploratory Image - No X'}, {'Confirmatory Image - No X'},...
    {'Exploratory Image - No Y'}, {'Confirmatory Image - No Y'},...
    {'Exploratory Image - Only Pupsz'}, {'Confirmatory Image - Only Pupsz'},...
    {'Exploratory Image - Only X'}, {'Confirmatory Image - Only X'},...
    {'Exploratory Image - Only Y'}, {'Confirmatory Image - Only Y'},...
    {'Exploratory Timeline - Full'}, {'Confirmatory Timeline - Full'},...
    {'Exploratory Timeline - No Pupsz'}, {'Confirmatory Timeline - No Pupsz'},...
    {'Exploratory Timeline - No X'}, {'Confirmatory Timeline - No X'},...
    {'Exploratory Timeline - No Y'}, {'Confirmatory Timeline - No Y'},...
    {'Exploratory Timeline - Only Pupsz'}, {'Confirmatory Timeline - Only Pupsz'},...
    {'Exploratory Timeline - Only X'}, {'Confirmatory Timeline - Only X'},...
    {'Exploratory Timeline - Only Y'}, {'Confirmatory Timeline - Only Y'}
    ];


%=======
% IMAGE
%=======

%full
exploratory_img_full_path   = 'exploratory/scripts_img/full/results/';
confirmatory_img_full_path  = 'confirmatory/scripts_img/full/results/';

exploratory_img_full_fname  = 'exploratory_img_full_12615_trials';
confirmatory_img_full_fname = 'confirmatory_img_full_8301_trials';

fname_stem(1)           = [ exploratory_img_full_path, exploratory_img_full_fname ];
fname_stem(2)           = [ confirmatory_img_full_path, confirmatory_img_full_fname ];

%nopupsz
exploratory_img_no_pupsz_path   = 'exploratory/scripts_img/no_pupsz/results/';
confirmatory_img_no_pupsz_path  = 'confirmatory/scripts_img/no_pupsz/results/';

exploratory_img_no_pupsz_fname  = 'exploratory_img_no_pupsz_12734_trials';
confirmatory_img_no_pupsz_fname = 'confirmatory_img_no_pupsz_8301_trials';

fname_stem(3)               = [ exploratory_img_no_pupsz_path, exploratory_img_no_pupsz_fname ];
fname_stem(4)               = [ confirmatory_img_no_pupsz_path, confirmatory_img_no_pupsz_fname ];

%nox
exploratory_img_no_x_path   = 'exploratory/scripts_img/no_x/results/';
confirmatory_img_no_x_path  = 'confirmatory/scripts_img/no_x/results/';

exploratory_img_no_x_fname  = 'exploratory_img_no_x_12634_trials';
confirmatory_img_no_x_fname = 'confirmatory_img_no_x_8301_trials';

fname_stem(7)           = [ exploratory_img_no_x_path, exploratory_img_no_x_fname ];
fname_stem(8)           = [ confirmatory_img_no_x_path, confirmatory_img_no_x_fname ];

%noy
exploratory_img_no_y_path   = 'exploratory/scripts_img/no_y/results/';
confirmatory_img_no_y_path  = 'confirmatory/scripts_img/no_y/results/';

exploratory_img_no_y_fname  = 'exploratory_img_no_y_12634_trials';
confirmatory_img_no_y_fname = 'confirmatory_img_no_y_8301_trials';

fname_stem(9)           = [ exploratory_img_no_y_path, exploratory_img_no_y_fname ];
fname_stem(10)          = [ confirmatory_img_no_y_path, confirmatory_img_no_y_fname ];

%onlypupsz
exploratory_img_only_pupsz_path     = 'exploratory/scripts_img/only_pupsz/results/';
confirmatory_img_only_pupsz_path    = 'confirmatory/scripts_img/only_pupsz/results/';

exploratory_img_only_pupsz_fname    = 'exploratory_img_only_pupsz_12634_trials';
confirmatory_img_only_pupsz_fname   = 'confirmatory_img_only_pupsz_8301_trials';

fname_stem(11)                  = [ exploratory_img_only_pupsz_path, exploratory_img_only_pupsz_fname ];
fname_stem(12)                  = [ confirmatory_img_only_pupsz_path, confirmatory_img_only_pupsz_fname ];

%onlyx
exploratory_img_only_x_path     = 'exploratory/scripts_img/only_x/results/';
confirmatory_img_only_x_path    = 'confirmatory/scripts_img/only_x/results/';

exploratory_img_only_x_fname    = 'exploratory_img_only_x_12734_trials';
confirmatory_img_only_x_fname   = 'confirmatory_img_only_x_8301_trials';

fname_stem(13)              = [ exploratory_img_only_x_path, exploratory_img_only_x_fname ]; 
fname_stem(14)              = [ confirmatory_img_only_x_path, confirmatory_img_only_x_fname ];

%onlyy
exploratory_img_only_y_path    = 'exploratory/scripts_img/only_y/results/';
confirmatory_img_only_y_path    = 'confirmatory/scripts_img/only_y/results/';

exploratory_img_only_y_fname   = 'exploratory_img_only_y_12734_trials';
confirmatory_img_only_y_fname   = 'confirmatory_img_only_y_8301_trials';

fname_stem(15)          = [ exploratory_img_only_y_path, exploratory_img_only_y_fname ];
fname_stem(16)          = [ confirmatory_img_only_y_path, confirmatory_img_only_y_fname ];


%==========
% TIMELINE
%==========

%full
exploratory_timeline_full_path      = 'exploratory/scripts_timeline/full/results/';
confirmatory_timeline_full_path     = 'confirmatory/scripts_timeline/full/results/';
exploratory_timeline_full_fname     = 'exploratory_timeline_full';
confirmatory_timeline_full_fname    = 'confirmatory_timeline_full';

fname_stem(17)                      = [ exploratory_timeline_full_path, exploratory_timeline_full_fname ];
fname_stem(18)                      = [ confirmatory_timeline_full_path, confirmatory_timeline_full_fname ];

%nopupsz
exploratory_timeline_no_pupsz_path      = 'exploratory/scripts_timeline/no_pupsz/results/';
confirmatory_timeline_no_pupsz_path     = 'confirmatory/scripts_timeline/no_pupsz/results/';
exploratory_timeline_no_pupsz_fname     = 'exploratory_timeline_no_pupsz';
confirmatory_timeline_no_pupsz_fname    = 'confirmatory_timeline_no_pupsz';

fname_stem(19)                          = [ exploratory_timeline_no_pupsz_path, exploratory_timeline_no_pupsz_fname ];
fname_stem(20)                          = [ confirmatory_timeline_no_pupsz_path, confirmatory_timeline_no_pupsz_fname ];

%nox
exploratory_timeline_no_x_path      = 'exploratory/scripts_timeline/no_x/results/';
confirmatory_timeline_no_x_path     = 'confirmatory/scripts_timeline/no_x/results/';
exploratory_timeline_no_x_fname     = 'exploratory_timeline_no_x';
confirmatory_timeline_no_x_fname    = 'confirmatory_timeline_no_x';

fname_stem(21)                      = [ exploratory_timeline_no_x_path, exploratory_timeline_no_x_fname ];
fname_stem(22)                      = [ confirmatory_timeline_no_x_path, confirmatory_timeline_no_x_fname ];

%noy
exploratory_timeline_no_y_path      = 'exploratory/scripts_timeline/no_y/results/';
confirmatory_timeline_no_y_path     = 'confirmatory/scripts_timeline/no_y/results/';
exploratory_timeline_no_y_fname     = 'exploratory_timeline_no_y';
confirmatory_timeline_no_y_fname    = 'confirmatory_timeline_no_y';

fname_stem(23)                      = [ exploratory_timeline_no_y_path, exploratory_timeline_no_y_fname ];
fname_stem(24)                      = [ confirmatory_timeline_no_y_path, confirmatory_timeline_no_y_fname ];

%onlypupsz
exploratory_timeline_only_pupsz_path    = 'exploratory/scripts_timeline/only_pupsz/results/';
confirmatory_timeline_only_pupsz_path   = 'confirmatory/scripts_timeline/only_pupsz/results/';
exploratory_timeline_only_pupsz_fname   = 'exploratory_timeline_only_pupsz';
confirmatory_timeline_only_pupsz_fname  = 'confirmatory_timeline_only_pupsz';

fname_stem(25)                          = [ exploratory_timeline_only_pupsz_path, exploratory_timeline_only_pupsz_fname ];
fname_stem(26)                          = [ confirmatory_timeline_only_pupsz_path, confirmatory_timeline_only_pupsz_fname ];

%onlyx
exploratory_timeline_only_x_path    = 'exploratory/scripts_timeline/only_x/results/';
confirmatory_timeline_only_x_path   = 'confirmatory/scripts_timeline/only_x/results/';
exploratory_timeline_only_x_fname   = 'exploratory_timeline_only_x';
confirmatory_timeline_only_x_fname  = 'confirmatory_timeline_only_x';

fname_stem(27)      = [ exploratory_timeline_only_x_path, exploratory_timeline_only_x_fname ];
fname_stem(28)      = [ confirmatory_timeline_only_x_path, exploratory_timeline_only_x_fname ];

%onlyy
exploratory_timeline_only_y_path    = 'exploratory/scripts_timeline/only_y/results/';
confirmatory_timeline_only_y_path   = 'confirmatory/scripts_timeline/only_y/results/';
exploratory_timeline_only_y_fname   = 'exploratory_timeline_only_y';
confirmatory_timeline_only_y_fname  = 'confirmatory_timeline_only_y';

fname_stem(29)      = [ exploratory_timeline_only_y_path, exploratory_timeline_only_y_fname ];
fname_stem(30)      = [ confirmatory_timeline_only_y_path, confirmatory_timeline_only_y_fname ];


%run the loop for all of the confusion matrices
for data = 1:length(results)
    figure_title    = results(data);
    file            = strcat(abs_path, fname_stem(data));
    
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

    axis square; colormap(flipud(winter(10))); colorbar;
    xticks([1 2 3]); xticklabels({'S', 'M', 'R'});
    yticks([1 2 3]); yticklabels({'S', 'M', 'R'});
    ax = gca; ax.FontSize = 14; ax.FontName = 'Trebuchet MS'; ax.FontWeight = 'bold';

    title(figure_title, 'FontSize', 20, 'FontName', 'Trebuchet MS', 'Color', 'black');
    xlabel('Predicted', 'FontSize', 16, 'Color', 'black');
    ylabel('Actual', 'FontSize', 16, 'Color', 'black');

    disp(confusion_matrix);

    for i = 1:3
        for j = 1:3
            str = sprintf('%.3f',confusion_matrix(j,i));
            x = i - .2;
            ids = text(x,j,str);
            ids.FontName = 'Trebuchet MS';
            ids.FontSize = 16;
            ids.FontWeight = 'bold';
            ids.Color = 'white';
        end
    end
    
    set(0,'DefaultTextInterpreter','none'); %shutdown LaTeX interp for title name

    
    print([results{data} '_fig.png'], '-r300', '-dpng');
%     pause;
end

% keyboard;

end

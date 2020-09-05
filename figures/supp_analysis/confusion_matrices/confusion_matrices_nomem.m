function confusion_matrices_nomem

% number of iterations
nits = 10;

% establish paths
path                = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/deepeye/supp_analysis/';
e1_nomem_path       = 'e1_timeline/results/z_kk_6s_timeline_e1_NOMEM';
e1_norate_path      = 'e1_timeline/norate_results/z_kk_6s_timeline_e1_NORATE';
e1_nosearch_path    = 'e1_timeline/nosearch_results/z_kk_6s_timeline_e1_NOSEARCH';
e9_nomem_path       = 'e9_timeline/results/z_kk_6s_timeline_e9_NOMEM';
e9_norate_path      = 'e9_timeline/norate_results/z_kk_6s_timeline_e9_NORATE';
e9_nosearch_path    = 'e9_timeline/nosearch_results/z_kk_6s_timeline_e9_NOSEARCH';

% fname stem
fname_stem          = string(nan(6));
fname_stem(1)       = [ path, e1_nomem_path ];
fname_stem(2)       = [ path, e1_norate_path ];
fname_stem(3)       = [ path, e1_nosearch_path ];
fname_stem(4)       = [ path, e9_nomem_path ];
fname_stem(5)       = [ path, e9_norate_path ];
fname_stem(6)       = [ path, e9_nosearch_path ];

names = [
    { 'S0R_1' }, { 'SM0_1' }, { '0MR_1' },...
    { 'S0R_9' }, { 'SM0_9' }, { '0MR_9' }
    ];

for data = 1:length(names)
    figure_title    = names(data);
    file            = strcat(fname_stem(data));
    
    label_fname     = sprintf('%s_labels.tsv', file);
    score_fname     = sprintf('%s_scores.tsv', file);

    labels          = dlmread(label_fname, '\t', 1, 0);
    scores          = dlmread(score_fname, '\t', 1, 0);

    confusion_matrix= zeros(2,2);

    for i = 1:nits 
        ls_ind1     = (i - 1) * 2 + 1;
        ls_ind2     = ls_ind1 + 1;

        these_labs  = labels(ls_ind1:ls_ind2, 3:end);
        these_scrs  = scores(ls_ind1:ls_ind2, 3:end);

        n_trials = size(these_labs, 2);

        for j = 1:n_trials
            temp_labs   = these_labs(:,j);
            temp_scrs   = these_scrs(:,j);

            true_lab    = find(temp_labs == 1);
            max_scr     = find(temp_scrs == max(temp_scrs));

            confusion_matrix(true_lab, max_scr) = confusion_matrix(true_lab, max_scr) + 1;
        end
    end

    confusion_matrix(1,:) = confusion_matrix(1,:) / sum(confusion_matrix(1,:));
    confusion_matrix(2,:) = confusion_matrix(2,:) / sum(confusion_matrix(2,:));

    imagesc(confusion_matrix, [.1 .8]);

    clrbar = { 
        'SM0_1', 'SM0_9' 
        };

    axis square; colormap(flipud(winter(7)));

    % setup the labels
    omr = {
        '0MR_1', '0MR_9'
        };
    sor = {
        'S0R_1', 'S0R_9'
        };
    smo = {
        'SM0_1', 'SM0_9'
        };

    % axis labels
    if any( strcmp(omr, figure_title) )
        xticks( [1 2] ); xticklabels( {'M', 'R'} );
        yticks( [1 2] ); yticklabels( {'M', 'R'} );
    elseif any( strcmp(sor, figure_title) )
        xticks( [1 2] ); xticklabels( {'S', 'R'} );
        yticks( [1 2] ); yticklabels( {'S', 'R'} );
    elseif any( strcmp(smo, figure_title) )
        xticks( [1 2] ); xticklabels( {'S', 'M'} );
        yticks( [1 2] ); yticklabels( {'S', 'M'} );
    end

    xlabel( 'Predicted', 'FontSize', 16, 'Color', 'black' );
    ylabel( 'Actual', 'FontSize', 16, 'Color', 'black' );

    % colorbar
    if any(strcmp(clrbar, figure_title))
        colorbar;
    end

    ax = gca; ax.FontSize = 16; ax.FontName = 'Helvetica';

    new_title = figure_title{1}(1:3);
    title(new_title, 'FontSize', 16, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'Color', 'black');

    disp(confusion_matrix);

    for i = 1:2
        for j = 1:2
            str             = sprintf( '%.3f', confusion_matrix(j, i) );
            x               = i - .2;
            ids             = text( x, j, str );
            ids.FontName    = 'Helvetica';
            ids.FontSize    = 16;
            ids.Color       = 'white';
        end
    end

    set( 0, 'DefaultTextInterpreter', 'none' );

    print( [names{data} '_fig.png'], '-r300', '-dpng' );
end
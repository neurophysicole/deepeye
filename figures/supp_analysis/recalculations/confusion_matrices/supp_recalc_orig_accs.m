function supp_recalc_orig_accs

% confusion matrices equivalency math for DeepEye supplementary analysis

% -------------------------------
% original scores (timeline data)
% exploratory
e_s = [ .527, .266, .207 ]; %search row
e_m = [ .273, .484, .243 ]; %memorize row
e_r = [ .207, .227, .567 ]; %rate row
% confirmatory
c_s = [ .553, .235, .212 ]; %search row
c_m = [ .253, .457, .290 ]; %memorize row
c_r = [ .163, .235, .602 ]; %rate row

% -----------
% do the math
% exploratory -- for confusion matrices
e_sr_s_hit  = e_s(1) / ( e_s(1) + e_s(3) ); %search in search/rate - hits
e_sr_s_miss = e_s(3) / ( e_s(1) + e_s(3) ); %search in search/rate - misses
e_sr_r_hit  = e_r(3) / ( e_r(1) + e_r(3) ); %rate in search/rate - hits
e_sr_r_miss = e_r(1) / ( e_r(1) + e_r(3) ); %rate in search/rate - misses
e_sm_s_hit  = e_s(1) / ( e_s(1) + e_s(2) ); %search in search/memorize - hits
e_sm_s_miss = e_s(2) / ( e_s(1) + e_s(2) ); %search in search/memorize - misses
e_sm_m_hit  = e_m(2) / ( e_m(1) + e_m(2) ); %memorize in search/memorize - hits
e_sm_m_miss = e_m(1) / ( e_m(1) + e_m(2) ); %memorize in search/memorize - misses
e_mr_m_hit  = e_m(2) / ( e_m(2) + e_m(3) ); %memorize in memorize/rate - hits
e_mr_m_miss = e_m(3) / ( e_m(2) + e_m(3) ); %memorize in memorize/rate - misses
e_mr_r_hit  = e_r(3) / ( e_r(2) + e_r(3) ); %rate in memorize/rate - hits
e_mr_r_miss = e_r(2) / ( e_r(2) + e_r(3) ); %rate in memorize/rate - misses
% totals -- for graph
e_sr = ( e_sr_s_hit + e_sr_r_hit ) / 2;
e_sm = ( e_sm_s_hit + e_sm_m_hit ) / 2;
e_mr = ( e_mr_m_hit + e_mr_r_hit ) / 2;

%! note: below was copied from above, so if mistakes in one are likely present in the other

% confirmatory -- for confusion matrices
c_sr_s_hit  = c_s(1) / ( c_s(1) + c_s(3) ); %search in search/rate - hits
c_sr_s_miss = c_s(3) / ( c_s(1) + c_s(3) ); %search in search/rate - misses
c_sr_r_hit  = c_r(3) / ( c_r(1) + c_r(3) ); %rate in search/rate - hits
c_sr_r_miss = c_r(1) / ( c_r(1) + c_r(3) ); %rate in search/rate - misses
c_sm_s_hit  = c_s(1) / ( c_s(1) + c_s(2) ); %search in search/memorize - hits
c_sm_s_miss = c_s(2) / ( c_s(1) + c_s(2) ); %search in search/memorize - misses
c_sm_m_hit  = c_m(2) / ( c_m(1) + c_m(2) ); %memorize in search/memorize - hits
c_sm_m_miss = c_m(1) / ( c_m(1) + c_m(2) ); %memorize in search/memorize - misses
c_mr_m_hit  = c_m(2) / ( c_m(2) + c_m(3) ); %memorize in memorize/rate - hits
c_mr_m_miss = c_m(3) / ( c_m(2) + c_m(3) ); %memorize in memorize/rate - misses
c_mr_r_hit  = c_r(3) / ( c_r(2) + c_r(3) ); %rate in memorize/rate - hits
c_mr_r_miss = c_r(2) / ( c_r(2) + c_r(3) ); %rate in memorize/rate - misses
% totals -- for graph
c_sr = ( c_sr_s_hit + c_sr_r_hit ) / 2;
c_sm = ( c_sm_s_hit + c_sm_m_hit ) / 2;
c_mr = ( c_mr_m_hit + c_mr_r_hit ) / 2;

% print it out
fprintf('\n\n-----\nEXPLORATORY\n');
fprintf('search - rate: %f\n', e_sr);
fprintf('search - memorize: %f\n', e_sm);
fprintf('memorize - rate: %f\n', e_mr);

fprintf('\n\n-----\nCONFIRMATORY\n');
fprintf('search - rate: %f\n', c_sr);
fprintf('search - memorize: %f\n', c_sm);
fprintf('memorize - rate: %f\n', c_mr);

names = [
    { 'S0R' }, { 'SM0' }, { '0MR' }
];

for i = 1:2
    for j = 1:length(names)
        if (i == 1) && strcmp(names{j}, 'S0R')
            confusion_matrix = [ e_sr_s_hit, e_sr_s_miss; e_sr_r_miss, e_sr_r_hit ];
        elseif (i == 2) && strcmp(names{j}, 'S0R')
            confusion_matrix = [ c_sr_s_hit, c_sr_s_miss; c_sr_r_miss, c_sr_r_hit ];
        elseif (i == 1) && strcmp(names{j}, 'SM0')
            confusion_matrix = [ e_sm_s_hit, e_sm_s_miss; e_sm_m_miss, e_sm_m_hit ];
        elseif (i == 2) && strcmp(names{j}, 'SM0')
            confusion_matrix = [ c_sm_s_hit, c_sm_s_miss; c_sm_m_miss, c_sm_m_hit ];
        elseif (i == 1) && strcmp(names{j}, '0MR')
            confusion_matrix = [ e_mr_m_hit, e_mr_m_miss; e_mr_r_miss, e_mr_r_hit ];
        elseif (i == 2) && strcmp(names{j}, '0MR')
            confusion_matrix = [ c_mr_m_hit, c_mr_m_miss; c_mr_r_miss, c_mr_r_hit];
        end

        imagesc(confusion_matrix, [.1 .8]);

        axis square; colormap(flipud(winter(7)));

        % axis labels
        if (names{j} == '0MR')
            xticks( [1 2] ); xticklabels( {'M', 'R'} );
            yticks( [1 2] ); yticklabels( {'M', 'R'} );
        elseif (names{j} == 'S0R')
            xticks( [1 2] ); xticklabels( {'S', 'R'} );
            yticks( [1 2] ); yticklabels( {'S', 'R'} );
        elseif (names{j} == 'SM0')
            xticks( [1 2] ); xticklabels( {'S', 'M'} );
            yticks( [1 2] ); yticklabels( {'S', 'M'} );
            colorbar;
        end

        xlabel( 'Predicted', 'FontSize', 16, 'Color', 'black' );
        ylabel( 'Actual', 'FontSize', 16, 'Color', 'black' );

%         colorbar;

        ax = gca; ax.FontSize = 16; ax.FontName = 'Helvetica';

        if i == 1
            new_title = sprintf('Exp %s', names{j});
        elseif i == 2
            new_title = sprintf(' Conf %s', names{j});
        else %wtf
            error('nope')
        end

        title(names{j}, 'FontSize', 16, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'Color', 'black');

        disp(confusion_matrix)

        for k = 1:2
            for l = 1:2
                str             = sprintf( '%.3f', confusion_matrix(l, k) );
                x               = k - .2;
                ids             = text( x, l, str );
                ids.FontName    = 'Helvetica';
                ids.FontSize    = 16;
                ids.Color       = 'white';
            end
        end

        set( 0, 'DefaultTextInterpreter', 'none' );
        print( [new_title '_fig.png'], '-r300', '-dpng' );
    end
end
\section{Results}
<!-- % compared the removed component data to the full dataset, then compared the only-component datasets to each other. -->
<!-- % figure this shows what the removal of a variable does, and shows the relative importance of each individual component.. -->

<!-- %!Is this stuff actually necessary?
%!Should this stuff have it's own section -->
Results for the CNN architecture that resulted in the highest accuracy on the exploratory dataset are reported below. For every dataset tested, a one-sample _t_-test was used to compare the CNN accuracies against chance (33\%). The Shapiro-Wilks test of normality was conducted to test the normality for each dataset. When normality was assumed, the mean accuracy for that dataset was compared against chance using Student's _t_-test. When normality could not be assumed, the median accuracy for that dataset was compared against chance using Wilcoxon's signed rank test.

<!-- %When comparing classification accuracies between datasets, independent-samples between-subjects _t_-tests and Analyses of Variance (ANOVA) were implemented. When assumptions of normality were violated for these _t_-tests, the Mann-Whitney _U_ was used. When assumptions of normality were violated for the ANOVAs, the Kruskall-Wallis test was used. Multiple comparisons corrections to post-hoc _p_-values were implemented using Tukey's _HSD_. -->

\subsection{Exploratory}
\subsubsection{Timeline Data Classification.}
CNN model accuracy for the timeline data were well above chance (_M_ = .526, _SD_ = .018; _p_ < .001). Accuracy for classifications of the systematically parsed data were all better than chance (see Table x).

insert{table_x} <!--%acc v chance -- timeline data (parsed) (includes descriptives..) -- should also specify when the medians were used instead of t-test

A one-way between-subjects Analysis of Variance (ANOVA) compared classification accuracies for the full dataset and those that had the pupil size, x-coordinate, and y-coordinate data systematically removed. The omnibus ANOVA reported a difference in the classification accuracies for this parcellation of datasets, _F_(3, 36) = 47.471, _p_ < .001, _\[eta^{2}\]_ = 0.798. Post-hoc comparisons show that when compared to the full dataset, removing the pupil size (_t_(18) = -1.635, _p_ = .372) and y-coordinate (_t_(18) = 2.645, _p_ = .056) did not affect classification accuracy, suggesting that these data are not informing classification judgments made by the CNN. Classification for the dataset with the x-coordinates removed was lower than classification for the full dataset (_t_(18) = 9.420, _p_ < .001), showing that these data were relatively important criterion in classification decisions.
<!-- %!could also include comparisons between the var-removed datasets, but this seems to tell the story..right? -->

Another one-way between-subjects ANOVA compared the classification accuracies for the paracellated datasets containing only the x-coordinate, y-coordinate, and pupil size data. The omnibus ANOVA reported a difference in the classification accuracies, _F_(2, 27) = 75.145, _p_ < .001, _\[eta^{2}\]_ = 0.848. Post-hoc comparisons show that classification accuracies for the the pupil size dataset were lower than the x-coordinate (_t_(18) = -12.213, _p_ < .001) and y-coordinate (_t_(18) = -7.026, _p_ < .001) datasets, and accuracies for classification of the x-coordinate dataset were higher than for the y-coordinate dataset (_t_(18) = 5.187, _p_ < .001). These findings suggest that pupil size is the least informative criterion informing classification decisions, while the x-coordinate data was the most informative.

\subsubsection{Image Classification}
_Image Classification._ CNN model accuracy for the image dataset was better than chance (_M_ = .436, _SD_ = .020, _p_ < .001), but was less accurate than the timeline data (_t_(18) = -10.813, _p_ < .001). Accuracy for the classifications for all parcellations of the image data except the pupil size only dataset were better than chance (see Table x). The parsed image dataset classification accuracies were not compared to the parsed timeline dataset classification accuracies.

A one-way between-subjects ANOVA compared classification accuracies for the full dataset and those that had the time, pupil size, x-coordinate, and y-coordinate data systematically removed. The omnibus ANOVA reported a difference in the classification accuracies for this parcellation of the datasets, _F_(4, 45) = 7.093, _p_ < .001, _\[eta^{2}\]_ = .387. Post-hoc comparisons show that when compared to the full dataset there was no effect of removing the time component (_t_(18) = -1.499, _p_ = .569), pupil size (_t_(18) = -0.474, _p_ = .989), x-coordinates (_t_(18) = -1.792, _p_ = .391), but classification accuracy was worse when the y-coordinate data were removed (_t_(18) = 2.939, _p_ = .039).
<!-- %!^^^Had to change something, make sure references to the same pattern, etc. are still true. -->

Another one-way between-subjects ANOVA compared the classification accuracies for the datasets that contained only the x-coordinate, y-coordinate, and pupil size data. Levene's test for equality revealed unequal variances between the groups, _F_(2, 27) = 3.815, _p_ = .035. The Browne-Forsythe correction was used to interpret the findings of this omnibus ANOVA. There was a difference in the classification accuracies for this parcellation of the datasets, _F_(2, 17.993) = 120.639, _p_ < .001, _\[eta^{2}\]_ = .899. Post-hoc comparisons show that there was no difference in the classification accuracies for the x-coordinate and y-coordinate datasets (_t_(18) = 0.423, _p_ = .906), but classification for the pupil size dataset were lower than the x-coordinate (_t_(18) = -13.569, _p_ < .001) and y-coordinate (_t_(18) = -13.235, _p_ < .001) datasets.

\subsection{Confirmatory}
To check for overfitting, the classification accuracies for the exploratory and confirmatory datasets were compared. Levene's test indicated equality of variances (_F_(1, 298) = _p_ = .126), but the Shapiro-Wilk test for normality indicated that the exploratory (_W_ = 0.961, _p_ < .001) and confirmatory (_W_ = 0.975, _p_ = .008) data deviated from normal. The Mann-Whitney test was used to account for the lack of normality. There was no difference between classification accuracies for the exploratory and confirmatory datasets (_U_ = 10280.000, _p_ = .197), suggesting that the model was not overfitting the exploratory dataset. To further clarify the robustness of the CNN model outcomes, the accuracies for the confirmatory dataset were submitted to the same statistical analyses as the exploratory dataset (see Table x). Overall, the CNN classification accuracies for the confirmatory dataset followed the pattern of results found for the exploratory dataset.

insert{table_x} <!-- %breakdown of post-hoc tests for timeline data -- systematic var removal (could include a column or note explicitly addressing how each comparison does or does not follow the pattern shown in the exploratory dataset) -->

<!-- %---- -->

<!-- %! ACTUALLY -- Should we report everything for the confirmatory dataset, then put everything from the exploratory dataset in the table and just comment on whether each comparison shows the same pattern of results in the exploratory and confirmatory datasets?
%! Or maybe we should just report everything in text and forget about the tables? hmm..... -->

<!-- % so, when using raw data, less information needed from the actual image, when using raw data, image information may actually provide more insight?
% raw data has a higher resolution -->
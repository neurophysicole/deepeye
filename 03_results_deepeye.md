\section{Results}

<!-- Present the timeline data first, then follow with the image data; present the two experiments as exploratory and confirmatory -->

<!-- % compared the removed component data to the full dataset, then compared the only-component datasets to each other. -->
<!-- % figure this shows what the removal of a variable does, and shows the relative importance of each individual component.. -->

<!-- %When comparing classification accuracies between datasets, independent-samples between-subjects _t_-tests and Analyses of Variance (ANOVA) were implemented. When assumptions of normality were violated for these _t_-tests, the Mann-Whitney _U_ was used. When assumptions of normality were violated for the ANOVAs, the Kruskall-Wallis test was used. Multiple comparisons corrections to post-hoc _p_-values were implemented using Tukey's _HSD_. -->

\subsection{Timeline Data Classification}
\subsubsection{Exploratory.}
Classification accuracy for the timeline data were well above chance (_M_ = .526, _SD_ = .018; _t_(9) = 34.565, _p_ < .001). Accuracy for classifications of the systematically parsed data were all better than chance (see Table x<!--; for the confusion matrices, see Figure X-->).

<!-- \insert{fig_x} <!-- confusion matrices for exploratory timeline (all parcellations?) -->
<!-- ! Breakdown how the tasks did with the confusion matrices -->

<!-- \insert{table_x} <!-- %acc v chance -- timeline data (parsed) (includes descriptives..) -- should also specify when the medians were used instead of t-test
<!-- TABLE X: (side-by-side)
EXPLORATORY
No X: _M_ = .466, _SD_ = 0.008, _t_(9) = 53.383, _p_ < .001
No Y: _M_ = .509, _SD_ = 0.011, _t_(9) = 51.854, _p_ < .001
No Pupil Size: _M_ = .536, _SD_ = 0.018, _H_ = |[55.000_a|], _p_ < .001
Only X: _M_ = .484, _SD_ = 0.010, _t_(9) = 46.946, _p_ < .001
Only Y: _M_ = .460, _SD_ = 0.010, _t_(9) = 38.391, _p_ < .001
Only Pupil Size: _M_ = .427, _SD_ = 0.011, _t_(9) = 27.784, _p_ < .001
CONFIRMATORY
No X: _M_ = .488, _SD_ = 0.010, _t_(9) = 50.072, _p_ < .001
No Y: _M_ = .507, _SD_ = 0.013, _t_(9) = 42.469, _p_ < .001
No Pupil Size: _M_ = .555, _SD_ = 0.016, _t_(9) = 44.823, _p_ < .001
Only X: _M_ = .486, _SD_ = 0.015, _t_(9) = 31.970, _p_ < .001
Only Y: _M_ = .484, _SD_ = 0.009, _t_(9) = 52.524, _p_ < .001
Only Pupil Size: _M_ = .431, _SD_ = 0.011, _t_(9) = 27.029, _p_ < .001
|[^{a.}|] Calculated using Wilcoxon's Signed Rank Test
CAPTION:
-->

There was a difference in classification accuracies for the non-parcellated dataset and those that had the pupil size, x-coordinate, and y-coordinate data systematically removed (_F_(3, 36) = 47.471, _p_ < .001, _eta^{2}_  = 0.798). Post-hoc comparisons showed that when compared to the full dataset, removing the pupil size (_t_(18) = -1.635, _p_ = .372) and y-coordinate (_t_(18) = 2.645, _p_ = .056) did not affect classification accuracy, suggesting that these data were not informing classification judgments made by the CNN. Classification for the dataset with the x-coordinates removed was lower than classification for the full dataset (_t_(18) = 9.420, _p_ < .001), showing that these data were relatively important criterion in classification decisions.
<!-- %!could also include comparisons between the var-removed datasets, but this seems to tell the story..right? -->

There was also a difference in the classification accuracies for the parcellated datasets containing only the x-coordinate, y-coordinate, and pupil size data (_F_(2, 27) = 75.145, _p_ < .001, _eta^{2}_<!--figure out how to create the eta symbol!--> = 0.848). Post-hoc comparisons show that classification accuracies for the the pupil size dataset were lower than the x-coordinate (_t_(18) = -12.213, _p_ < .001) and y-coordinate (_t_(18) = -7.026, _p_ < .001) datasets, and accuracies for classification of the x-coordinate dataset were higher than for the y-coordinate dataset (_t_(18) = 5.187, _p_ < .001). These findings suggest that pupil size is the least decodable criterion informing classification decisions, while the x-coordinate data was the most decodable.

\subsubsection{Confirmatory.}
Classification accuracy for the confirmatory timeline dataset was well above chance (_M_ = .537, _SD_ = 0.036, _t_(9) = 17.849, _p_ < .001). Accuracy for classifications of the systematically parsed data were also all better than chance (see Table x). Overall, there were some discrepancies in the pattern of results describing the relative contribution of the x- and y-coordinate data to the model, but the general trend showing that pupil size was the eye tracking data component least informative to the model remained stable in both datasets (see Table x<!--; for the confusion matrices, see Figure X-->).

<!-- \insert{fig_x} <!-- confusion matrices for confirmatory timeline (all parcellations?)-->
<!-- ! Breakdown how the tasks did with the confusion matrices -->

<!-- \insert{table_x} <!-- pattern of results compared with exploratory dataset (including timeline and image data) -->
<!-- TABLE X: (side-by-side)
TIMELINE
- Comparing systematically removed datasets with the full dataset
  ```
  Comparison Name -- Numbers -- Replicated Findings from Exploratory Dataset
  ```
  Non-Parcellated - No X: _t_(18) = 5.210, _p_ < .001, Cohen's _d_ = 1.874 -- Y
  Non-Parcellated - No Y: _t_(18) = 3.165, _p_ = .016, Cohen's _d_ = 1.110 -- N
  Non-Parcellated - No Pupil Size: _t_(18) = 1.805, _p_ = .288, Cohen's _d_ = -0.617 -- Y

- Comparing the parcellated datasets with each other
  ```
  Comparison Name -- Numbers -- Replicated Findings from Exploratory Dataset
  ```  
  Only X
    Only Y: _t_(18) = 0.495, _p_ = .874, Cohen's _d_ = 0.216 -- N
    Only Pupil Size: _t_(18) = 10.178, _p_ < .001, Cohen's _d_ = 4.118 -- Y
  Only Y
    Only Pupil Size: _t_(18) = 9.683, _p_ < .001, Cohen's _d_ = 5.095 -- Y

IMAGE
  ```
  Comparison Name -- Numbers -- Replicated Findings from Exploratory Dataset
  ```
  Non-Parcellated - No X: _t_(18) = 1.623, _p_ = .491, Cohen's _d_ = 0.568 -- Y
  Non-Parcellated - No Y: _t_(18) = 4.375, _p_ < .001, Cohen's _d_ = 2.466 -- Y
  Non-Parcellated - No Pupil Size: _t_(18) = -1.557, _p_ = .532, Cohen's _d_ = -1.445 -- Y
  Non-Parcellated - No Time: _t_(18) = -0.505, _p_ = .986, Cohen's _d_ = -0.392 -- Y

- Comparing the parcellated datasets with each other
  ```
  Comparison Name -- Numbers -- Replicated Findings from Exploratory Dataset
  ```  
  Only X
    Only Y: _t_(18) = -2.807, _p_ = .024, Cohen's _d_ = -1.073 -- N
    Only Pupil Size: _t_(18) = 5.070, _p_ < .001, Cohen's _d_ = 2.320 -- Y
  Only Y
    Only Pupil Size: _t_(18) = 7.877, _p_ < .001, Cohen's _d_ = 4.283 -- Y

CAPTION:
-->

To test generalizability of the model to other eye tracking data, classification accuracies for the non-parcellated exploratory and confirmatory timeline datasets were compared. The Shapiro-Wilk test for normality indicated that the exploratory (_W_ = 0.937, _p_ = .524) and confirmatory (_W_ = 0.884, _p_ = .145) were normally distributed, but Levene's test indicated that the variances were not equal, _F_(1, 18) = 8.783, _p_ = .008. Welch's unequal variances _t_-test did not show a difference the two datasets, _t_(13.045) = -0.907, _p_ = .381, Cohen's _d_ = -0.406. These findings suggest that the confirmatory dataset classifications were less precise <!-- had much larger SD - dataset was quite a bit smaller -->, but the deep learning model decoded the exploratory and confirmatory timeline datasets equally well.

\subsection{Plot Image Classification}
\subsubsection{Exploratory.}
Classification accuracy for the plot image data type was better than chance (_M_ = .436, _SD_ = .020, _p_ < .001), but was less accurate than the classifications for the exploratory timeline data (_t_(18) = -10.813, _p_ < .001). Accuracy for the classifications for all parcellations of the plot image data except the Pupil Size Only dataset were better than chance (see Table x<!--; for the confusion matrices, see Figure X -->). The parsed plot image dataset classification accuracies were not compared to the parsed timeline dataset classification accuracies.

<!-- \insert{fig_x} <!-- confusion matrices from image exploratory condition (all parcellations) -->
<!-- ! Breakdown how the tasks did with the confusion matrices -->

<!-- \insert{table_x} <!-- acc v chance -- image data (parsed) (includes descriptives..) -- should also specify when using nonparametric comparison
<!-- TABLE X: (side-by-side)
EXPLORATORY
No X: _M_ = .449, _SD_ = 0.014, _H_ = |[55.000_a|], _p_ < .001
No Y: _M_ = .413, _SD_ = 0.014, _t_(9) = 20.510, _p_ < .001
No Pupil Size: _M_ = .439, _SD_ = 0.014, _t_(9) = 23.266, _p_ < .001
xxxxxNo Time: _M_ = .447, _SD_ = 0.023, _t_(9) = 15.749, _p_ < .001xxxxx << thinking will remove this >>
Only X: _M_ = .414, _SD_ = 0.017, _H_ = |[55.000_a|], _p_ < .001
Only Y: _M_ = .412, _SD_ = 0.016, _t_(9) = 15.639, _p_ < .001
Only Pupil Size: _M_ = .333, _SD_ = 5.925e -4, _H_ = |[15.481_a|], _p_ = .662
CONFIRMATORY
No X: _M_ = .430, _SD_ = 0.044, _t_(9) = 7.007, _p_ < .001
No Y: _M_ = .400, _SD_ = 0.026, _H_ = |[54.000_a]|, _p_ = .002
No Pupil Size: _M_ = .466, _SD_ = 0.012, _t_(9) = 33.804, _p_ < .001
xxxxxNo Time: _M_ = .454, _SD_ = 0.017, _t_(9) = 22.871, _p_ < .001xxxxx << thinking will remove this >>
Only X: _M_ = .392, _SD_ = 0.030, _t_(9) = 6.302, _p_ < .001
Only Y: _M_ = .422, _SD_ = 0.024, _t_(9) = 11.547, _p_ < .001
Only Pupil Size: _M_ = .340, _SD_ = 0.012, _H_ = |[45.000_a|], _p_ = .040
|[^{a.}|] Calculated using Wilcoxon's Signed Rank test.
CAPTION:
-->

There was a difference in classification accuracies for the non-parcellated dataset and those that had the pupil size, x-coordinate, and y-coordinate data systematically removed (_F_(4, 45) = 7.093, _p_ < .001, _eta^{2}_ = .387). Post-hoc comparisons showed that when compared to the full dataset there was no effect of removing <!-- the time component (_t_(18) = -1.499, _p_ = .569),--> the pupil size (_t_(18) = -0.474, _p_ = .989) or x-coordinate (_t_(18) = -1.792, _p_ = .391) data, but classification accuracy was worse when the y-coordinate data were removed (_t_(18) = 2.939, _p_ = .039).

There was also a difference in the classification accuracies for the parcellated datasets containing only the x-coordinate, y-coordinate, and pupil size data (_F_(2, 17.993) = 228.137, _p_ < .001, _eta^{2}_ = .899). Because Levene's test revealed unequal variances between the groups (_F_(2, 27) = 3.815, _p_ = .035), the Welch correction was used to interpret the findings of this omnibus ANOVA. Post-hoc comparisons showed that there was no difference in the classification accuracies for the x-coordinate and y-coordinate datasets (_t_(18) = 0.423, _p_ = .906), but classification for the pupil size dataset were lower than the x-coordinate (_t_(18) = -13.569, _p_ < .001) and y-coordinate (_t_(18) = -13.235, _p_ < .001) datasets.

\subsubsection{Confirmatory.}
Classification accuracy for the confirmatory image dataset remained well above chance (_M_ = .449, _SD_ = 0.012, _t_(9) = 31.061, _p_ < .001), but was less accurate than the classifications for the confirmatory timeline data (_t_(18) = , _p_ < .001). Accuracy for classifications of the systematically parsed data were also all better than chance (see Table x<!-- for the confusion matrices see Figure X -->). As with the timeline data, there were discrepancies in the pattern of results describing the relative contribution of the x- and y-coordinate data to the model, but the general trend showing that pupil size was the eye tracking data component least informative to the model remained stable in both datasets (see Table x).

<!-- \insert{fig_x} <!-- image confirmatory confusion matrices (all parcellations) -->
<!-- ! Breakdown how the tasks did with the confusion matrices -->

To test the generalizability of the model, the classification accuracies for the non-parcellated exploratory and confirmatory plot image datasets were compared. The independent samples _t_-test showed that the deep learning model did equally well at classifying the exploratory and confirmatory plot image datasets, _t_(18) = -1.777, _p_ = .092, Cohen's _d_ = -0.795.

\section{Results}
\subsection{Timeline Data Classification}
\subsubsection{Exploratory.}
Classification accuracies for the XYP timeline dataset were well above chance (_M_ = .526, _SD_ = .018; _t_(9) = 34.565, _p_ < .001). Accuracies for classifications of the batched data subsets were all better than chance (see Figure \@ref(fig:timeline-parcellation-chance)). As shown in the confusion matrices displayed in Figure \@ref(fig:timeline-conf-matrices), the data subsets with lower overall classification accuracies almost always classified the Memorize condition at or below chance levels of accuracy. Misclassifications of the Memorize condition were split relatively evenly between the Search and Rate conditions.

<!-- Timeline Parcellation v Chance -->
```{r timeline-parcellation-chance, fig.cap = "The graph represents the average accuracy reported for each subset of the timeline data. All of the data subsets were decoded at levels better than chance (33\\%). The error bars represent standard errors.", echo = FALSE}
knitr::include_graphics(path = "results/r_code/timeline_subset_chance.pdf")
```

<!-- Timeline Confusion Matrices -->
```{r timeline-conf-matrices, fig.cap = "The confusion matrices represent the average classification accuracies for each condition of the timeline data. The vertical axis of the confusion matrices represents the actual condition for trial. The horizontle axis of the confusion matrices represents the condition that was predicted by the model.", echo = FALSE}
knitr::include_graphics(path = "figures/timeline_conf_matrices.pdf")
```

There was a difference in classification accuracy for the XYP dataset and the subsets that had the pupil size, x-coordinate, and y-coordinate data systematically removed (_F_$_{(3, 36)}$ = 47.471, _p_ < .001, \textit{$\eta$}$^{2}$ = 0.798). Post-hoc comparisons against the XYP dataset showed that classification accuracies were not affected by the removal of pupil size<!-- (XY$\varnothing$; _t_$_{(18)}$ = 1.635, _p_ = .372)--> or y-coordinate data<!-- (X$\varnothing$P; _t_$_{(18)}$ = 2.645, _p_ = .056)--> (see Table \@ref(tab:timeline-parcellation-comparisons)). The null effect present when pupil size was removed suggests that the pupil size data were not contributing unique information that was not otherwise provided by the x- and y-coordinates. A strict significance threshold of $\alpha$ = .05 implies the same conclusion for the y-coordinate data, but the relatively low degrees of freedom (_df_ = 18) and the borderline observed _p_-value (_p_ = .056) affords the possibility that there exists a small effect. Moreover, classification for the $\varnothing$YP subset was lower than the XYP dataset<!-- (_t_$_{(18)}$ = 9.420, _p_ < .001)-->, showing that the x-coordinate data were uniquely informative to the classification.
<!-- %!could also include comparisons between the var-removed datasets, but this seems to tell the story..right? -->

<!-- Timeline Parcellation Comparisons -->
\begin{table}[!h]
    \centering
    \caption{Timeline Subset Comparisons}
    \label{tab:timeline-parcellation-comparisons}
    \begin{tabular}{l c c c c}
         & \multicolumn{2}{c}{Exploratory} & \multicolumn{2}{c}{Confirmatory} \\
        \hline
        Comparison & \textit{t} & \multicolumn{1}{c|}{\textit{p}} & \textit{t} & \textit{p} \\
        \hline
        XYP vs. $\varnothing$YP & 9.420 & \multicolumn{1}{c|}{< .001} & 5.210 & < .001 \\
        XYP vs. X$\varnothing$P & 2.645 & \multicolumn{1}{c|}{.056} & 3.165 & .016 \\
        XYP vs. XY$\varnothing$ & 1.635 & \multicolumn{1}{c|}{.372} & 1.805 & .288 \\
        X$\varnothing\varnothing$ vs. $\varnothing$Y$\varnothing$ & 5.187 & \multicolumn{1}{c|}{< .001} & 0.495 & .874 \\
        X$\varnothing\varnothing$ vs. $\varnothing\varnothing$P & 12.213 & \multicolumn{1}{c|}{< .001} & 10.178 & < .001 \\
        $\varnothing$Y$\varnothing$ vs. $\varnothing\varnothing$P & 7.026 & \multicolumn{1}{c|}{< .001} & 9.683 & < .001 \\
        \hline
    \end{tabular}
\end{table}

There was also a difference in classification accuracies for the X$\varnothing\varnothing$, $\varnothing$Y$\varnothing$, and $\varnothing\varnothing$P subsets (_F_$_{(2, 27)}$ = 75.145, _p_ < .001, \textit{$\eta$}$^{2}$ = 0.848). Post-hoc comparisons showed that classification accuracy for the $\varnothing\varnothing$P subset was lower than the X$\varnothing\varnothing$<!-- (_t_$_{(18)}$ = 12.213, _p_ < .001)--> and $\varnothing$Y$\varnothing$<!-- (_t_$_{(18)}$ = 7.026, _p_ < .001)--> subsets. Classification accuracy for the X$\varnothing\varnothing$ subset was higher than the $\varnothing$Y$\varnothing$ subset<!-- (_t_$_{(18)}$ = 5.187, _p_ < .001)-->. Altogether, these findings suggest that pupil size data was the least uniquely informative to classification decisions, while the x-coordinate data was the most uniquely informative.

\subsubsection{Confirmatory.}
Classification accuracies for the Confirmatory XYP timeline dataset were well above chance (_M_ = .537, _SD_ = 0.036, _t_$_{(9)}$ = 17.849, _p_ < .001). Classification accuracies for the data subsets were also better than chance (see Figure \@ref(fig:timeline-parcellation-chance)). Overall, there was high similarity in the pattern of results for the Exploratory and Confirmatory datasets (see Figure \@ref(fig:timeline-parcellation-chance)). Furthermore, the general trend showing that pupil size was the least informative eye tracking data component was replicated in the Confirmatory dataset (see Table \@ref(tab:timeline-parcellation-comparisons)). Also in concordance with the Exploratory timeline dataset, the confusion matrices for these data revealed that the Memorize task was most often confused with the Search and Rate tasks (see Figure \@ref(fig:timeline-conf-matrices)).

To test the generalizability of the model to other eye tracking data, classification accuracies for the XYP Exploratory and Confirmatory timeline datasets were compared. The Shapiro-Wilk test for normality indicated that the Exploratory (_W_ = 0.937, _p_ = .524) and Confirmatory (_W_ = 0.884, _p_ = .145) datasets were normally distributed, but Levene's test indicated that the variances were not equal, _F_$_{(1, 18)}$ = 8.783, _p_ = .008. Welch's unequal variances _t_-test did not show a difference between the two datasets, _t_$_{(13.045)}$ = 0.907, _p_ = .381, Cohen's _d_ = 0.406. These findings inidcate that the deep learning model decoded the Exploratory and Confirmatory timeline datasets equally well, but the Confirmatory dataset classifications were less precise (as indicated by the increase in standard deviation).<!-- likely the product of a lot fewer data points -->

\subsection{Plot Image Classification}
\subsubsection{Exploratory.}
Classification accuracies for the XYP plot image data were better than chance (_M_ = .436, _SD_ = .020, _p_ < .001), but were less accurate than the classifications for the XYP Exploratory timeline data (_t_$_{(18)}$ = 10.813, _p_ < .001). Accuracies for the classifications for all subsets of the plot image data except the $\varnothing\varnothing$P subset were better than chance (see Figure \@ref(fig:img-parcellation-chance). Following the pattern expressed by the timeline dataset, the confusion matrices showed that the Memorize condition was misclassified more often than the other conditions, and appeared to be evenly mis-identified as a Search or Rate condition (see Figure \@ref(fig:img-conf-matrices)).

<!-- Image Parcellations v Chance -->
```{r img-parcellation-chance, fig.cap = "The graph represents the average accuracy reported for each subset of the image data. All of the data subsets except for the Exploratory XY$\\varnothing$ dataset were decoded at levels better than chance (33\\%). The error bars represent standard errors.", echo = FALSE}
knitr::include_graphics(path = "results/r_code/img_subset_chance.pdf")
```

<!-- Image Confidence Matrices -->
```{r img-conf-matrices, fig.cap = "The confusion matrices represent the average classification accuracies for each condition of the image data. The vertical axis of the confusion matrices represents the actual condition for the trial. The horizontle axis of the confusion matrices represents the condition that was predicted by the model.", echo = FALSE}
knitr::include_graphics(path = "figures/img_conf_matrices.pdf")
```

There was a difference in classification accuracy between the XYP dataset and the data subsets (_F_$_{(4, 45)}$ = 7.093, _p_ < .001, \textit{$\eta$}$^{2}$ = .387). Post-hoc comparisons showed that when compared to the XYP dataset, there was no effect of removing pupil size<!-- (XY$\varnothing$; _t_$_{(18)}$ = 0.474, _p_ = .989)--> or the x-coordinates<!-- ($\varnothing$YP; _t_$_{(18)}$ = 1.792, _p_ = .391)-->, but classification accuracy was worse when the y-coordinates were removed<!-- (X$\varnothing$P; _t_$_{(18)}$ = 2.939, _p_ = .039)--> (see Table \@ref(tab:image-parcellation-comparisons)).

<!-- Image Parcellation Comparisons -->
\begin{table}[!h]
    \centering
    \caption{Image Subset Comparisons}
    \label{tab:image-parcellation-comparisons}
    \begin{tabular}{l c c c c}
         & \multicolumn{2}{c}{Exploratory} & \multicolumn{2}{c}{Confirmatory} \\
        \hline
        Comparison & \textit{t} & \multicolumn{1}{c|}{\textit{p}} & \textit{t} & \textit{p} \\
        \hline
        XYP vs. $\varnothing$YP & 1.792 & \multicolumn{1}{c|}{.391} & 1.623 & .491 \\
        XYP vs. X$\varnothing$P & 2.939 & \multicolumn{1}{c|}{.039} & 4.375 & < .001 \\
        XYP vs. XY$\varnothing$ & 0.474 & \multicolumn{1}{c|}{.989} & 1.557 & .532 \\
        X$\varnothing\varnothing$ vs. $\varnothing$Y$\varnothing$ & 0.423 & \multicolumn{1}{c|}{.906} & 2.807 & .204 \\
        X$\varnothing\varnothing$ vs. $\varnothing\varnothing$P & 13.569 & \multicolumn{1}{c|}{< .001} & 5.070 & < .001 \\
        $\varnothing$Y$\varnothing$ vs. $\varnothing\varnothing$P & 13.235 & \multicolumn{1}{c|}{< .001} & 7.877 & < .001 \\
        \hline
    \end{tabular}
\end{table}

There was also a difference in classification accuracies between the X$\varnothing\varnothing$, $\varnothing$Y$\varnothing$, and $\varnothing\varnothing$P subsets (Levene's test: _F_$_{(2, 27)}$ = 3.815, _p_ = .035; Welch correction for lack of homogeneity of variances: _F_$_{(2, 17.993)}$ = 228.137, _p_ < .001, \textit{$\eta$}$^{2}$ = .899). Post-hoc comparisons showed that there was no difference in classification accuracies for the X$\varnothing\varnothing$ and $\varnothing$Y$\varnothing$ subsets<!-- (_t_$_{(18)}$ = 0.423, _p_ = .906)-->, but classification for the $\varnothing\varnothing$P subset were less accurate than the X$\varnothing\varnothing$<!-- (_t_${(18)}$ = 13.569, _p_ < .001)--> and $\varnothing$Y$\varnothing$<!-- (_t_$_{(18)}$ = 13.235, _p_ < .001)--> subsets.

\subsubsection{Confirmatory.}
Classification accuracies for the confirmatory image dataset were well above chance (_M_ = .449, _SD_ = 0.012, _t_$_{(9)}$ = 31.061, _p_ < .001), but were less accurate than the classifications of the confirmatory timeline dataset (_t_$_{(18)}$ = 11.167 _p_ < .001). Accuracies for classifications of the data subsets were also all better than chance (see Figure \@ref(fig:img-parcellation-chance)). The confusion matrices followed the pattern showing that the Memorize condition was confused most often, and was relatively evenly mis-identified as a Search or Rate trial (see Figure \@ref(fig:img-conf-matrices)). As with the timeline data, the general trend showing that pupil size data was the least informative to the model was replicated in the Confirmatory dataset (see Table \@ref(tab:image-parcellation-comparisons)).

To test the generalizability of the model, the classification accuracies for the XYP Exploratory and Confirmatory plot image datasets were compared. The independent samples _t_-test showed that the deep learning model did equally well at classifying the Exploratory and Confirmatory plot image datasets, _t_$_{(18)}$ = 1.777, _p_ = .092, Cohen's _d_ = 0.795.<!-- double-checked. looks right -->

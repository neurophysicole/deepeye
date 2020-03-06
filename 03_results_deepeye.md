\section{Results}

\subsection{Timeline Data Classification}
\subsubsection{Exploratory.}
Classification accuracies for the timeline data were well above chance (_M_ = .526, _SD_ = .018; _t_(9) = 34.565, _p_ < .001). Accuracy for classifications of the data subsets were all better than chance (see Figure \@ref(fig:timeline-parcellation-chance)). As shown in the confusion matrices displayed in Figure \@ref(fig:timeline-conf-matrices), the data subsets with lower overall classification accuracies almost always classified the Memorization condition at or below chance levels of accuracy. Misclassifications of the Memorization condition were split relatively evenly between the Search and Rate conditions.

<!-- Timeline Parcellation v Chance -->
```{r timeline-parcellation-chance, fig.cap = "When overall accuracy was lower, the prediction accuracy of a dataset was lower.", echo = FALSE}
knitr::include_graphics(path = "results/r_code/timeline_parcellation_chance.png")
```

<!-- Timeline Confidence Matrices -->
```{r timeline-conf-matrices, fig.cap = "The confusion matrices for the timeline format have shown the same pattern of results for the image set.", echo = FALSE}
knitr::include_graphics(path = "images/timeline_conf_matrices.png")
```

There was a difference in classification accuracy for the XYP dataset and the subsets that had the pupil size, x-coordinate, and y-coordinate data systematically removed (_F_$_{(3, 36)}$ = 47.471, _p_ < .001, \textit{$\eta$}$^{2}$ = 0.798). Post-hoc comparisons against the XYP dataset showed that classification accuracies were not affected by the removal of pupil size (_t_$_{(18)}$ = 1.635, _p_ = .372) or the y-coordinates (_t_$_{(18)}$ = 2.645, _p_ = .056). These null effects suggest that the pupil size and y-coordinate data were not informing classification judgments made by the CNN anymore than the data that was not removed. Classification for the $\varnothing$YP subset was lower than the XYP dataset (_t_$_{(18)}$ = 9.420, _p_ < .001), showing that these data were uniquely informative to the decoding model.
<!-- %!could also include comparisons between the var-removed datasets, but this seems to tell the story..right? -->

There was also a difference in classification accuracy for the X$\varnothing\varnothing$, $\varnothing$Y$\varnothing$, and $\varnothing\varnothing$P subsets (_F_$_{(2, 27)}$ = 75.145, _p_ < .001, \textit{$\eta$}$^{2}$ = 0.848). Post-hoc comparisons show that classification accuracy for the $\varnothing\varnothing$P subset was lower than the X$\varnothing\varnothing$ (_t_$_{(18)}$ = 12.213, _p_ < .001) and $\varnothing$Y$\varnothing$ (_t_$_{(18)}$ = 7.026, _p_ < .001) subsets. Classification accuracy for the X$\varnothing\varnothing$ subset was higher than the $\varnothing$Y$\varnothing$ subset (_t_$_{(18)}$ = 5.187, _p_ < .001). These findings suggest that pupil size data was the variable least informative to classification decisions, while the x-coordinate data was the most informative.

\subsubsection{Confirmatory.}
Classification accuracy for the confirmatory timeline dataset was well above chance (_M_ = .537, _SD_ = 0.036, _t_$_{(9)}$ = 17.849, _p_ < .001). Classifications accuracies for the data subsets were also better than chance (see Figure \@ref(fig:timeline-parcellation-chance)). Overall, there were some discrepancies in the pattern of results describing the relative contribution of the x- and y-coordinate data to the model (c.f., findings from the exploratory timeline dataset), but the general trend showing that pupil size was the least informative eye tracking data component remained stable in both datasets (see Table \@ref(tab:parcellation-comparisons)). In concordance with the exploratory timeline dataset, the confusion matrices for these data revealed that the Memorization task was most often confused with the Search and Rate tasks (see Figure \@ref(fig:timeline-conf-matrices)).

<!-- table spacing -->
```{r}
w7  <- 1/8
```

<!-- Parcellation Comparisons -->
\begin{table}
    \centering
    \caption{Parcellation Comparisons}
    \label{tab:parcellation-comparisons}
    \begin{tabular}{p{`r w7`\textwidth} p{`r w7`\textwidth} p{`r w7`\textwidth} p{`r w7`\textwidth} p{`r w7`\textwidth} p{`r w7`\textwidth} p{`r w7`\textwidth}}
         & \multicolumn{3}{c}{Timeline} & \multicolumn{3}{c}{Image} \\
        \hline
        Comparison & \textit{t} & \textit{p} & Follows Pattern & \textit{t} & \textit{p} & Follows Pattern \\
        \cline{2-7}
        XYP \\
        $\hfill\varnothing$YP & 5.210 & < .001 & Y & 1.623 & .491 & Y \\
        $\hfill$X$\varnothing$P & 3.165 & .016 & N & 4.375 & < .001 & Y \\
        $\hfill$XY$\varnothing$ & 1.805 & .288 & Y & 1.557 & .532 & Y \\
        X$\varnothing\varnothing$ \\
        $\hfill\varnothing$Y$\varnothing$ & 0.495 & .874 & N & 2.807 & .204 & N \\
        $\hfill\varnothing\varnothing$ & 10.178 & < .001 & Y & 5.070 & < .001 & Y \\
        $\varnothing$Y$\varnothing$ \\
        $\hfill\varnothing\varnothing$P & 9.683 & < .001 & Y & 7.877 & < .001 & Y \\
        \hline
    \end{tabular}
\end{table}

To test the generalizability of the model to other eye tracking data, classification accuracies for the XYP exploratory and confirmatory timeline datasets were compared. The Shapiro-Wilk test for normality indicated that the exploratory (_W_ = 0.937, _p_ = .524) and confirmatory (_W_ = 0.884, _p_ = .145) datasets were normally distributed, but Levene's test indicated that the variances were not equal, _F_$_{(1, 18)}$ = 8.783, _p_ = .008. Welch's unequal variances _t_-test did not show a difference between the two datasets, _t_$_{(13.045)}$ = 0.907, _p_ = .381, Cohen's _d_ = 0.406. These findings inidcate that the deep learning model decoded the exploratory and confirmatory timeline datasets equally well, but the confirmatory dataset classifications were less precise (as indicated by the standard deviations).<!-- likely the product of a lot fewer data points -->

\subsection{Plot Image Classification}
\subsubsection{Exploratory.}
Classification accuracy for the plot image data were better than chance (_M_ = .436, _SD_ = .020, _p_ < .001), but were less accurate than the classifications for the exploratory timeline data (_t_$_{(18)}$ = 10.813, _p_ < .001). Accuracy for the classifications for all subsets of the plot image data except the $\varnothing\varnothing$P subset were better than chance (see Figure \@ref(fig:img-parcellation-chance). Following the pattern expressed by the timeline dataset, the confusion matrices showed that the Memorization condition was misclassified more often than the other conditions, and appeared to be evenly mis-identified as a Search or Rate condition (see Figure \@ref(fig:img-conf-matrices))<!-- this difficulty in clasifying the memorize condition may be driving this effect -->. The parsed plot image dataset classification accuracies were not compared to the parsed timeline dataset classification accuracies.

<!-- Image Parcellations v Chance -->
```{r img-parcellation-chance, fig.cap = "The confusion matrices for the timeline format have shown the same pattern of results for the image set.", echo = FALSE}
knitr::include_graphics(path = "results/r_code/img_parcellation_chance.png")
```

<!-- Image Confidence Matrices -->
```{r img-conf-matrices, fig.cap = "The confusion matrices for the timeline format have shown the same pattern of results for the image set.", echo = FALSE}
knitr::include_graphics(path = "images/img_conf_matrices.png")
```

There was a difference in classification accuracy for the XYP dataset and the data subsets (_F_$_{(4, 45)}$ = 7.093, _p_ < .001, \textit{$\eta$}$^{2}$ = .387). Post-hoc comparisons showed that when compared to the XYP dataset, there was no effect of removing pupil size (_t_$_{(18)}$ = 0.474, _p_ = .989) or the x-coordinates (_t_$_{(18)}$ = 1.792, _p_ = .391), but classification accuracy was worse when the y-coordinates were removed (_t_$_{(18)}$ = 2.939, _p_ = .039).

There was also a difference in classification accuracy for the x$\varnothing\varnothing$, $\varnothing$Y$\varnothing$, and $\varnothing\varnothing$P subsets (_F_$_{(2, 17.993)}$ = 228.137, _p_ < .001, \textit{$\eta$}$^{2}$ = .899). Because Levene's test revealed unequal variances between the groups (_F_$_{(2, 27)}$ = 3.815, _p_ = .035), the Welch correction was used to interpret the findings of this omnibus ANOVA. Post-hoc comparisons showed that there was no difference in classification accuracy for the X$\varnothing\varnothing$ and $\varnothing$Yvarnothing subsets (_t_$_{(18)}$ = 0.423, _p_ = .906), but classification for the $\varnothing\varnothing$P subset were less accurate than the X$\varnothing\varnothing$ (_t_${(18)}$ = 13.569, _p_ < .001) and $\varnothing$Y$\varnothing$ (_t_$_{(18)}$ = 13.235, _p_ < .001) subsets.

\subsubsection{Confirmatory.}
Classification accuracy for the confirmatory image dataset was well above chance (_M_ = .449, _SD_ = 0.012, _t_$_{(9)}$ = 31.061, _p_ < .001), but was less accurate than the confirmatory timeline dataset classifications (_t_$_{(18)}$ = 11.167 _p_ < .001). Accuracy for classifications of the data subsets were also all better than chance (see Figure \@ref(fig:img-parcellation-chance). The confusion matrices followed the pattern showing that the Memorization condition was confused most often, and was relatively evenly mis-identified a Search or Rate trial (see Figure \@ref(fig:img-conf-matrices)). As with the timeline data, there were discrepancies in the pattern of results describing the relative contribution of the x- and y-coordinate data to the model, but the general trend showing that pupil size data was the least informative to the model remained stable (see Table \@ref(tab:parcellation-comparisons)).

To test the generalizability of the model, the classification accuracies for the XYP exploratory and confirmatory plot image datasets were compared. The independent samples _t_-test showed that the deep learning model did equally well at classifying the exploratory and confirmatory plot image datasets, _t_$_{(18)}$ = 1.777, _p_ = .092, Cohen's _d_ = 0.795.

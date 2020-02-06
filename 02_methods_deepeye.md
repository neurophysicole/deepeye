\section{Methods}

\subsection{Participants}
Two separate datasets were used to develop and test the deep CNN architecture. The two datasets were collected from two separate experiments referred to as exploratory and confirmatory. The participants for both datasets consisted of college students (Exploratory _N_ = 124; Confirmatory _N_ = 77) from a large Midwestern university who participated in exchange for class credit. Participants who took part in the exploratory experiment did not participate in the confirmatory experiment.

\subsection{Materials and Procedures}
Each participant viewed _<!-- 75? --><!-- indoor and outdoor -->_ scene images (see Figure x) while carrying out a search, memorization, or rating task. For the search task, participants were instructed to find a 'Z' or 'N' embedded in the image. If the letter was found, the participants were instructed to press a button which terminated the trial. For the memorization task, participants were instructed to memorize the image for a test that would take place when the task was completed. Memory was tested by asking participants to select which of two images they had seen during the task. For the rating task, participants were asked to think about how they would rate the image on a scale from 1 (very unpleasant) to 7 (very pleasant). The participants were prompted for their rating immediately after viewing the image. The same materials were used in both experiments with a minor variation in the procedures. In the confirmatory experiment, participants were directed as to where search targets might appear in the image (e.g., on flat surfaces). No such instructions were provided in the exploratory experiment. In both experiments, trials were presented in one mixed block, and three separate task blocks. For the mixed block, the trial types were randomly intermixed within the block. For the three separate task blocks, each block consisted entirely of one of the three tasks (search, memorize, rate).

<!-- \insert{fig_x} <!-- example scene images -->

\subsection{Apparatus}
Eye movements were recorded using an SR Research EyeLink II eye tracker with a sampling rate of 1000Hz. On some of the search trials, a probe was presented on the screen at six seconds. To equate the data from all three conditions, only the first six seconds of each trial was analyzed. Trials that were missing data were excluded before analysis. For both datasets, the trials were pooled across participants. After removing bad trials, the exploratory dataset consisted of 12,177 trials, and the confirmatory dataset consisted of 9,301 trials.

\subsection{Datasets}
Data were extracted from the two experimental datasets in timeline and plot image formats, then classified. The raw x-coordinate, y-coordinate, and pupil size data collected at every sampling time point in the trial were used as inputs to the deep learning classifier.

For the plot image datasets, the timeline data for both experiments were converted into scatterplot diagrams. The x and y coordinates and pupil size were used to plot each sample collected by the eye tracker on a scatterplot diagram (e.g., see Figure X). The coordinates were used to plot the location of the dot, pupil size was used to determine the relative size of the dot, and shading of the dot was used to indicate the time-course of the eye movements throughout the trial. The background of the plot images and first data point was white. The final data point was black. Each subsequent data point in between was incrementally darker until final data point was reached. To ensure every data point was fully represented within the scatterplot image, the following equation was used to adjust the size of the data points: dot size = (pupil size)/10 + 1. The plots were sized to match the dimensions of the data collection monitor (1024 x 768 pixels) then shrunk to (240 x 180 pixels) in an effort to limit file size.

<!-- \insert{fig_x} <!-- average image for each condition -->

\subsubsection{Parcellations.}
To systematically assess the predictive value of the data provided by each of the three eye movement dimensions (x-coordinates, y-coordinates, pupil size), plots were made with each of the dimensions removed. Plots were also made only using x-coordinate data, y-coordinate data, and pupil size data (see Figure X). For each of these separate sets of plots, a raw timeline dataset of the corresponding image dimensions (i.e., x-coordinate only, y-coordinate only, pupil size only) was also developed.
<!-- because time was used in the var-only datasets, not using time component.. follow-up? -->

<!-- \insert{fix_x} <!-- average plots of x-coord-, y-coord-, pupil size- only -->

\subsection{Classification}
Deep CNNs model architectures were implemented to classify the trials into categories of search, memorize, or rate. Each model split the data into 70\% training, 15\% validation, and 15\% testing. Each network was run through 10 iterations of the data. The same decoding models were run on the raw timeline data, and the image data.

<!-- % ~20 different versions changing kernel size, stride rate, number of filters, number of convolutional layers.. highest performing model was 03b -->

<!-- % 1) reshape to 180x240; 2) convolution: 5 filters, 20x20, 2x2; 3) LeakyReLU, alpha = 0.1; 4) BatchNormalization; 5) convolution: 3 filters, 10x10, stride 3x3; 6) LeakyReLU, alpha = 0.1; 7) BatchNormalization; 8) Flatten; 9) Dense, 6 units; 10) Dropout, alpha = 0.1; 11) BatchNormalization; 12) Dense-softmax, 3 units
% compiled using categorical crossentropy
% How many parameters in the network? 524288 I think - for e9? -->

The exploratory models consisted of _<!--##-->_ convolutional layers, _<!--##-->_ fully connected layers<!--, and ## other layers -->. To maximize the accuracy of the exploratory model, model parameters were adjusted and tested using the exploratory dataset. Adjustments consisted of changing the kernel size, stride rate, and the number of filters. In total, 16 models were tested (see Table x). The same models were used to decode the raw timeline data and the images. The most accurate model is shown in Figure x. This model consisted of two convolutional layers, and one fully connected layer (see Figure x). This final model was validated on the confirmatory dataset.

<!-- \insert{table_x} <!-- breakdown of the different models -->  <!-- ! is this necessary? -->
<!-- \insert{fig_x} <!-- breakdown of the model we actually used -->

\subsection{Analysis}
Results for the CNN architecture that resulted in the highest accuracy on the exploratory dataset are reported below. For every dataset tested, a one-sample _t_-test was used to compare the CNN accuracies against chance (33\%). The Shapiro-Wilks test of normality was conducted to test the normality for each dataset. When normality was assumed, the mean accuracy for that dataset was compared against chance using Student's _t_-test. When normality could not be assumed, the median accuracy for that dataset was compared against chance using Wilcoxon's Signed Rank test.

To determine the relative value <!-- is value the right word? --> of the three components of the eye movement data, the parcellated datasets were compared within the timeline and plot image data types. If classification accuracies were lower when the data was parcellated, the component that was removed was assumed to have some diagnostic contribution that the model was using to inform classification decisions. To determine the relative value of the contribution from each component, the accuracies from each parcellation with one dimension of the data removed were compared to the accuracies for the non-parcellated dataset using a one-way between-subjects Analysis of Variance (ANOVA). To further evaluate the decodability of each component independently, the accuracies from each parcellation containing only one dimension of the eye movement data were compared within a separate one-way between-subject ANOVA. All post-hoc comparisons were corrected using Tukey's _HSD_.

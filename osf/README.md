# Convolutional neural networks can decode eye movement data: A black box approach to predicting task from eye movements

This package contains the scripts and data used for analysis in the following manuscript:
Cole, Z. J., Kuntzelman, K., Dodd, M. D., & Johnson, M. (2020, September 23). Convolutional neural networks can decode eye movement data: A black box approach to predicting task from eye movements. [DOI](https://doi.org/10.31234/osf.io/5a6jm)

<span style = "color:red">**Important Notes**</span>

> All of the scripts provided are written to be run with the working directory being the folder containing the script.

> Accuracies were compared using the JASP Statistical Package (v0.10.2). There are no scripts for these analyses.

## DeLINEATE

The deep learning analysis was carried out using the [DeLINEATE](delineate.it)(v03b) package.

## Steps of Processing and Analysis

For each analysis, the following provides instructions for replicating the analysis described in the Cole et al. (2020) manuscript. The steps are the same for analyzing the exploratory and confirmatory datasets, although there are separate scripts for analyzing the two datasets. For each analysis, there are separate data processing steps for the image and timeline data formats. The instructions for both formats are described below. The steps are the same for each subset analysis.

### Image Data

- Process the .edf data into images: `edf_to_png.m`
- Process the .png image files into a .mat file: `png_to_mat.m`
- Run the CNN specified in the .json file for each data subset using the DeLINEATE toolbox.

### Timeline Data

- Process the .edf data into a .mat file: `edf_to_mat.m`
- Run the CNN model specified in the .json file for each data subset using the DeLINEATE toolbox.

### Confusion Matrices

Create the confusion matrices: `results_postprocess_confusion_matrices.m`

## Supplementary Analysis

The supplementary analysis was conducted using the _Full Timeline_ data subsets used in the _Exploratory_ and _Confirmatory_ analyses.

- Create the modified .mat file datasets by running the following (in no particular order): `rm_mem_trials.m`, `rm_rate_trials.m`, `rm_search_trials.m`
- For each of the _Exploratory_ and _Confirmatory_ sets, run the CNN models using the DeLINEATE toolbox (in no particular order): `no_memorize.json`, `no_rate.json`, `no_search.json`
- Edit the `supp_recalc_orig_accs.py` script. You will need to input the accuracy values from the confusion matrices for the relevant datasets and subsets from the main analysis.
- Re-calculate the accuracies using the edited script: `supp_recalc_orig_accs.py`
- Save the outputs from `supp_recalc_orig_accs.py` in a data file.
- The data is now ready for comparison and analysis.

### Confusion Matrices

For each data subset, create a confusion matrix: `supp_results_postprocess_confusion_matrices.m`

## Coco & Keller Replication Analysis

For a tutorial on this analysis (provided by Coco and Keller), follow this [link](http://www.morenococo.org/wp-content/uploads/2015/10/jov_2014_knit.html).

- Calculate the features necessary for the analysis: `ck_replicate_eye_movement_features.m`
- Run the analysis: `ck_replicate_models.r`

# Convolutional neural networks can decode eye movement data: A black box approach to predicting task from eye movements

This package contains the scripts and data used for analysis in the following manuscript:
Cole, Z. J., Kuntzelman, K., Dodd, M. D., & Johnson, M. (2020, September 23). Convolutional neural networks can decode eye movement data: A black box approach to predicting task from eye movements. [doi](https://doi.org/10.31234/osf.io/5a6jm)

## DeLiNEATE

The deep learning analysis was carried out using the [DeLineate](delineate.it)(v03b) package.

## Steps of Processing and Analysis

For each analysis, the following provides instructions for replciating the analysis described in the Cole et al. (2020) manuscript. The steps are the same for analyzing the exploratory and confirmatory datasets, although there are separate scripts for analyzing the two datasets. For each analysis, there are separate data processing steps for the image and timeline data formats. The instructions for both formats are described below. The steps are the same for each subset analysis.

NOTE: Unless you plan to update the scripts with folder names, do not move the scripts from their folder. Also, be sure to move into the folder containing the script prior to running each script.

### Image Data

- Process the .edf data into images: `edf_to_png.m`
- Process the .png image files into a .mat file: `png_to_mat.m`
- Run the CNN specified in the .json file.

### Timeline Data

- Process the .edf data into a .mat file: `edf_to_mat.m`
- Run the CNN model specified in the .json file.

### Supplementary Analysis

The supplementary analysis was conducted using the `Timeline` data subsets used in the `Exploratory` and `Confirmatory` analyses.
- First, edit the `
- First, edit the `supp_recalc_orig_accs.py` script. You will need to input the accuracy values from the confusion matrices for the relevant datasets and subsets.
- Re-calculate the accuracies: `supp_recalc_orig_accs.py` --- to compare between supp and orig analysis..
- The data is now ready for analysis.

### Coco & Keller Replication Analysis

For a tutorial on this analysis (provided by Coco and Keller), see [here](link).

#### Process the Data

- Calculate the features necessary for the analysis: `script`
- Run the analysis: `script`

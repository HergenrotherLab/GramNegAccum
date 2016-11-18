## GramNegAccum
Data analysis and prediction of small-molecule accumulation in Gram-negative bacteria

### Analysis of accumulation Data
#### Description of assay
The accumulation of a diverse library of small-molecules was measured in a LC-MS
assay. E. coli cells were incubated with compounds for 10 min before being
washed and lysed. Clarified lysate were analyzed by LC-MS/MS.

#### Generation of physiochemical descriptors
Initial 3D coordinates and protonation states for molecules were determined using
Schrodinger's Ligprep. For mixtures of epimers, the most stable diastereomer
was used. Ensembles of conformers were generated using MOE LowModeMD conformer
search (see `accum/scripts/conf_search.zsh`). Molecular descriptors were then
calculated for each conformer and averaged (see `accum/scripts/ensemble_average.py`).
Output data is located at `accum/data/merged_data.csv`.

#### Data preprocessing
All data analysis, model training, and figure generation was performed
using R. The distributions and co-correlations of descriptors were
examined in `accum/analysis/feature_select.R`. Descriptors with near-zero
variance or high co-correlation were removed in order to improve model
stability.

### Random forest classification model
A random forest model was trained using the R package `caret`. Several
cross-validation methods were examined `accum/analysis/compareCV.R` which
resulted in selection of repeated 10-fold CV (n=20) as the final method.
Variable importance was measured to identify molecular features that may
contribute to small-molecule accumulation `accum/analysis/rand_forest.R`.

# GramNegAccum
Data analysis and prediction of small-molecule accumulation in Gram-negative bacteria published as:

[__Predictive Compound Accumulation Rules Yield a Broad-Spectrum Antibiotic__](http://dx.doi.org/10.1038/nature22308).
Richter, M. F.; Drown, B. S.; Riley, A. P.; Garcia, A.; Shirai, T.; Svec, R. L.; Hergenrother, P. J.
_Nature_ __2017__, published on web May 10, 2017.

## Analysis of accumulation Data
### Description of assay
The accumulation of a diverse library of small-molecules was measured in a LC-MS
assay. _E. coli_ cells were incubated with compounds for 10 min before being
washed and lysed. Clarified lysate were analyzed by LC-MS/MS.

### Datasets
Several collections of compounds are included in `accum/data`. These correspond
to the published [Supplementary Tables](https://www.nature.com/nature/journal/vaop/ncurrent/extref/nature22308-s2.pdf).

Name | Compounds | Description
-----|--------|------------
table1 | 12 | Controls for accumulation analysis
table2 | 100 | Initial dataset for accumulation with diversity of functionality
table3 | 54 | SAR analysis that examines specific descriptors
table4 | 68 | Primary amines
table5 | 79 | Common antibiotics excluding beta-lactams
table6 | 49 | Common beta-lactams

### Generation of physiochemical descriptors
Initial 3D coordinates and protonation states for molecules were determined using
Schrodinger's Ligprep. For mixtures of epimers, the most stable diastereomer
was used. Ensembles of conformers were generated using MOE LowModeMD conformer
search (see `accum/scripts/conf_search.zsh`). Molecular descriptors were then
calculated for each conformer and averaged (see `accum/scripts/ensemble_average.py`).
Output data is located at `accum/data/table4.csv`.

### Data preprocessing
All data analysis, model training, and figure generation was performed
using R. The distributions and co-correlations of descriptors were
examined in `accum/analysis/feature_select.R`. Descriptors with near-zero
variance or high co-correlation were removed in order to improve model
stability.

## Random forest classification model
A random forest model was trained using the R package `caret`. Several
cross-validation methods were examined `accum/analysis/compareCV.R` which
resulted in selection of repeated 10-fold CV (n=20) as the final method.
Variable importance was measured to identify molecular features that may
contribute to small-molecule accumulation `accum/analysis/rand_forest.R`.

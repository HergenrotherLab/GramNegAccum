/Applications/moe2015/bin/moebatch -verbose -exec "\
ConfSearch [ \
   outfile       : '${1:r}.ensemble.mdb' \
,  infile       : '$1' \
,  infile_data   : 1 \
,  infield      : 'mol' \
,  rot_amide    : 0 \
,  rot_double   : 1 \
,  invert_sp3   : 0 \
,  chair_only   : 1 \
,  pot_charge   : 1 \
,  method       : 'LowModeMD' \
,  rigid        : 0 \
,  rigid_mode   : 'Tag' \
,  rigidHOH     : 0 \
,  rigidOH      : 0 \
,  maxfail      : 100 \
,  maxit        : 10000 \
,  maxconf      : 10000 \
,  gtest        : 0.005 \
,  mm_maxit     : 500 \
,  cutoff       : 7 \
,  cutoff_chi   : 1 \
,  rmsd         : 0.25 \
,  rmsd_H       : 0 \
,  free_shape   : 0 \
,  useQM        : 0 \
]; \
Close []; "

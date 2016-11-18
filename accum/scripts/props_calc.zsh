#!/bin/zsh

## Properties to calculate
CODES="['BCUT_PEOE_3', 'BCUT_SLOGP_0', 'BCUT_SMR_2', 'FASA+', 'FASA_H', \
  'GCUT_PEOE_2', 'GCUT_SLOGP_1', 'PEOE_PC+', 'PEOE_VSA+0', \
  'PEOE_VSA+1', 'PEOE_VSA+2', 'PEOE_VSA+4', 'PEOE_VSA+5', 'PEOE_VSA-0', \
  'PEOE_VSA-1', 'PEOE_VSA-6', 'PEOE_VSA_FHYD', 'PEOE_VSA_FPPOS', \
  'PEOE_VSA_NEG', 'PEOE_VSA_PPOS', 'Q_VSA_FPNEG', 'Q_VSA_FPPOS', 'Q_VSA_HYD', \
  'Q_VSA_PPOS', 'SMR_VSA1', 'SMR_VSA2', 'SMR_VSA3', 'SMR_VSA5', 'SlogP_VSA2', \
  'SlogP_VSA3', 'SlogP_VSA4', 'SlogP_VSA5', 'SlogP_VSA6', 'SlogP_VSA8', \
  'SlogP_VSA9', 'a_nN', 'a_nS', 'ast_fraglike', 'ast_fraglike_ext', 'b_1rotR', \
  'b_ar', 'b_max1len', 'balabanJ', 'dens', 'dipole', 'glob', 'h_emd', \
  'h_emd_C', 'h_logD', 'h_pKa', 'h_pKb', 'h_pstrain', 'lip_don', \
  'lip_violation', 'logS', 'npr2', 'opr_violation', 'petitjeanSC', 'radius', \
  'reactive', 'rings', 'rsynth', 'std_dim1', 'std_dim2', 'vsa_don', \
  'vsa_other', 'vsurf_A', 'vsurf_CP', 'vsurf_CW2', 'vsurf_CW8', 'vsurf_D8', \
  'vsurf_DD12', 'vsurf_DD13', 'vsurf_DD23', 'vsurf_DW12', 'vsurf_DW13', \
  'vsurf_DW23', 'vsurf_EDmin3', 'vsurf_ID1', 'vsurf_IW1', 'vsurf_IW2', \
  'vsurf_IW6', 'vsurf_IW7', 'vsurf_IW8', 'vsurf_Wp2', 'vsurf_Wp4', 'vsurf_Wp7']";

OPTS="[esel : 0, verbose : 1]";


echo "Calculating properties for $1";
/Applications/moe2015/bin/moebatch -verbose -exec "\
QuaSAR_DescriptorMDB [ \
    '$1' \
,   'mol' \
,   $CODES \
,   $OPTS \
]; \
Close [];"

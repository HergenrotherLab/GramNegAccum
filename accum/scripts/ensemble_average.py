"""
Analysis script for ensemble of conformers
Performs unweighted average of decriptors for ensembles of conformers.
"""

##############################################################################
# Imports and global variables
##############################################################################
from rdkit import Chem
from collections import defaultdict
import csv
import sys

# the properties to average across conformers
#properties = ['pmi1', 'pmi2', 'pmi3', 'vol', 'rgyr', 'glob', 'ecc', 'r_user_PBF', 'r_user_pmi1_MW', 'dens']
properties = ["rgyr","glob","MolWt","RB","apol","ASA","ASA+","ASA-","ASA_H","ASA_P","ast_fraglike","ast_fraglike_ext","ast_violation","ast_violation_ext","a_acc","a_acid","a_aro","a_base","a_count","a_don","a_donacc","a_heavy","a_hyd","a_IC","a_ICM","a_nB","a_nBr","a_nC","a_nCl","a_nF","a_nH","a_nI","a_nN","a_nO","a_nP","a_nS","balabanJ","BCUT_PEOE_0","BCUT_PEOE_1","BCUT_PEOE_2","BCUT_PEOE_3","BCUT_SLOGP_0","BCUT_SLOGP_1","BCUT_SLOGP_2","BCUT_SLOGP_3","BCUT_SMR_0","BCUT_SMR_1","BCUT_SMR_2","BCUT_SMR_3","bpol","b_1rotN","b_1rotR","b_ar","b_count","b_double","b_heavy","b_max1len","b_rotN","b_rotR","b_single","b_triple","CASA+","CASA-","chi0","chi0v","chi0v_C","chi0_C","chi1","chi1v","chi1v_C","chi1_C","chiral","chiral_u","DASA","DCASA","dens","density","diameter","dipole","FASA+","FASA-","FASA_H","FASA_P","FCASA+","FCASA-","FCharge","GCUT_PEOE_0","GCUT_PEOE_1","GCUT_PEOE_2","GCUT_PEOE_3","GCUT_SLOGP_0","GCUT_SLOGP_1","GCUT_SLOGP_2","GCUT_SLOGP_3","GCUT_SMR_0","GCUT_SMR_1","GCUT_SMR_2","GCUT_SMR_3","h_ema","h_emd","h_emd_C","h_logD","h_logP","h_logS","h_log_dbo","h_log_pbo","h_mr","h_pavgQ","h_pKa","h_pKb","h_pstates","h_pstrain","Kier1","Kier2","Kier3","KierA1","KierA2","KierA3","KierFlex","lip_acc","lip_don","lip_druglike","lip_violation","logP(o/w)","logS","mr","mutagenic","nmol","npr1","npr2","opr_brigid","opr_leadlike","opr_nring","opr_nrot","opr_violation","PC+","PC-","PEOE_PC+","PEOE_PC-","PEOE_RPC+","PEOE_RPC-","PEOE_VSA+0","PEOE_VSA+1","PEOE_VSA+2","PEOE_VSA+3","PEOE_VSA+4","PEOE_VSA+5","PEOE_VSA+6","PEOE_VSA-0","PEOE_VSA-1","PEOE_VSA-2","PEOE_VSA-3","PEOE_VSA-4","PEOE_VSA-5","PEOE_VSA-6","PEOE_VSA_FHYD","PEOE_VSA_FNEG","PEOE_VSA_FPNEG","PEOE_VSA_FPOL","PEOE_VSA_FPOS","PEOE_VSA_FPPOS","PEOE_VSA_HYD","PEOE_VSA_NEG","PEOE_VSA_PNEG","PEOE_VSA_POL","PEOE_VSA_POS","PEOE_VSA_PPOS","petitjean","petitjeanSC","pmi","pmi1","pmi2","pmi3","Q_PC+","Q_PC-","Q_RPC+","Q_RPC-","Q_VSA_FHYD","Q_VSA_FNEG","Q_VSA_FPNEG","Q_VSA_FPOL","Q_VSA_FPOS","Q_VSA_FPPOS","Q_VSA_HYD","Q_VSA_NEG","Q_VSA_PNEG","Q_VSA_POL","Q_VSA_POS","Q_VSA_PPOS","radius","reactive","rings","RPC+","RPC-","rsynth","SlogP","SlogP_VSA0","SlogP_VSA1","SlogP_VSA2","SlogP_VSA3","SlogP_VSA4","SlogP_VSA5","SlogP_VSA6","SlogP_VSA7","SlogP_VSA8","SlogP_VSA9","SMR","SMR_VSA0","SMR_VSA1","SMR_VSA2","SMR_VSA3","SMR_VSA4","SMR_VSA5","SMR_VSA6","SMR_VSA7","std_dim1","std_dim2","std_dim3","TPSA","VAdjEq","VAdjMa","VDistEq","VDistMa","vdw_area","vdw_vol","vol","VSA","vsa_acc","vsa_acid","vsa_base","vsa_don","vsa_hyd","vsa_other","vsa_pol","vsurf_A","vsurf_CP","vsurf_CW1","vsurf_CW2","vsurf_CW3","vsurf_CW4","vsurf_CW5","vsurf_CW6","vsurf_CW7","vsurf_CW8","vsurf_D1","vsurf_D2","vsurf_D3","vsurf_D4","vsurf_D5","vsurf_D6","vsurf_D7","vsurf_D8","vsurf_DD12","vsurf_DD13","vsurf_DD23","vsurf_DW12","vsurf_DW13","vsurf_DW23","vsurf_EDmin1","vsurf_EDmin2","vsurf_EDmin3","vsurf_EWmin1","vsurf_EWmin2","vsurf_EWmin3","vsurf_G","vsurf_HB1","vsurf_HB2","vsurf_HB3","vsurf_HB4","vsurf_HB5","vsurf_HB6","vsurf_HB7","vsurf_HB8","vsurf_HL1","vsurf_HL2","vsurf_ID1","vsurf_ID2","vsurf_ID3","vsurf_ID4","vsurf_ID5","vsurf_ID6","vsurf_ID7","vsurf_ID8","vsurf_IW1","vsurf_IW2","vsurf_IW3","vsurf_IW4","vsurf_IW5","vsurf_IW6","vsurf_IW7","vsurf_IW8","vsurf_R","vsurf_S","vsurf_V","vsurf_W1","vsurf_W2","vsurf_W3","vsurf_W4","vsurf_W5","vsurf_W6","vsurf_W7","vsurf_W8","vsurf_Wp1","vsurf_Wp2","vsurf_Wp3","vsurf_Wp4","vsurf_Wp5","vsurf_Wp6","vsurf_Wp7","vsurf_Wp8","Weight","weinerPath","weinerPol","zagreb","PBF","pmi1_MW"]
# properties = ['BCUT_PEOE_3', 'BCUT_SLOGP_0', 'BCUT_SMR_2', 'FASA+', 'FASA_H',
            #   'GCUT_PEOE_2', 'GCUT_SLOGP_1', 'PEOE_PC+', 'PEOE_VSA+0',
            #   'PEOE_VSA+1', 'PEOE_VSA+2', 'PEOE_VSA+4', 'PEOE_VSA+5', 'PEOE_VSA-0',
            #   'PEOE_VSA-1', 'PEOE_VSA-6', 'PEOE_VSA_FHYD', 'PEOE_VSA_FPPOS',
            #   'PEOE_VSA_NEG', 'PEOE_VSA_PPOS', 'Q_VSA_FPNEG', 'Q_VSA_FPPOS', 'Q_VSA_HYD',
            #   'Q_VSA_PPOS', 'SMR_VSA1', 'SMR_VSA2', 'SMR_VSA3', 'SMR_VSA5', 'SlogP_VSA2',
            #   'SlogP_VSA3', 'SlogP_VSA4', 'SlogP_VSA5', 'SlogP_VSA6', 'SlogP_VSA8',
            #   'SlogP_VSA9', 'a_nN', 'a_nS', 'ast_fraglike', 'ast_fraglike_ext', 'b_1rotR',
            #   'b_ar', 'b_max1len', 'balabanJ', 'dens', 'dipole', 'glob', 'h_emd',
            #   'h_emd_C', 'h_logD', 'h_pKa', 'h_pKb', 'h_pstrain', 'lip_don',
            #   'lip_violation', 'logS', 'npr2', 'opr_violation', 'petitjeanSC', 'radius',
            #   'reactive', 'rings', 'rsynth', 'std_dim1', 'std_dim2', 'vsa_don',
            #   'vsa_other', 'vsurf_A', 'vsurf_CP', 'vsurf_CW2', 'vsurf_CW8', 'vsurf_D8',
            #   'vsurf_DD12', 'vsurf_DD13', 'vsurf_DD23', 'vsurf_DW12', 'vsurf_DW13',
            #   'vsurf_DW23', 'vsurf_EDmin3', 'vsurf_ID1', 'vsurf_IW1', 'vsurf_IW2',
            #   'vsurf_IW6', 'vsurf_IW7', 'vsurf_IW8', 'vsurf_Wp2', 'vsurf_Wp4', 'vsurf_Wp7',
            #   'PBF']
##############################################################################
# Helper functions
##############################################################################


def get_props(mols, prop):
    """
    Creates a dict that maps mseq to a list of prop values

    Args:
        mols:    list of RDKit molecule objects
        prop:    string identifier of property to retrieve

    Output:
        d:    dict that relates parent molecule to list of property values
    """
    # initialize dict of lists
    d = defaultdict(list)
    for m in mols:
        # mseq is used as the identifier of the parent molecule
        current_mseq = m.GetProp('mseq')
        current_prop = m.GetProp(prop)

        # current conformer's property value is appended to list
        # that is mapped to parent molecule identifier
        d[current_mseq].append(float(current_prop))
    return d


def avg_prop(d):
    """
    Computes average value for molecular descriptors across conformers.
    Property must be numerical (float or int). Int properties will be
    rounded.

    Args:
        d:    defaultdict of lists which maps mseq -> list of property
            values.
    Output:
        toReturn: dict that maps mseq -> average value
    """
    # initialize dict to return
    toReturn = {}

    # iterate across all of the properties
    for k, v in d.items():
        # average across all of the conformers
        avg = reduce(lambda x, y: x + y, v) / len(v)

        # map mseq to avg value (mseq -> avg) in new dict
        toReturn[k] = avg
    return toReturn


def reduce_mol_set(mols):
    """
    Given a list of molecules with multiple conformers as sparate entries,
    reduces the entries to the lowest energy conformer and calculates average
    value of molecular properties.

    Args:
        mols:    list of conformers to reduce. Conformers originating from the
                same molecule must have identical values for the property
                'mseq'
    Output:
        toReturn:    list of conformers in which each molecule is only listed
                    once. Properties that are listed in the 'properties'
                    global variable will be averaged.
    """
    # initialize variables
    toReturn = []
    mseq = 0

    # get the reduced list of molecules, assumes mseq is ordered ascending
    for mol in mols:
        # test if this mol has a new mseq value, indicating a new molecule
        if mseq < int(mol.GetProp('mseq')):
            # add new molecule to reduced list
            mseq += 1
            toReturn.append(mol)

    # perform the property averaging
    for prop in properties:
        # get a dict of lists that maps mseq -> list of property values
        d = get_props(mols, prop)
        # average across each list
        avg = avg_prop(d)

        # enter the averaged values into the simplified list of molecules
        for mol in toReturn:
            mseq = mol.GetProp('mseq')
            mol.SetProp(str(prop), str(avg[mseq]))
            # set the number of conformers based on length of property list
            mol.SetProp('confs', str(len(d[mseq])))
    return toReturn


def write_dict_csv(d, fname):
    """
    Helper function that prints out data to a csv file
    """
    w = csv.writer(open(fname, 'wb'))
    keys = sorted(d.keys())
    for key in keys:
        w.writerow([key, ', '.join(d[key])])


def write_sdf(mols, fname):
    """
    Helper function that prints out data to a SDF file
    """
    writer = Chem.SDWriter(fname)
    for mol in mols:
        writer.write(mol)
    writer.close()

##############################################################################
# Main protocol
##############################################################################
# parse CLI args and set filename variables
file_in = sys.argv[1]
if (not file_in.endswith('.sdf')):
    print "Script only accepts SDF files."
    quit()
file_out = file_in.strip(('.sdf')) + ".csv"
sdf_out = file_in.strip(('.sdf')) + ".reduced.sdf"

# get list of molecules from input SDF file
ms = [x for x in Chem.SDMolSupplier(file_in) if x is not None]

# create reduced/averaged list of molecules
reduced_mols = reduce_mol_set(ms)

# write out the list to a new SDF file
write_sdf(reduced_mols, sdf_out)

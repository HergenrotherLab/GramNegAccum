#/bin/bash

SCRIPTDIR=../../../scripts

# Generate force/position data
echo "Generating force and position data"
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/a/SMD_4ns_prod_a.log a
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/b/SMD_4ns_prod_b.log b
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/c/SMD_4ns_prod_c.log c
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/d/SMD_4ns_prod_d.log d
tclsh $SCRIPTDIR/traj_analysis.tcl ../production/SMD_4ns_prod.log e

# Generate RMSD data
echo "Generating RMSD data"
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/a/6DNM_SMD_4ns.dcd -s _a
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/b/6DNM_SMD_4ns.dcd -s _b
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/c/6DNM_SMD_4ns.dcd -s _c
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/d/6DNM_SMD_4ns.dcd -s _d
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../production/6DNM_SMD_4ns.dcd -s _orig

# Analyze data
echo "Analyzing forces"
Rscript force.R
echo "Calculating RMSD"
Rscript RMSDcompare.R

#/bin/bash

SCRIPTDIR=../../../scripts

# Generate force/position data
echo "Generating force and position data"
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/a/SMD_4ns_a.log a
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/b/SMD_4ns_b.log b
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/c/SMD_4ns_c.log c
tclsh $SCRIPTDIR/traj_analysis.tcl ../SMDreps/d/SMD_4ns_d.log d
tclsh $SCRIPTDIR/traj_analysis.tcl ../production/smd01.log e

# Generate distance data
python $SCRIPTDIR/distance_calc.py -i atomlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/a/DNMA_SMD_4ns.dcd -s _a
python $SCRIPTDIR/distance_calc.py -i atomlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/b/DNMA_SMD_4ns.dcd -s _b
python $SCRIPTDIR/distance_calc.py -i atomlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/c/DNMA_SMD_4ns.dcd -s _c
python $SCRIPTDIR/distance_calc.py -i atomlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/d/DNMA_SMD_4ns.dcd -s _d
python $SCRIPTDIR/distance_calc.py -i atomlist.txt -p ../step5_assembly.xplor_ext.psf -d ../production/smd01.dcd -s _orig

# Generate RMSD data
echo "Generating RMSD data"
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/a/DNMA_SMD_4ns.dcd -s _a
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/b/DNMA_SMD_4ns.dcd -s _b
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/c/DNMA_SMD_4ns.dcd -s _c
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../SMDreps/d/DNMA_SMD_4ns.dcd -s _d
python $SCRIPTDIR/side_chain_rmsd.py -i RMSDlist.txt -p ../step5_assembly.xplor_ext.psf -d ../production/smd01.dcd -s _orig

# Analyze data
Rscript force.R
Rscript RMSDcompare.R
Rscript amine_distance.R

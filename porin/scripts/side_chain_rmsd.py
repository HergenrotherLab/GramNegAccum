#!/usr/bin/python
"""
Side chain RMSD calculations

"""

import os
import optparse
import sys
import subprocess
import csv

VMD_PATH = "/Applications/VMD\ 1.9.2.app/Contents/MacOS/startup.command"


def main():
    usage = """
        usage: %prog [options]
    """

    parser = optparse.OptionParser(usage)
    parser.set_defaults(verbose=False)
    parser.add_option("-i", "--index", dest="select_list", default=None,
                      help="List of atom selection strings to perform RMSD calc on [default: %default]")
    parser.add_option("-d", "--dcd", dest="traj_file",
                      default=None, help="DCD file [default: %default]")
    parser.add_option("-p", "--psf", dest="psf_file", default=None,
                      help="PSF structure file [default: %default]")
    parser.add_option("-s", "--suffix", dest="suffix", default="",
                      help="Suffix to attach to end of output filenames [default: empty]")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose")
    parser.add_option("-q", "--quiet", action="store_false", dest="verbose")

    (options, args) = parser.parse_args()
    if(options.select_list == None):
        print "Input file is needed"
        parser.print_help()
        quit()

    with open(options.select_list, 'r') as f:
        reader = csv.reader(f, delimiter='\t')
        for (name, a) in reader:
            VMD_calc_sc_rmsd(name, a, options.traj_file,
                              options.psf_file, options.suffix)


def VMD_calc_sc_rmsd(name, resid, traj_file, psf_file, file_suffix):
    output = name + file_suffix + "_rmsd.dat"
    seltext = "protein and resid " + resid + " and sidechain and not hydrogen"
    tcl = """
proc sc_rmsd {seltext1 f_r_out} {

set frame0 [atomselect top "$seltext1" frame 0]
set sel [atomselect top "$seltext1"]
set prot0 [atomselect top "protein" frame 0]
set proti [atomselect top "protein"]

set nf [molinfo top get numframes]

##################################################
# Loop over all frames.                          #
##################################################
set outfile [open $f_r_out w]
for {set i 0} {$i < $nf} {incr i} {
  # print update to where we are
  puts "frame $i of $nf"
  # get the correct frame
  $sel frame $i
  $proti frame $i

  # compute the transformation
  set trans_mat [measure fit $proti $prot0]
  # do the alignment
  $sel move $trans_mat

  puts $outfile "$i [measure rmsd $sel $frame0]"
}
close $outfile
##################################################
##################################################

}
set mol [mol new %s type psf waitfor all]
mol addfile %s waitfor all
sc_rmsd "%s" %s

quit
    """ % (psf_file, traj_file, seltext, output)
    sys.stderr.write(tcl + '\n')

    command = VMD_PATH + " -dispdev none"
    p = subprocess.Popen(command, shell=True, stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (stdoutdata, stderrdata) = p.communicate(input=tcl)
    print stdoutdata
    print stderrdata

if __name__ == '__main__':
    main()

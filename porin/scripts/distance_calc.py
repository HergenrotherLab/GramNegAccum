#!/usr/bin/python
"""
Distance calc: measure the distance of a series of atoms across trajectory frames

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
    parser.add_option("-i", "--index", dest="index_name", default=None,
                      help="List of indices that refer to atoms to be measured [default: %default]")
    parser.add_option("-d", "--dcd", dest="traj_file",
                      default=None, help="DCD file [default: %default]")
    parser.add_option("-p", "--psf", dest="psf_file", default=None,
                      help="PSF structure file [default: %default]")
    parser.add_option("-s", "--suffix", dest="suffix", default="",
                      help="Suffix to attach to end of output filenames [default: empty]")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose")
    parser.add_option("-q", "--quiet", action="store_false", dest="verbose")

    (options, args) = parser.parse_args()
    if(options.index_name == None):
        print "Atom index file is needed"
        parser.print_help()
        quit()

    with open(options.index_name, 'r') as f:
        reader = csv.reader(f, delimiter='\t')
        for (name, a, b) in reader:
            VMD_calc_distance(name, a, b, options.traj_file,
                              options.psf_file, options.suffix)


def VMD_calc_distance(name, index_a, index_b, traj_file, psf_file, file_suffix):
    output = name + file_suffix + "_r.dat"
    tcl = """
proc distance {seltext1 seltext2 f_r_out} {

set sel1 [atomselect top "$seltext1"]
set sel2 [atomselect top "$seltext2"]


set nf [molinfo top get numframes]
##################################################
# Loop over all frames.                          #
##################################################
set outfile [open $f_r_out w]
for {set i 0} {$i < $nf} {incr i} {

  puts "frame $i of $nf"
  $sel1 frame $i
  $sel2 frame $i

  set com1 [measure center $sel1 weight mass]
  set com2 [measure center $sel2 weight mass]

  set simdata($i.r) [veclength [vecsub $com1 $com2]]
  puts $outfile "$i $simdata($i.r)"
}
close $outfile
##################################################
##################################################

}
set mol [mol new %s type psf waitfor all]
mol addfile %s waitfor all
distance "index %s" "index %s" %s

quit
    """ % (psf_file, traj_file, index_a, index_b, output)
    sys.stderr.write(tcl + '\n')

    command = VMD_PATH + " -dispdev none"
    p = subprocess.Popen(command, shell=True, stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (stdoutdata, stderrdata) = p.communicate(input=tcl)
    print stdoutdata
    print stderrdata

if __name__ == '__main__':
    main()

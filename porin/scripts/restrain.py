#!/usr/bin/python
"""
Restrain: build restraints for production

Restrain take one argument:
	resname
"""

import os
import optparse
import sys
import subprocess

VMD_PATH = "/Applications/VMD\ 1.9.2.app/Contents/MacOS/startup.command"

def main():
	usage = """
		usage: %prog [options]
	"""

	parser = optparse.OptionParser(usage)
	parser.add_option("-n", "--name", dest="res_name", default=None, help="Small molecule resname [default: %default]")
	parser.add_option("-s", "--coor", dest="coor_file", default=None, help="COOR file [default: %default]")
	parser.add_option("-p", "--psf", dest="psf_file", default=None, help="PSF structure file [default: %default]")

	(options, args) = parser.parse_args()

	VMD_setup_restraints(res_name=options.res_name, coor_file=options.coor_file, psf_file=options.psf_file)

def VMD_setup_restraints(res_name, coor_file, psf_file):
	selection_txt = "resname " + res_name
	tcl = """
set mol [mol new %s type psf waitfor all]
mol addfile %s waitfor all
set allatoms [atomselect $mol all]
set smdatoms [atomselect $mol "%s"]
set restatoms [atomselect $mol "name CA and {resid 205 or resid 199 or resid 318 or resid 24 or resid 37 or resid 77}"]
$allatoms set occupancy 0
$restatoms set occupancy 5
$allatoms writepdb rest6.ref
$allatoms set occupancy 0
$smdatoms set occupancy 1
$allatoms writepdb smd_prod.ref

puts "SMD atom serial:"
$smdatoms get serial

set poreatoms [atomselect $mol "name CA and {resid 16 or resid 42 or resid 80 or resid 82 or resid 116 or resid 119 or resid 113 or resid 102}"]
puts "Pore atom serial:"
$poreatoms get serial

quit
	""" % (psf_file, coor_file,selection_txt)
	sys.stderr.write(tcl+'\n')

	command = VMD_PATH + " -dispdev none"
	p = subprocess.Popen(command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	(stdoutdata, stderrdata) = p.communicate(input=tcl)
	print stdoutdata
	print stderrdata

if __name__=='__main__':
	main()

#! /usr/local/bin/tclsh
# Trajectory analysis script
# usage:
# tclsh traj_analysis.tcl [logfile] [output prefix]

proc plots {log_in out_prefix} {
### Open the log file for reading and the output .dat file for writing
set file [open "$log_in" r]
set outFvP [open "$out_prefix.FvP.dat" w]
set outTvP [open "$out_prefix.TvP.dat" w]

### Loop over all lines of the log file
while { [gets $file line] != -1 } {
### Determine if a line contains SMD output. If so, write current $z$ position
### followed by the fource along $z$ scaled by the direction of pulling
	if {[string range $line 0 3] == "SMD "} {
		puts $outFvP "[expr [lindex $line 4]] [expr -1*[lindex $line 7]]"
		puts $outTvP "[expr [lindex $line 1]] [expr [lindex $line 4]]"
	}
}
### Close the files
close $file
close $outFvP
close $outTvP
}

if { $::argc > 1 } {
    plots [lindex $argv 0] [lindex $argv 1]
} else {
    puts "no command line argument passed"
}

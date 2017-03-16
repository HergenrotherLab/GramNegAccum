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

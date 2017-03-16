proc set_rep {solute} {
  foreach molid [molinfo list] {
    # delete current representations
    for {set i 0} {$i < [molinfo $molid get numreps]} {incr i} {
      mol delrep $i $molid
    }
    # rep0
    mol representation {NewCartoon 0.300000 10.000000 4.100000 0}
    mol selection protein
    mol color {ColorID 3}
    mol material AOChalky
    mol addrep $molid
    # rep1
    mol representation {Licorice 0.300000 22.000000 22.000000}
    mol selection {resname $solute}
    mol color Name
    mol material AOChalky
    mol addrep $molid
    # rep2
    mol representation {Licorice 0.300000 12.000000 12.000000}
    mol selection {protein and (resid 121 or resid 113 or resid 117)}
    mol color {ColorID 1}
    mol material AOChalky
    mol addrep $molid
    # rep3
    mol representation {Licorice 0.300000 12.000000 12.000000}
    mol selection {protein and (resid 132 or resid 82 or resid 42)}
    mol color {ColorID 0}
    mol material AOChalky
    mol addrep $molid
  }
}

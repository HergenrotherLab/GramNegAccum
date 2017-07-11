#Name: Project Table:Plane of Best Fit - PJH Lab
#Command: pythonrun calc_pbf.run
__doc__ = """
Performs plane of best fit analysis.
Calculates the average distance of all atoms in each molecule to the plane that
fits each structure. Plane fitting is performed by single value decomposition
(SVD) using the Numpy package.
The script can also be run from the command line.
"""

###############################################################################
# Globals, constants and imports

import argparse
import os
import sys
import numpy as np

from schrodinger import structure
from schrodinger.structutils import analyze
from schrodinger.utils import cmdline

import schrodinger
maestro = schrodinger.get_maestro()

PBF_PROPERTY = 'r_user_PBF'

###############################################################################
def run():
    """
    Main functionality that adds PBF values to the structures in selected rows.
    """

    if not maestro:
        raise RuntimeError('If running outside of Maestro, you need to supply '
                            'this function with a list of atoms.')

    pt = maestro.project_table_get()

    if len(pt.selected_rows) == 0:
        maestro.warning("There are no entries selected in order to calculate "
                        "the plane of best fit. Select some entries in the"
                        "project and try again.")
        return

    for row in pt.selected_rows:
        st = row.getStructure()

        score = calculatePBF(st)

        row[PBF_PROPERTY] = score

    pt.refreshTable()

    maestro.info("PBF values for the selected entries are now included in the "
                "project table.")

###############################################################################
def calculatePBF(st):
	"""
	Uses SVD to fit atoms in molecule to a plane then calculates the average distance to
	that plane.

	Args:
		st: Schrodinger structure object
	Returns:
		pbf: average distance of all atoms to the best fit plane
		c: centroid vector
		n: normal vector
	"""
	points = getAtomCoords(st)
	c, n = svd_fit(points)
	pbf = 12
	pbf = calcAvgDist(points, c, n)
	return pbf

def calcAvgDist(points, C, N):
    """
    Calculates the average difference a given set of points is from a plane

    Args:
        points: numpy array of points
        C: centroid vector of plane
        N: normal vector of plane
    Returns:
        Average distance of each atom from the best-fit plane
    """
    sum = 0
    for xyz in points:
        sum += abs(distance(xyz, C, N))
    return sum/len(points)

def getAtomCoords(m):
    """
    Retrieve the 3D coordinates of all atoms in molecule

    Args:
        m: Schrodinger molecule object
    Returns:
        points: numpy array of coordinates
    """
    return m.getXYZ()

def svd_fit(X):
    """
    Fitting algorithmn was obtained from https://gist.github.com/lambdalisue/7201028
    Find (n - 1) dimensional standard (e.g. line in 2 dimension, plane in 3
    dimension, hyperplane in n dimension) via solving Singular Value
    Decomposition.
    The idea was explained in the following references
    - http://www.caves.org/section/commelect/DUSI/openmag/pdf/SphereFitting.pdf
    - http://www.geometrictools.com/Documentation/LeastSquaresFitting.pdf
    - http://www.ime.unicamp.br/~marianar/MI602/material%20extra/svd-regression-analysis.pdf
    - http://www.ling.ohio-state.edu/~kbaker/pubs/Singular_Value_Decomposition_Tutorial.pdf
    Example:
        >>> XY = [[0, 1], [3, 3]]
        >>> XY = np.array(XY)
        >>> C, N = svd_fit(XY)
        >>> C
        array([ 1.5,  2. ])
        >>> N
        array([-0.5547002 ,  0.83205029])
    Args:
        X: n x m dimensional matrix which n indicate the number of the dimension
            and m indicate the number of points
    Returns:
        [C, N] where C is a centroid vector and N is a normal vector
    """
    # Find the average of points (centroid) along the columns
    C = np.average(X, axis=0)
    # Create CX vector (centroid to point) matrix
    CX = X - C
    # Singular value decomposition
    U, S, V = np.linalg.svd(CX)
    # The last row of V matrix indicate the eigenvectors of
    # smallest eigenvalues (singular values).
    N = V[-1]
    return C, N

def distance(x, C, N):
    """
    Calculate an orthogonal distance between the points and the standard
    Args:
        x: n x m dimensional matrix
        C: n dimensional vector whicn indicate the centroid of the standard
        N: n dimensional vector which indicate the normal vector of the standard
    Returns:
        m dimensional vector which indicate the orthogonal disntace. the value
        will be negative if the points beside opposite side of the normal vector
    """
    return np.dot(x-C, N)

###############################################################################
def parse_args():
    """
    Parse the command line options.

    @return:  All script arguments and options
    @rtype:  class:`argparse.Namespace`
    """

    parser = cmdline.create_argument_parser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("infile",
                    help="Input file.")

    args = parser.parse_args()

    if not os.path.exists(args.infile):
        print "File '%s' does not exist." % args.infile
        sys.exit(1)

    return args


###############################################################################
if __name__ == '__main__':

    cmd_args = parse_args()

    for st in structure.StructureReader(cmd_args.infile):
        print st.title, 'PBF', calculatePBF(st)

#!/bin/zsh
setopt extendedglob

# loop over all SDF files that have not been filtered
for f in ./*.sdf~*amine.sdf; do;
echo "File: $f";
# Primary amines
echo "Primary amine searching";
echo obabel $f -osdf -O ${f:r}.amine.sdf --filter "s='[\$([N;H2;X3][CX4]),\$([N;H3;X4+][CX4])]'";
obabel $f -osdf -O ${f:r}.amine.sdf --filter "s='[\$([N;H2;X3][CX4]),\$([N;H3;X4+][CX4])]'";
# Secondary amines
echo "Secondary amines searching";
echo obabel $f -osdf -O ${f:r}.sec-amine.sdf --filter "s='[\$([CX4][N;H1;X3][CX4]),\$([CX4][N;H2;X4+][CX4])]'";
obabel $f -osdf -O ${f:r}.sec-amine.sdf --filter "s='[\$([CX4][N;H1;X3][CX4]),\$([CX4][N;H2;X4+][CX4])]'";
# Tertiary amines
echo "Teriary amine searching";
echo obabel $f -osdf -O ${f:r}.tert-amine.sdf --filter "s='[NX3]([CX4])([CX4])[CX4]'";
obabel $f -osdf -O ${f:r}.tert-amine.sdf --filter "s='[NX3]([CX4])([CX4])[CX4]'";
# Carboxylic acids
echo "Acid searching";
echo obabel $f -osdf -O ${f:r}.acid.sdf --filter "s='[CX3](=O)[OX1H0-,OX2H1]'";
obabel $f -osdf -O ${f:r}.acid.sdf --filter "s='[CX3](=O)[OX1H0-,OX2H1]'";
done

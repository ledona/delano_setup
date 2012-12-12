#!/bin/bash

# If this does not work then the progs are likely not in the path that is recogned by emacs
pyflakes "$1"

# things to ignore in pep
# space after column
PEP_IGNORES=E231
# line is too long
PEP_IGNORES=$PEP_IGNORES,E501
# trailing whitespace
PEP_IGNORES=$PEP_IGNORES,W291
# 2 spaces before inline comment
PEP_IGNORES=$PEP_IGNORES,E261
# continuation line over indented
PEP_IGNORES=$PEP_IGNORES,E126
# last braket tab
PEP_IGNORES=$PEP_IGNORES,E123
# multiple spaces before operator
PEP_IGNORES=$PEP_IGNORES,E221
# space after colon
PEP_IGNORES=$PEP_IGNORES,E203
# empty line with spaces
PEP_IGNORES=$PEP_IGNORES,W293


# ignores E203,W293,E501,E221,E701,E202,E702,W291,W391,E123
pep8 --ignore=$PEP_IGNORES --repeat "$1"
# pep8 --ignore=E203,W293,E501,E221,E701,E202,E702,W291,W391,E123 --repeat "$1"
true

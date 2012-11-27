#!/bin/bash

# If this does not work then the progs are likely not in the path that is recogned by emacs
pyflakes "$1"
pep8 --ignore=E203,W293,E501,E221,E701,E202,E702,W291,W391,E123 --repeat "$1"
true

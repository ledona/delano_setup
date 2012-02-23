#!/bin/bash

# If this does not work then the progs are likely not in the path that is recogned by emac
pyflakes "$1"
pep8 --ignore=W293,E501,E221,E701,E202,W291 --repeat "$1"
true

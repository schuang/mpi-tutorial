#!/bin/bash

# "apt install librsvg2-bin" to for .svg images to work
pandoc -t beamer -V aspectratio=169 -o mpi-part2.pdf  --pdf-engine=xelatex mpi-part2.md

#pandoc -t html -s -o mpi-part2.html mpi-part2.md

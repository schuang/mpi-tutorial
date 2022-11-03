#!/bin/bash

# "apt install librsvg2-bin" to for .svg images to work
pandoc -t beamer -V aspectratio=169 -o mpi-part1.pdf  --pdf-engine=xelatex mpi-part1.md

pandoc -t html -s -o mpi-part1.html mpi-part1.md

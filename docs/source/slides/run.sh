#!/bin/bash

# "apt install librsvg2-bin" to for .svg images to work
pandoc -t beamer -V aspectratio=169 -o mpi.pdf  --pdf-engine=xelatex mpi-slides.md

pandoc -t html -s -o mpi-part1.html mpi-slides.md
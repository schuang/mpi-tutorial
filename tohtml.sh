#!/bin/bash

for i in `ls *.cpp` Makefile; do
  source-highlight -i $i -o $i.html
done

#! /bin/bash

INPUT=$1
OUTPUT=$2

OBJ=${INPUT%.svg}
OBJ_CNT=$(inkscape --actions "select-all;select-list" $INPUT 2>/dev/null | \
          grep ^$OBJ-[0-9] | \
          cut -d' ' -f1 | cut -d'-' -f2 | \
          sort -n | tail -n 1)

ROWS=5
COLS=4

ACTIONS=
for r in $(seq $ROWS); do
    ids=$(seq $OBJ_CNT)
    for c in $(seq $COLS); do
        id=$(shuf -e -n 1 $ids)
        ids=${ids//$id/}
        ACTIONS+="select-by-id:$OBJ-$id;"
        ACTIONS+="clone;"
        ACTIONS+="select-by-id:$OBJ-anchor-$r-$c;"
        ACTIONS+="object-align:hcenter last;"
        ACTIONS+="object-align:vcenter last;"
        ACTIONS+="select-clear;"
    done
done

ACTIONS+="export-filename:$OUTPUT;"
ACTIONS+="export-do;"

inkscape --actions "$ACTIONS" $INPUT

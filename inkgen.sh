#! /bin/bash

input=$1
output=$2

obj=${input%.svg}
obj_cnt=$(inkscape --actions "select-all;select-list" $input 2>/dev/null | \
          grep ^$obj-[0-9] | \
          cut -d' ' -f1 | cut -d'-' -f2 | \
          sort -n | tail -n 1)

rows=5
cols=4

actions=
for r in $(seq $rows); do
    ids=$(seq $obj_cnt)
    for c in $(seq $cols); do
        id=$(shuf -e -n 1 $ids)
        ids=${ids/$id/}
        actions+="select-by-id:$obj-$id;"
        actions+="clone;"
        actions+="select-by-id:$obj-anchor-$r-$c;"
        actions+="object-align:hcenter last;"
        actions+="object-align:vcenter last;"
        actions+="select-clear;"
    done
done

actions+="export-filename:$output;"
actions+="export-do;"

inkscape --actions "$actions" $input

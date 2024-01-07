#! /bin/bash

if [[ $1 = "--help" || $1 = "-h" ]]; then
    echo "Usage: inkgen INPUT.svg OUTPUT.pdf"
    exit
fi

input=$1
output=$2

name=${input%.svg}
objs=( ${name/-/ } )
declare -A obj_cnt
for obj in "${objs[@]}"; do
    obj_cnt[$obj]=$(inkscape --actions "select-all;select-list" $input 2>/dev/null | \
                    grep ^$obj-[0-9] | \
                    cut -d' ' -f1 | cut -d'-' -f2 | \
                    sort -n | tail -n 1)
done

rows=5
cols=4

actions=
for r in $(seq $rows); do
    declare -A ids
    for obj in "${objs[@]}"; do
        ids[$obj]=$(seq ${obj_cnt[$obj]})
    done
    for c in $(seq $cols); do
        for obj in "${objs[@]}"; do
            id=$(shuf -e -n 1 ${ids[$obj]})
            ids[$obj]=${ids[$obj]/$id/}
            actions+="select-by-id:$obj-$id;"
            actions+="clone;"
            actions+="select-by-id:$obj-anchor-$r-$c;"
            actions+="object-align:hcenter last;"
            actions+="object-align:vcenter last;"
            actions+="select-clear;"
        done
    done
done

actions+="export-filename:$output;"
actions+="export-do;"

inkscape --actions "$actions" $input

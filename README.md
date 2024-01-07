# inkgen: generating permutations of objects in Inkscape documents

Usage:
```
./inkgen.sh INPUT.svg OUTPUT.svg
```

where `INPUT` is the name of the object type to permute. The document
`INPUT.svg` must contain two kinds of objects with respective ids:

- `INPUT-<n>` are the objects to permute. They should be placed outside of the
  main document area.
- `INPUT-anchor-<r>-<c>` are the places where the final objects will be placed.
  These should be inside the main document area, arranged in a grid of `R` rows
  and `C` columns.

For each row, the tool generates a permutation of `C` objects and aligns them to
the anchor points. The individual objects cannot repeat within a row but may
repeat between rows.

The document may contain multiple object types, in that case the file name is of
the form `obj1-obj2-...-objn.svg` and each object type should have the
corresponding objects and anchors.

For now, the number of rows and colunms is fixed to 5x4.

#!/bin/bash


# The expected number of columns
expected_cols=$(head -1 tmdb-movies.csv | awk -F',' '{print NF}')
echo "Number of columns: $expected_cols"

# To display rows where number of columns does not match
echo $(awk -F',' -v expected=$expected_cols '{if (NF != expected) print "Row " NR " has " NF " columns.";}' tmdb-movies.csv)
row_list=$(awk -F',' -v expected=$expected_cols '{if (NF != expected) print NR}' tmdb-movies.csv)

# To display the content of mismatch row
for row in $row_list
do
	csvcut -c 1- tmdb-movies.csv | sed -n "${row}p"
done


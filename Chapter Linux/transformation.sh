#!/bin/bash

sort -t, k14,14r tmdb-movies.csv > sorted_by_date.csv

awk -F, '$10 > 7.5' tmdb-movies.csv > movies_rating.csv



#!/bin/bash

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Input file not found!"
    exit 1
fi

# Check if the file is tab-separated
if ! grep -q $'\t' "$1"; then
    echo "File is not tab-separated!"
    exit 1
fi

# removing continent column
cut -f1-6 -d$'\t' $1 > temp1.tsv

# Clean the header
sed -i 's/- Sex: all - Age: at birth - Variant: estimates//g' temp1.tsv
sed -i 's/ (historical estimates)//g' temp1.tsv


header_=$(head -n 1 temp1.tsv)

echo $header_

# Get the number of fields in the header
num_fields=$(head -n 1 temp1.tsv | tr '\t' '\n' | wc -l)

# num_fields="6"
> temp2.tsv
# Read the input file line by line
while read -r fields; do

    # Check if the number of fields in the current row is equal to the number of fields in the header
    if [[ $(echo "$fields" | awk -F'\t' '{print NF}') -eq $num_fields ]]; then
        # If yes, output the row to the temporary file
        echo -e "${fields[@]}" >> temp2.tsv
    fi
done < temp1.tsv

awk -F'\t' '$3 >= 2011 && $3 <= 2021' temp2.tsv > temp1.tsv

# Sort the file excluding the header on the first row
tail -n +2 temp1.tsv | sort -t $'\t' -k2,2 -k1,1 > temp2.tsv
echo $header_ > $1
cat temp2.tsv >> $1
rm temp1.tsv
rm temp2.tsv

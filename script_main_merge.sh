#!/bin/bash
sort -k1,1 -k2,2 -k3,3 gdp-vs-happiness.tsv > file1_sorted.tsv
sort -k1,1 -k2,2 -k3,3 homicide-rate-unodc.tsv > file2_sorted.tsv
sort -k1,1 -k2,2 -k3,3 life-satisfaction-vs-life-expectancy.tsv > file3_sorted.tsv

awk -F'\t' ' 
BEGIN { OFS=FS } 
NR==FNR { 
  key = $1 "\t" $2 "\t" $3
  a[key] = $0
  next 
} 
{ 
  key = $1 "\t" $2 "\t" $3
  if (key in a) {
    print a[key], $4, $5, $6  # Adjust the column indices as necessary
    delete a[key]
  } else {
    print "", "", "", $0  # Adjust the number of columns for file2
  }
} 
END { 
  for (key in a) {
    print a[key], "", "", ""  # Adjust the number of columns for file2
  }
}' file1_sorted.tsv file2_sorted.tsv > temp1.tsv


cut --complement -f4 temp1.tsv > temp2.tsv


cut --complement -f6 file3_sorted.tsv > temp3.tsv

awk -F'\t' ' 
BEGIN { OFS=FS } 
NR==FNR { 
  key = $1 "\t" $2 "\t" $3
  a[key] = $0
  next 
} 
{ 
  key = $1 "\t" $2 "\t" $3
  if (key in a) {
    print a[key], $4, $5, $6  # Adjust the column indices as necessary
    delete a[key]
  } else {
    print "", "", "", $0  # Adjust the number of columns for file2
  }
} 
END { 
  for (key in a) {
    print a[key], "", "", ""  # Adjust the number of columns for file2
  }
}'  temp3.tsv temp2.tsv > temp4.tsv


awk 'BEGIN{FS=OFS="\t"} {$(NF+1)=$4} 1' temp4.tsv > temp5.tsv

cut --complement -f4 temp5.tsv > temp6.tsv

awk 'BEGIN{FS=OFS="\t"} {$(NF+1)=$4} 1' temp6.tsv > temp7.tsv
echo -e "Entity\tCode\tYear\tGDP per capita\tPopulation\tHomicide Rate\tLife Expectancy\tCantril Ladder score\t" > final_merge.tsv
cut --complement -f4 temp7.tsv >> final_merge.tsv

rm -f temp1.tsv temp2.tsv temp3.tsv temp4.tsv temp5.tsv temp6.tsv temp7.tsv file1_sorted.tsv file2_sorted.tsv file3_sorted.tsv


rm -rf q3
pig -x local q3.pig
sdiff test_code q3/part-r-00000

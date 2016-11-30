rm -rf q4
pig -x local q4.pig
sdiff test_code q4/part-r-00000

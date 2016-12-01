rm -rf q1
pig -x local q1.pig
sdiff test_code q1/part-r-00000

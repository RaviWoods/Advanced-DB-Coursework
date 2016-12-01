rm -rf q2
pig -x local q2.pig
sdiff test_code q2/part-r-00000

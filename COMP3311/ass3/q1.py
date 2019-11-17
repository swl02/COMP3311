# COMP3311 19T3 Assignment 3

import cs3311
#import time
#import psycopg2

#conn = psycopg2.connect("dbname=a3")
#start = time.perf_counter()

conn = cs3311.connect()

cur = conn.cursor()

# TODO
cur.execute("select * from q1")
for tup in cur.fetchall():
    course,count,total = tup
    percentage = (count * 100)/total
    print(course + ' ' + str(round(percentage)) + '%')

cur.close()
conn.close()

#end = time.perf_counter()

#print(end - start) 

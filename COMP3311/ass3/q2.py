# COMP3311 19T3 Assignment 3

import cs3311
import sys
conn = cs3311.connect()

cur = conn.cursor()

# TODO
if len(sys.argv) == 2 :
    arg = sys.argv[1]
else :
    arg = 2


real_query = cur.mogrify("select course,val from q2 where total = %s",[arg])
cur.execute(real_query)
# GETTING THE PATTERN NEEDED 
for tup in cur.fetchall():

    print(tup[0] + ': ' + tup[1])

code_num = {}

    

cur.close()
conn.close()

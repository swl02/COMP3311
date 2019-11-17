# COMP3311 19T3 Assignment 3

import cs3311
import sys
conn = cs3311.connect()

cur = conn.cursor()

# TODO
if len(sys.argv) == 2 :
    code = sys.argv[1]
else :
    code = 'ENGG'

query = cur.mogrify("select distinct building from q3 where course ilike %s",[code + '%'])
cur.execute(query)

##DEFINE LIST TO STORE BUILDING
building = []

for tup in cur.fetchall():
    building.append(tup[0])    
        
for b in building:
    course_query = cur.mogrify("select course from q3 where building like %s and course ilike %s",[b,code + '%'])
    cur.execute(course_query)
    print(b)    
    for tup in cur.fetchall():
       print(' ' + tup[0])
    
    
    

cur.close()
conn.close()

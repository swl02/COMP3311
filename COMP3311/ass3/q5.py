# COMP3311 19T3 Assignment 3

import cs3311
import sys
conn = cs3311.connect()

cur = conn.cursor()

# TODO
if len(sys.argv) == 2:
    course = sys.argv[1]
else:
    course = 'COMP1521'
    
query = cur.mogrify("select * from q5 where course ilike %s",[course])
cur.execute(query)

for tup in cur.fetchall():
    classtype,tag,quota,total,course = tup
    percentage = round((total/quota) * 100)

    if percentage < 50:
        tag = tag.strip(' ')
        print(classtype + ' ' + tag + ' is ' + str(percentage) + '% full')


cur.close()
conn.close()

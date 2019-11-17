# COMP3311 19T3 Assignment 3

import cs3311
import sys
conn = cs3311.connect()

cur = conn.cursor()

# TODO
##DDEFAULT CASE
if len(sys.argv) == 2:
    arg = sys.argv[1]
else :
    arg = 'ENGG'

#CHECK NUM OF TERM
term = []    
cur.execute("select distinct term from q4 ")
for tup in cur.fetchall():
    term.append(tup[0])
    
statement = "select course,total from q4 where course ilike %s and term like %s"

for t in term:
    query = cur.mogrify(statement,[arg + '%',t])
    print(t)
    cur.execute(query)    
    for tup in cur.fetchall():
        print(' ' + tup[0] + '(' + str(tup[1]) + ')')





cur.close()
conn.close()

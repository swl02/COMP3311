# COMP3311 19T3 Assignment 3

import cs3311
import sys
conn = cs3311.connect()

cur = conn.cursor()

# TODO
def convert_minute(time):
    minute = int(time[-2:])  
    #print('here ' + str(minute))  
    minute = minute /60 * 100
    return int(round(minute))
    
def convert_hour(time):
    hour = int(time)/100
    hour = int(hour) * 100
    return hour

if len(sys.argv) == 2:
    arg = sys.argv[1]
else:
    arg = '19T1'

mock_query = 'select  id, end_time,start_time,bin from q7 where term ilike %s order by id asc'
query = cur.mogrify(mock_query,[arg])
cur.execute(query)
counter = {}
## obtaining value
i = 0
for tup in cur.fetchall():
    r_id = tup[0]
    end_time = str(tup[1])
    start_time = str(tup[2])
    bin = tup[3]
    
    ##CONVERSION
    time_1 = convert_minute(end_time) + convert_hour(end_time)
    time_2 = convert_minute(start_time) + convert_hour(start_time)
    
    #subtraction
    time =  time_1 - time_2
    
    ###BINARY WEEK
    time = time * bin.count('1')
    #print('d   ' +start_time)
    #print(convert_minute(start_time))
    #print(time)
    
    if r_id in counter:
        counter[r_id] = counter[r_id] + time
    else:
        counter[r_id] = time
        
    #print(counter[r_id])
    #if i == 2:
        #break
    #i = i + 1
 
under = 0
val = []
for x in counter:
    
    #print(counter[x])
    if counter[x] < 20000:
        under = under+1
    else :
        val.append(x)
        
#val.sort()
#for x in val:
    #print(str(x) + ' ok')


#under = under + 1
#print(counter[100200])      #196.5,19T1
#print(counter[100160]) ## 137
#print(counter[100087]) # 135 , 19T1
#print(counter[100046]) # 140 ,19T1
#print(counter[100464]) # 197 ,19T2

 
##GET NOT USED ROOM    

query = cur.mogrify('select count(distinct code) from rooms where code ilike %s',['K-%'])
cur.execute(query)
total = cur.fetchone()


not_used = total[0] - len(counter)

not_efficient = not_used + under
percentage = (not_efficient/total[0]) * 100

#print(not_efficient)
print(str(round(percentage,1)) + '%')

    
    
cur.close()
conn.close()



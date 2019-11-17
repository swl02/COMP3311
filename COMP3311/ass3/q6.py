# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO\
def encoding_bin(binary_week,info):
    #print(info)
    val = int(info) - 1 
    binary_week[val] = '1'

def encode_binary_string(info,binary_week):
    
    ##check for dash
    dash = 0
    for num in info:
        if num == '<' or num == 'N':
            return

        if num == '-':
            dash = 1
            
      
    
    if dash == 1:
        info = info.split('-')    
        start = int(info[0])
        end = int(info[1])
        
        for x in range(start,end + 1):
            encoding_bin(binary_week,x)
            
        
    else:    
        encoding_bin(binary_week,info)



## OBTAINING INF
query = "select id,weeks from meetings order by id"
cur.execute(query)

week_txt = []
id_txt = []
for tup in cur.fetchall() :    
    id_txt.append(tup[0])
    week_txt.append(tup[1])
    
##PROCESSING INFO
i = 0
for info in week_txt:
    
    #splitting based on , to know 
    separated =  info.split(',')
    binary_week = ['0','0','0','0','0','0','0','0','0','0','0']
    #print(info)
    for update in separated:
        encode_binary_string(update,binary_week)

    binary_txt = ""
    for bin in binary_week:
        binary_txt = binary_txt + bin    
    
    mock_query = "UPDATE meetings SET weeks_binary = %s where id = %s"
    update_query = cur.mogrify(mock_query,[binary_txt,id_txt[i]])
    cur.execute(update_query)
    i = i + 1 
    
conn.commit()

cur.close()
conn.close()



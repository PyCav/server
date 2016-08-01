stats =open("stats.txt",'r')
with open("stats.txt") as fp:
        data=fp.readlines()
stats.close()
text=data[0]
string=[]
firstLine=1
Ocount=0
Bcount=0
stats=open("stats.txt",'w')
for i in range(0,len(text)):
        if firstLine==1:
                if text[i]=='O':
                        Ocount+=1
                if Ocount==4:
                        string.append(text[0:i+1]+'\n')
                        firstLine=0
        else:
                if text[i]=='B':
                        Bcount+=1
                if Bcount==6:
                        string.append(text[len(string):i+1]+'\n')
                        Bcount=0
for line in string:
        stats.write(line)
stats.close()
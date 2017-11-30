#!/usr/bin/python
import serial
import MySQLdb
import time


dbConn = MySQLdb.connect("140.122.184.221", "root", "imwang810412", "Sensors") or die("could not connect to database")
cursor = dbConn.cursor()
device = '/dev/ttyACM1'

try:
 print "Trying...",device
 arduino = serial.Serial(device,9600)
except:
 print "Failed to connect on",device


data = arduino.readline()

while data!=0 :
  
    if(data[0]=='p'):
        ph = data.strip('pH value:')
        cursor.execute("INSERT INTO ph(ph) VALUES (%s)",[ph])
        data = arduino.readline()
        print ph
        if(data[0]=='o'):
            orp = data.strip('orp value:')
            cursor.execute("INSERT INTO orp(orp) VALUES (%s)",[orp])
            dbConn.commit()
            print orp
    data = arduino.readline()   
    time.sleep(1)
      
  
  #cursor.execute("INSERT INTO EC(EC,TDS) VALUES ('%s','%s')",(ec,tds))
  #dbConn.commit()
  
        
cursor.close()


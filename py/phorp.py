#!/usr/bin/python
import serial
import MySQLdb
import time

##設定資料庫帳號密碼及表單位置

dbConn = MySQLdb.connect("140.122.184.221", "root", "imwang810412", "Sensors") or die("could not connect to database")
cursor = dbConn.cursor()

##Sensor裝置輸入位置
device = '/dev/ttyACM1'

try:
 print "Trying...",device
 arduino = serial.Serial(device,9600)
except:
 print "Failed to connect on",device

##讀取資料，將資料傳送到資料庫指定欄位

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

##設定數據讀取時間
    time.sleep(6)
      
  
  #cursor.execute("INSERT INTO EC(EC,TDS) VALUES ('%s','%s')",(ec,tds))
  #dbConn.commit()
  
        
cursor.close()


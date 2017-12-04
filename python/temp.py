#!/usr/bin/python
import serial
import MySQLdb

##設定資料庫帳號密碼

dbConn = MySQLdb.connect("140.122.184.221", "root", "imwang810412", "Sensors") or die("could not connect to database")
cursor = dbConn.cursor()

##Sensor裝置輸入位置
device = '/dev/ttyUSB1'
try:
 print "Trying...",device
 arduino = serial.Serial(device,9600)
except:
 print "Failed to connect on",device    #尚未連結到裝置


##讀取資料，將資料傳送到資料庫指定欄位

data = arduino.readline()
temp = float(data)
var=1;
while temp!=-127.0 :       #當溫度不等於-127.0
  print temp;
  data = arduino.readline()  #讀取資料
  cursor.execute("INSERT INTO temperature(temperature) VALUES (%s)",temp) #新增至temp表單
  dbConn.commit()
  data = arduino.readline() 
  temp=float(data)  
        
cursor.close()

#!/usr/bin/python
import serial
import MySQLdb

##設定資料庫帳號密碼

dbConn = MySQLdb.connect("140.122.184.221", "root", "imwang810412", "Sensors") or die("could not connect to database")
cursor = dbConn.cursor()

## Sensors輸入位置
device = '/dev/ttyACM5'

try:
 print "Trying...",device
 arduino = serial.Serial(device,9600)
except:
    print "Failed to connect on",device  #尚未連結到裝置

##讀取資料，當接收到資料時，將資料傳送到資料庫EC表單

data = arduino.readline()
while data!=0 :       
    if(data[0]=='E'):             #當資料開頭為Ｅ的時候，就將EC去掉
      ec = data.strip('EC:')
    data = arduino.readline() 
    print ec
    cursor.execute("INSERT INTO EC(EC) VALUES (%s)",(ec)) #新增至EC表單
    if(data[0]=='T'):             #當資料開頭為Ｔ的時候，將TDS去掉
      tds = data.strip('TDS:')
      cursor.execute("INSERT INTO TDS(tds) VALUES (%s)",(tds)) #新增至TDS表單
      dbConn.commit()
      print tds
  data = arduino.readline() 
  #cursor.execute("INSERT INTO EC(EC,TDS) VALUES ('%s','%s')",(ec,tds))
  #dbConn.commit()
  
        
cursor.close()


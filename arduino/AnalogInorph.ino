/*
 # This sample code is used to test the pH meter V1.1.
 # Editor : YouYou
 # Date   : 2014.06.23
 # Ver    : 1.1
 # Product: analog pH meter
 # SKU    : SEN0161
*/

#include <SPI.h>
#include <SD.h>

#define SensorPin1 A2  //pH meter Analog output to Arduino Analog Input 0
#define SensorPin2 A3
#define Offset 0.00            //deviation compensate
#define LED 13
#define samplingInterval 20
#define printInterval 800
#define ArrayLenth  40    //times of collection
int pHArray[ArrayLenth];   //Store the average value of the sensor feedback
int orpArray[ArrayLenth];
int pHArrayIndex=0;   
int orpArrayIndex=0; 

File myFile;
void setup(void)
{
  //pinMode(LED,OUTPUT);  
  Serial.begin(9600);  
  //Serial.print("pH meter experiment!");    //Test the serial monitor
  //Serial.println("  orp meter experiment!"); 
}
void loop(void)
{
  static unsigned long samplingTime = millis();
  static unsigned long printTime = millis();
  static float pHValue,voltage,orpValue;
  if(millis()-samplingTime > samplingInterval)
  {
      pHArray[pHArrayIndex++]=analogRead(SensorPin1);
      orpArray[orpArrayIndex++]=analogRead(SensorPin2);
      if(pHArrayIndex==ArrayLenth){
      pHArrayIndex=0;
      //電位設定
      voltage = avergearray(pHArray, ArrayLenth)*5/7.5;
      //pH設定
      pHValue =voltage*0.0178-1.889;
      }
      if(orpArrayIndex==ArrayLenth){
      orpArrayIndex=0;
      //ORP設定
      orpValue = (2.7-voltage/200)/1.0;
      }
      samplingTime=millis();
  }
  if(millis() - printTime > printInterval)   //Every 800 milliseconds, print a numerical, convert the state of the LED indicator
  {
        //Serial.print("Voltage:");
        //Serial.print(voltage,2);
        Serial.print("pH value:");
        Serial.println(pHValue,4);
        Serial.print("orp value:");
        Serial.println(orpValue,4);
       
        //digitalWrite(LED,digitalRead(LED)^1);
        printTime=millis();
  }
}
float avergearray(int* arr, int number){
  int i;
  int max,min;
  float avg;
  long amount=0;
  if(number<=0){
    Serial.println("Error number for the array to avraging!/n");
    return 0;
  }
  if(number<5){   //less than 5, calculated directly statistics
    for(i=0;i<number;i++){
      amount+=arr[i];
    }
    avg = amount/number;
    return avg;
  }else{
    if(arr[0]<arr[1]){
      min = arr[0];max=arr[1];
    }
    else{
      min=arr[1];max=arr[0];
    }
    for(i=2;i<number;i++){
      if(arr[i]<min){
        amount+=min;        //arr<min
        min=arr[i];
      }else {
        if(arr[i]>max){
          amount+=max;    //arr>max
          max=arr[i];
        }else{
          amount+=arr[i]; //min<=arr<=max
        }
      }//if
    }//for
    avg = (float)amount/(number-2);
  }//if
  return avg;
}


#include <SoftwareSerial.h>
#define rx 2
#define tx 3

SoftwareSerial myserial(rx, tx);

String inputstring = "";
String sensorstring = "";
boolean input_string_complete = false;
boolean sensor_string_complete = false;

void setup() {
 Serial.begin(9600);
 myserial.begin(9600);
 inputstring.reserve(10);
 sensorstring.reserve(30);

}
void serialEvent() {
 inputstring = Serial.readStringUntil(13);
 input_string_complete = true;
}

void loop() {
   if (input_string_complete) {
 myserial.print(inputstring);
 myserial.print('\r');
 inputstring = "";
 input_string_complete = false;
 }
 if (myserial.available() > 0) {
 char inchar = (char)myserial.read();
 sensorstring += inchar;
 if (inchar == '\r') {
 sensor_string_complete = true;
 }
 }
 if (sensor_string_complete == true) {
 if (isdigit(sensorstring[0]) == false) {
 Serial.println(sensorstring);
 }
 else
 {
 print_EC_data();
 }
 sensorstring = "";
 sensor_string_complete = false;
 }
}

void print_EC_data(void) {
 char sensorstring_array[30];
 char *EC;
 char *TDS;
 char *SAL;
 char *GRAV;
 float f_ec;
 sensorstring.toCharArray(sensorstring_array, 30);
 EC = strtok(sensorstring_array, ",");
 TDS = strtok(NULL, ",");
 SAL = strtok(NULL, ",");
 GRAV = strtok(NULL, ",");
 Serial.print("EC:");
 Serial.println(EC);
 Serial.print("TDS:");
 Serial.println(TDS);
 Serial.println();
//f_ec= atof(EC);
}

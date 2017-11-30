#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 2

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void setup(void) {
  Serial.begin(9600);
  delay(1000) ;
  Serial.println( "Connecting..." ) ;
  if ( my_conn.mysql_connect( server_addr, 3306, user, password) ) {
    delay(500) ;
    my_conn.cmd_query(INSERT_SQL) ;
    Serial.println( "Query Success!" ) ;
  } // if
  
  else Serial.println( "Connection failed." ) ;
  
  Serial.println( "Temperature Sensor" ) ;
  
  sensors.begin();
} // setup()

void loop(void) {
  sensors.requestTemperatures();
  
  Serial.println(sensors.getTempCByIndex(0));
  
  delay(15000);
} // loop()

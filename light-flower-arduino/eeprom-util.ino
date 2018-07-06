
int addressRed = 0;
int addressGreen = 1;
int addressBlue = 2;


void readRGBFromEEPROM() {
  valueRed = EEPROM.read(addressRed);
  valueGreen = EEPROM.read(addressGreen);
  valueBlue = EEPROM.read(addressBlue);

  #ifdef DEBUG
  Serial.print("EEPROM values read: R: ");
  Serial.print(valueRed);
  Serial.print(" G: ");
  Serial.print(valueGreen);
  Serial.print(" B: ");
  Serial.println(valueBlue);
  #endif

  writeRGBValues();
}


void writeRGBToEEPROM() {
  EEPROM.write(addressRed, valueRed);
  EEPROM.write(addressGreen, valueGreen);
  EEPROM.write(addressBlue, valueBlue);  

  #ifdef DEBUG
  Serial.println("Values written to EEPROM");
  #endif
}


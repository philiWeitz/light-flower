//#define DEBUG

#include <EEPROM.h>

#define LED_R 3
#define LED_G 5
#define LED_B 6

byte valueRed = 255;
byte valueGreen = 255;
byte valueBlue = 255;

bool randomModeOn = false;
uint32_t randomModeSleepTime = 10;
uint32_t randomModeMinValue = 128;
byte *pColorValue = NULL;
byte randomColorTargeValue = 0;

void setup() {
  Serial.begin(9600);

  #ifdef DEBUG
  Serial.println("Up and running");
  #endif

  // get a random seed
  randomSeed(analogRead(A3));

  // get the RGB values from EEPROM
  readRGBFromEEPROM();
}

void loop() {
  readInput();

  if (randomModeOn) {
    randomColorMode();
  }
}

void randomColorMode() {
  if (pColorValue == NULL) {
    // get a target color value
    randomColorTargeValue = random(randomModeMinValue,255);
    // select a random color
    switch(random(0,3)) {
      case 0:
        pColorValue = &valueRed;
        break;
      case 1:
        pColorValue = &valueGreen;
        break;
      case 2:
        pColorValue = &valueBlue;
        break;
    }
  }

  // color was reached
  if ((*pColorValue) == randomColorTargeValue) {
     pColorValue = NULL;
  } else if ((*pColorValue) < randomColorTargeValue) {
    ++(*pColorValue);
  } else if ((*pColorValue) > randomColorTargeValue) {
    --(*pColorValue);
  }

  writeRGBValues();
  delay(randomModeSleepTime);
}

void writeRGBValues() {
  analogWrite(LED_R, valueRed);
  analogWrite(LED_G, valueGreen);
  analogWrite(LED_B, valueBlue);

  #ifdef DEBUG
  Serial.print("Write RGB values to PWM (R: ");
  Serial.print(valueRed);
  Serial.print(" ,G: ");
  Serial.print(valueGreen);
  Serial.print(" ,B: ");
  Serial.print(valueBlue);
  Serial.println(")");
  #endif
}


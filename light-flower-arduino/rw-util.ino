
#define INPUT_BUFFER_SIZE 40

#define INPUT_END_CHAR '$'
#define INPUT_DELIMITER ","

/** Configuration options:

// set the RGB values
COLOR,R,23$
COLOR,G,100$
COLOR,B,230$
COLOR,R,50$COLOR,G,100$COLOR,B,150$

// get the current RGB values
COLORS?$

// save the RGB values to EEPROM
SAVE,COLOR$

// enable random mode  
RAND,START,100,125$  -> delay, min value
// disable random mode
RAND,STOP$
// get rand state
RAND?$

**/

int inputBufferPtr = 0;
char inputBuffer[INPUT_BUFFER_SIZE];


void readInput() {

  while (Serial.available() > 0) {
    char inputChar = Serial.read();

    // input end character found -> execute command
    if(inputChar == INPUT_END_CHAR) {
      inputBuffer[inputBufferPtr] = '\0';
      parseInputBuffer();
      resetBuffer();
      
    // add char to input buffer
    } else {
      inputBuffer[inputBufferPtr] = inputChar;
      ++inputBufferPtr;
    } 

    // buffer overflow -> reset input buffer
    if(inputBufferPtr >= INPUT_BUFFER_SIZE) {
      resetBuffer();
    }   
  }
}


void parseColor() {
  char* subStr = strtok (NULL, INPUT_DELIMITER);
  if(!subStr) { return; }
  // get R,G,B
  char type = subStr[0];

  subStr = strtok (NULL, INPUT_DELIMITER);
  if(!subStr) { return; }
  // get the PWM value
  uint32_t pwmValue = min(255, atoi(subStr));

  if(type == 'R') {
    valueRed = pwmValue;  
  } else if(type == 'G') {
    valueGreen = pwmValue;  
  } else if(type == 'B') {
    valueBlue = pwmValue;  
  } else {
    Serial.println("Error: parsing color command");
    return;
  }

  #ifdef DEBUG
  Serial.println("Color command parsed");
  #endif
  
  writeRGBValues();
}


void sendColorValues() {
  Serial.print("COLORS,R,");
  Serial.print(valueRed);
  Serial.print(",G,");
  Serial.print(valueGreen);
  Serial.print(",B,");
  Serial.print(valueBlue);
  Serial.println("$");
}


void saveValue() {
  char* subStr = strtok (NULL, INPUT_DELIMITER);
  if(!subStr) { return; }

  // save the current color values
  if (strcmp(subStr, "COLOR") == 0) {
    writeRGBToEEPROM();
  }
}


void enableRandomMode() {
  char* subStr = strtok (NULL, INPUT_DELIMITER);
  if(!subStr) { return; }

  if (strcmp(subStr, "STOP") == 0) {
    randomModeOn = false;

    #ifdef DEBUG
    Serial.println("Random mode disabled");
    #endif

  } else if (strcmp(subStr, "START") == 0) {
    randomModeOn = true;

    // read the sleep time
    subStr = strtok (NULL, INPUT_DELIMITER);
    if(!subStr) { return; }
    randomModeSleepTime = atoi(subStr);

     // read the min value
    subStr = strtok (NULL, INPUT_DELIMITER);
    if(!subStr) { return; }
    randomModeMinValue = atoi(subStr);

    #ifdef DEBUG
    Serial.println("Random mode enabled");
    #endif
  }
}


void sendRandomModeState() {
  if (randomModeOn) {
    Serial.println("RAND,ENABLED$");
  } else {
    Serial.println("RAND,DISABLED$");
  }
}


void parseInputBuffer() {
  char* subStr = strtok(inputBuffer, INPUT_DELIMITER);

  if(!subStr) {
    return;
  }
  if (strcmp(subStr, "COLOR") == 0) {
    parseColor();
  } else if(strcmp(subStr, "COLORS?") == 0) {
    sendColorValues();
  } else if(strcmp(subStr, "SAVE") == 0) {
    saveValue();
  } else if(strcmp(subStr, "RAND") == 0) {
    enableRandomMode();
  } else if(strcmp(subStr, "RAND?") == 0) {
    sendRandomModeState();
  } else {
    Serial.println("Error: command not found");
  }
}


void resetBuffer() {
  inputBufferPtr = 0;
  memcpy(inputBuffer, "0", INPUT_BUFFER_SIZE);
}

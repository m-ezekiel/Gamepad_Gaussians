/*
File: Gamepad_Gaussians/functions.pde
Author: Mario Ezekiel H. (@m_ezkiel)
Desc.: Function script for Gamepad Gaussians

1. General functions
2. Get user input
3. Create keypress file
4. Write data
5. Behavior settings
6. Reset settings
7. Constrain parameters
8. Toggle preview
*/

// ----------------------- //
// 3. CREATE KEYPRESS FILE //
// ----------------------- //


public void createKeypressFile() {

  int [] datetime = dateTime();

  // Define keylogging output file naming convention
  output = createWriter("gameplay_data/" + join(nf(datetime, 2), "-") + "_gamepadKeys.txt");

  // Create headers on output file
  output.println(

    // Temporal data
    "millis" + "\t" + "xpos" + "\t" + "ypos" + "\t" + 

    // Size and dispersion {sX, sY, dpX, dpY}
    "sX" + "\t" + "sY" + "\t" + "dpX" + "\t" + "dpY" + "\t" + 

    // Color values {R, G, B, A}
    "red" + "\t" + "green" + "\t" + "blue" + "\t" + "opacity" + "\t" + 

    // Keypress booleans {action, LR, select/M*, d-pad}
    "A1" + "\t" + "A2" + "\t" + "A3" + "\t" + "A4" + "\t" + 
    "L1" + "\t" + "R1" + "\t" + "L2" + "\t" + "R2" + "\t" + 
    "S1" + "\t" + "S2" + "\t" + "M1" + "\t" + "M2" + "\t" + 
    "up" + "\t" + "down" + "\t" + "left" + "\t" + "right" + "\t" + 

    // Analog axis values
    "anlgX" + "\t" + "anlgY" + "\t" + "anlgU" + "\t" + "anlgV" + "\t" +

    // Focal points {x_mean, y_mean}
    "x_mean" + "\t" + "y_mean" + "\t" +

    // Joystick integers
    "joy1_int" + "\t" + "joy2_int"
     );
}





// ------------- //
// 4. WRITE DATA //
// ------------- //


public void writeData(boolean writeData) {

  if (writeData == true) {

    XYpos_array = getXYpos();
    ParamValue_array = getParamValues();
    Keypress_array = getKeypresses();
    Analog_array = getAnalogValues();

    // if thumb keys above threshold...
    if (abs(analogX) > .15 | abs(analogY) > .15 | abs(analogU) > .15 | abs(analogV) > .15 | actionPad_pressed == true | L2 == true | select1 == true) {

      output.println(

        // Temporal data {time, position}
        millis() + "\t" + XYpos_array[0] + "\t" + XYpos_array[1] + "\t" +

        // Size and dispersion {sX, sY, dpX, dpY}
        ParamValue_array[6] + "\t" + ParamValue_array[7] + "\t" + ParamValue_array[4] + "\t" + ParamValue_array[5] + "\t" + 

        // Color values {R, G, B, A}
        ParamValue_array[0] + "\t" + ParamValue_array[1] + "\t" + ParamValue_array[2] + "\t" + ParamValue_array[3] + "\t" +  

        // Keypresses {action, LR, select, M*, d-pad}
        Keypress_array[0] + "\t" + Keypress_array[1] + "\t" + Keypress_array[2] + "\t" + Keypress_array[3] + "\t" + Keypress_array[4] + "\t" + Keypress_array[5] + "\t" + Keypress_array[6] + "\t" + Keypress_array[7] + "\t" + Keypress_array[8] + "\t" + Keypress_array[9] + "\t" + Keypress_array[10] + "\t" + Keypress_array[11] + "\t" + Keypress_array[12] + "\t" + Keypress_array[13] + "\t" + Keypress_array[14] + "\t" + Keypress_array[15] + "\t" +
        
        // Analog values {js1X, js1Y, js2U, js2V}
        Analog_array[0] + "\t" + Analog_array[1] + "\t" + Analog_array[2] + "\t" + Analog_array[3] + "\t" +

        // Focal points: {x_mean, y_mean}
        x_mean + "\t" + y_mean + "\t" +

        // Joystick integers
        joystick1 + "\t" + joystick2

        );

      output.flush(); 
    }
  }   
}



/*
File: GPG_writeData.pde
Author: Mario Ezekiel H. (@m_ezkiel)
Desc.: Function script for Gamepad Gaussians
*/


// ----------
// Write data
// ----------

public void writeData(boolean writeData) {

  if (writeData == true) {

    XYpos_array = getXYpos();
    ParamValue_array = getParamValues();
    Keypress_array = getKeypresses();
    Analog_array = getAnalogValues();

    // if thumb keys above threshold...
    if (abs(analogX) > .1 | abs(analogY) > .1 | abs(analogU) > .1 | abs(analogV) > .1 | actionPad_pressed == true) {

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

        // Joystick integers
        joystick1 + "\t" + joystick2

        );

      output.flush(); 
    }
  }   
}
/*
File: GPG_resetSettings.pde
Author: Mario Ezekiel H. (@m_ezkiel)
Desc.: Function script for Gamepad Gaussians
*/


// ----------------------
// Define reset behaviors
// ----------------------

public void defineResetBehaviors() {

  // RESET BACKGROUND

  if (R2 & up) {
    resetBlack();
    output.close();
    createKeypressFile();
  }
  if (R2 & down) {
    resetWhite();
    output.close();
    createKeypressFile();  
  }
  if (R2 & right) {
    resetColor();
    output.close();
    createKeypressFile();
  }
  if (R2 & left) {
    resetInverse();
    output.close();
    createKeypressFile();
  }

  // RESET ALL VALUES TO DEFAULT
  if (select1 & select2) {
    dpX = 300;
    dpY = 300;
    brushSize_X = 350;
    brushSize_Y = 350;
    A1_ctrl = 60;
    A2_ctrl = 60;
    A3_ctrl = 60;
    A4_ctrl = 60;
    x_mean = width/2;
    y_mean = height/2;
    resetBlack();    
  }

}
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

// -------------------- //
// 5. BEHAVIOR SETTINGS //
// -------------------- //


public void defineControlBehaviors() {

  // Color & opacity (d-pad)
  if ((down|left) & A1) {A1_ctrl -= increment;}
  if ((down|left) & A2) {A2_ctrl -= increment;}
  if ((down|left) & A3) {A3_ctrl -= increment;}
  if ((down|left) & A4) {A4_ctrl -= increment;}
  if ((up|right) & A1) {A1_ctrl += increment;}
  if ((up|right) & A2) {A2_ctrl += increment;}
  if ((up|right) & A3) {A3_ctrl += increment;}
  if ((up|right) & A4) {A4_ctrl += increment;}


  // Size (d-pad)
  if (up & R1) {brushSize_Y += increment * 15;}
  if (down & R1) {brushSize_Y -= increment * 15;}
  if (right & R1) {brushSize_X -= increment * 15;}
  if (left & R1) {brushSize_X += increment * 15;}


  // Dispersion (d-pad)
  if (up & R2) {dpY += increment * 10;}
  if (down & R2) {dpY -= increment * 10;}
  if (right & R2) {dpX -= increment * 10;}
  if (left & R2) {dpX += increment * 10;}


  // Position (d-pad)
  if (up & L1) {y_mean += -increment * 15;}
  if (down & L1) {y_mean -= -increment * 15;}
  if (right & L1) {x_mean += increment * 15;}
  if (left & L1) {x_mean -= increment * 15;}


  // Mute values: if (mute & button) {variable = 0}
  if ((select1) & A1) {A1_ctrl = 0;}
  if ((select1) & A2) {A2_ctrl = 0;}
  if ((select1) & A3) {A3_ctrl = 0;}
  if ((select1) & A4) {A4_ctrl = 0;}
  if (select1 & R2) {
    dpX = 300;
    dpY = 300;
  }
  if (select1 & R1) {
    brushSize_X = 350;
    brushSize_Y = 350;
  }
  if (select1 & L1) {
    x_mean = width/2;
    y_mean = height/2;
  }


  // RANDOM BEHAVIORS: if (L2) {variable = randomInt(min, max);}
  actionPad_pressed = getActionPad();

  if ((L2 & !actionPad_pressed)) {
    brushSize_Y = randomInt(0, 500);
    brushSize_X = randomInt(0, 500);
    dpY = randomInt(0, 400);
    dpX = randomInt(0, 400);
    A1_ctrl = randomInt(0, 255);
    A2_ctrl = randomInt(0, 255);
    A3_ctrl = randomInt(0, 255);
    // A4_ctrl = randomInt(1, 255);

    // // Reduce the probability of landing on full opacity
    // if (A4_ctrl > 60) {
    //   A4_ctrl = A4_ctrl / randomInt(1,5);
    // }

    // // Reduce the probability of landing on maximum size
    // if (brushSize_X > 300) {
    //   brushSize_X = brushSize_X / randomInt(1,3);
    // }
    // if (brushSize_Y > 300) {
    //   brushSize_Y = brushSize_Y / randomInt(1,3);
    // }

  }


  // Localized random behaviors

  if ((L2 & A4)) A4_ctrl = randomInt(0, 200);
  if ((L2 & A2)) A2_ctrl = randomInt(0, 255);
  if ((L2 & A1)) A1_ctrl = randomInt(0, 255);
  if ((L2 & A3)) A3_ctrl = randomInt(0, 255);
  if (L2 & R1) {
    brushSize_Y = randomInt(0, 500);
    brushSize_X = randomInt(0, 500);
  }
  if (L2 & L1) {
    x_mean = randomInt(0, width);
    y_mean = randomInt(0, height);
  }
  if (L2 & R2) {
    dpY = randomInt(0, 400);
    dpX = randomInt(0, 400);
  }


  // Color & opacity (analog)
  if (A1 & (abs(joystick1) > 2)) {A1_ctrl += increment * joystick1 / mScalar;}
  if (A2 & (abs(joystick1) > 2)) {A2_ctrl += increment * joystick1 / mScalar;}
  if (A3 & (abs(joystick1) > 2)) {A3_ctrl += increment * joystick1 / mScalar;}
  if (A4 & (abs(joystick1) > 2)) {A4_ctrl += increment * joystick1 / mScalar;}

  if (A1 & (abs(joystick2) > 2)) {A1_ctrl += increment * joystick2 / mScalar;}
  if (A2 & (abs(joystick2) > 2)) {A2_ctrl += increment * joystick2 / mScalar;}
  if (A3 & (abs(joystick2) > 2)) {A3_ctrl += increment * joystick2 / mScalar;}
  if (A4 & (abs(joystick2) > 2)) {A4_ctrl += increment * joystick2 / mScalar;}

  // Brush Size 
  if (R1 & (abs(analogX) > 0.15)) {brushSize_X += -analogX * 15 * increment;}
  if (R1 & (abs(analogY) > 0.15)) {brushSize_Y += -analogY * 15 * increment;}
  if (R1 & (abs(analogU) > 0.15)) {brushSize_X += analogU * 15 * increment;}
  if (R1 & (abs(analogV) > 0.15)) {brushSize_Y += -analogV * 15 * increment;}

  // Dispersion 
  if (R2 & (abs(analogX) > 0.15)) {dpX += -analogX * 15 * increment;}
  if (R2 & (abs(analogY) > 0.15)) {dpY += -analogY * 15 * increment;}
  if (R2 & (abs(analogU) > 0.15)) {dpX += analogU * 15 * increment;}
  if (R2 & (abs(analogV) > 0.15)) {dpY += -analogV * 15 * increment;}

  // Position
  if(L1 & (abs(analogX) > 0.15)) {x_mean += analogX * 15 * increment;}
  if(L1 & (abs(analogY) > 0.15)) {y_mean += analogY * 15 * increment;}
  if(L1 & (abs(analogU) > 0.15)) {x_mean += analogU * 15 * increment;}
  if(L1 & (abs(analogV) > 0.15)) {y_mean += analogV * 15 * increment;}

  // Map D-Pad to colors when Joystick 2 is activated
  if (left & (abs(joystick2) > 2)) {A1_ctrl += increment * joystick2 / mScalar;}
  if (down & (abs(joystick2) > 2)) {A2_ctrl += increment * joystick2 / mScalar;}
  if (right & (abs(joystick2) > 2)) {A3_ctrl += increment * joystick2 / mScalar;}
  if (up & (abs(joystick2) > 2)) {A4_ctrl += increment * joystick2 / mScalar;}


  // SAVE IMAGE
  if (select1 & select2)
    saveImage();


  // SLOW AND FAST MOTION MODES
  if (M1)
    frameRate(60);
  if (M2) {
    frameRate(2);
    increment = 1;
  }
  if (!M1 & !M2) {
    frameRate(30);
    increment = 2;
  }

}





// --------------------
// 6. RESET SETTINGS
// --------------------


public void defineResetBehaviors() {

  // Reset background to white
  if (select2 & up) {
    resetWhite();
    if (writeData == true) {
      output.close();
      createKeypressFile();
    }
  }

  // Reset background to black
  if (select2 & down) {
    resetBlack();
    if (writeData == true) {
      output.close();
      createKeypressFile();
    }
  }
}




// ----------------------- //
// 7. CONSTRAIN PARAMETERS //
// ----------------------- //


public void constrainParameters() {
  A1_ctrl = limitScale(A1_ctrl, 0, 255);
  A2_ctrl = limitScale(A2_ctrl, 0, 255);
  A3_ctrl = limitScale(A3_ctrl, 0, 255);
  A4_ctrl = limitScale(A4_ctrl, 0, 255);
  dpY = limitScale(dpY, 0, height/2);
  dpX = limitScale(dpX, 0, height/2);
  brushSize_Y = limitScale(brushSize_Y, 1, height);
  brushSize_X = limitScale(brushSize_X, 1, height);
  xpos = limitScale(xpos, -width, 2*width);
  ypos = limitScale(ypos, -height, 2*height);
  x_mean = limitScale(x_mean, 0, width);
  y_mean = limitScale(y_mean, 0, height);
}





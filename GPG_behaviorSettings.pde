/*
File: GPG_behaviorSettings.pde
Author: Mario Ezekiel H. (@m_ezkiel)
Desc.: Function script for Gamepad Gaussians
*/


// ------------------------
// Define control behaviors
// ------------------------

public void defineControlBehaviors() {

  // COLOR & OPACITY (d-pad)

  if ((down|left) & A1) {A1_ctrl -= increment;}
  if ((down|left) & A2) {A2_ctrl -= increment;}
  if ((down|left) & A3) {A3_ctrl -= increment;}
  if ((down|left) & A4) {A4_ctrl -= increment;}
  if ((up|right) & A1) {A1_ctrl += increment;}
  if ((up|right) & A2) {A2_ctrl += increment;}
  if ((up|right) & A3) {A3_ctrl += increment;}
  if ((up|right) & A4) {A4_ctrl += increment;}


  // SIZE (d-pad)

  if (up & R1) {brushSize_Y += increment * 15;}
  if (down & R1) {brushSize_Y -= increment * 15;}
  if (right & R1) {brushSize_X -= increment * 15;}
  if (left & R1) {brushSize_X += increment * 15;}


  // DISPERSION (d-pad)

  if (up & L1) {dpY += increment * 10;}
  if (down & L1) {dpY -= increment * 10;}
  if (right & L1) {dpX -= increment * 10;}
  if (left & L1) {dpX += increment * 10;}


  // POSITION (d-pad)

  if (up & select2) {y_mean += -increment * 15;}
  if (down & select2) {y_mean -= -increment * 15;}
  if (right & select2) {x_mean += increment * 15;}
  if (left & select2) {x_mean -= increment * 15;}


  // MUTE VALUE: if (R2 & button) {variable = 0}

  if ((R2) & A1) {A1_ctrl = 0;}
  if ((R2) & A2) {A2_ctrl = 0;}
  if ((R2) & A3) {A3_ctrl = 0;}
  if ((R2) & A4) {A4_ctrl = 0;}
  if (R2 & L1) {
    brushSize_X = 350;
    brushSize_Y = 350;
  }
  if (R2 & R1) {
    dpX = 300;
    dpY = 300;
  }
  if (R2 & (select1|select2)) {
    x_mean = width/2;
    y_mean = height/2;
  }


  // RANDOM BEHAVIORS: if (L2) {variable = randomInt(min, max);}
  actionPad_pressed = getActionPad();

  if ((L2 & !actionPad_pressed)) {
    brushSize_Y = randomInt(0, 999);
    brushSize_X = randomInt(0, 999);
    dpY = randomInt(0, 400);
    dpX = randomInt(0, 400);
    A1_ctrl = randomInt(0, 255);
    A2_ctrl = randomInt(0, 255);
    A3_ctrl = randomInt(0, 255);
    A4_ctrl = randomInt(1,255);

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
    brushSize_Y = randomInt(0, 999);
    brushSize_X = randomInt(0, 999);
  }


  // ANALOG MODIFIERS

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
  if (L1 & (abs(analogX) > 0.15)) {dpX += -analogX * 15 * increment;}
  if (L1 & (abs(analogY) > 0.15)) {dpY += -analogY * 15 * increment;}
  if (L1 & (abs(analogU) > 0.15)) {dpX += analogU * 15 * increment;}
  if (L1 & (abs(analogV) > 0.15)) {dpY += -analogV * 15 * increment;}

  // Position
  if((select1|select2) & (abs(analogX) > 0.15)) {x_mean += analogX * 15 * increment;}
  if((select1|select2) & (abs(analogY) > 0.15)) {y_mean += analogY * 15 * increment;}
  if((select1|select2) & (abs(analogU) > 0.15)) {x_mean += analogU * 15 * increment;}
  if((select1|select2) & (abs(analogV) > 0.15)) {y_mean += analogV * 15 * increment;}

  // Map D-Pad to colors when Joystick 2 is activated
  if (left & (abs(joystick2) > 2)) {A1_ctrl += increment * joystick2 / mScalar;}
  if (down & (abs(joystick2) > 2)) {A2_ctrl += increment * joystick2 / mScalar;}
  if (right & (abs(joystick2) > 2)) {A3_ctrl += increment * joystick2 / mScalar;}
  if (up & (abs(joystick2) > 2)) {A4_ctrl += increment * joystick2 / mScalar;}

}
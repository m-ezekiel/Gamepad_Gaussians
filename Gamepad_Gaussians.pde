// File: Gamepad_Gaussians.pde
// Author: m-ezekiel
// PS4-style controller digital painting

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
Configuration config;
ControlDevice gpad;


// VARIABLE DEFINITIONS
float analogX, analogY, analogU, analogV;
boolean A1, A2, A3, A4, M1, M2, L1, L2, R1, R2;
boolean left, right, up, down, select1, select2;


// INITIALIZE PARAMETERS
int xpos = 0; int ypos = 0;
int dpX = 400; int dpY = 400;
int increment = 2;
int scalar = 50;
int mScalar = scalar / 1;
int brushSize_X = 300;
int brushSize_Y = 300;
int fps = 24;
int red, blue, green = 0;
int alpha = 60;

// ASSIGN CONTROL MAPPINGS (variables numbered CCW from left)
int A1_ctrl = red;
int A2_ctrl = green;
int A3_ctrl = blue;
int A4_ctrl = alpha;

public void setup() {
  size(1280, 750);
  background(0);
  noStroke();

  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("full_gamePad");
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
}


public void draw() {

  getUserInput();

  // REFRESH CONTROL VALUES
  red = A1_ctrl;
  green = A2_ctrl;
  blue = A3_ctrl;
  alpha = A4_ctrl;


  // ANALOG TO INTEGER
  int joystick1 = analogToInteger(analogX, analogY, scalar);
  int joystick2 = analogToInteger(analogU, analogV, scalar);


  // GET COORDINATES
  xpos = gaussianInt(dpX, width);
  ypos = gaussianInt(dpY, height);


  // INCREMENTAL BEHAVIORS

  if ((down|left|L1) & A1) {A1_ctrl -= increment;}
  if ((down|left|L1) & A2) {A2_ctrl -= increment;}
  if ((down|left|L1) & A3) {A3_ctrl -= increment;}
  if ((down|left|L1) & A4) {A4_ctrl -= increment;}
  if ((up|right|R1) & A1) {A1_ctrl += increment;}
  if ((up|right|R1) & A2) {A2_ctrl += increment;}
  if ((up|right|R1) & A3) {A3_ctrl += increment;}
  if ((up|right|R1) & A4) {A4_ctrl += increment;}

  if (up & select2) {brushSize_Y += increment * 5;}
  if (down & select2) {brushSize_Y -= increment * 5;}
  if (right & select2) {brushSize_X += increment * 5;}
  if (left & select2) {brushSize_X -= increment * 5;}

  if (R1 & select2) {
    brushSize_Y += increment * 5;
    brushSize_X += increment * 5;
  }
  if (L1 & select2) {
    brushSize_Y -= increment * 5;
    brushSize_X -= increment * 5;
  }

  // DISPERSION BEHAVIORS (d-pad)
  if (up & select1) {dpY += increment * 5;}
  if (down & select1) {dpY -= increment * 5;}
  if (right & select1) {dpX += increment * 5;}
  if (left & select1) {dpX -= increment * 5;}

  if (L1 & select1) {
    dpY += increment * 5;
    dpX += increment * 5;
  }
  if (R1 & select1) {
    dpY -= increment * 5;
    dpX -= increment * 5;
  }

  // RANDOM BEHAVIORS: if (R1 & button) {variable = randomInt(min, max);}

  if ((L2) & A1) {A1_ctrl = randomInt(0, 255);}
  if ((L2) & A2) {A2_ctrl = randomInt(0, 255);}
  if ((L2) & A3) {A3_ctrl = randomInt(0, 255);}
  // Limit the range of opacity in random calls
  if ((L2) & A4) {A4_ctrl = randomInt(0, 127);}

  // New position and size for every random call
  if ((L2)) {
    brushSize_Y = randomInt(0, 1000);
    brushSize_X = randomInt(0, 1000);
  }
  if ((L2)) {
    dpY = randomInt(0, 400);
    dpX = randomInt(0, 400);
  }

  // MUTE VALUE w/R2

  if (R2) {A4_ctrl = 0;}

  if ((R2) & A1) {A1_ctrl = 0;}
  if ((R2) & A2) {A2_ctrl = 0;}
  if ((R2) & A3) {A3_ctrl = 0;}
  if ((R2) & A4) {A4_ctrl = 0;}
  if ((R2) & select1) {
    brushSize_Y = 0;
    brushSize_X = 0;
  }
  if ((R2) & select1) {
    dpY = 0;
    dpX = 0;
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

  if(select1 & (abs(analogX) > 0.1)) {dpX += -analogX * 10 * increment;}
  if(select1 & (abs(analogY) > 0.1)) {dpY += analogY * 10 * increment;}
  if(select1 & (abs(analogU) > 0.2)) {dpX += -analogU * 10 * increment;}
  if(select1 & (abs(analogV) > 0.1)) {dpY += analogV * 10 * increment;}

  if(select2 & (abs(analogX) > 0.1)) {brushSize_X += -analogX * 15 * increment;}
  if(select2 & (abs(analogY) > 0.1)) {brushSize_Y += analogY * 15 * increment;}
  if(select2 & (abs(analogU) > 0.2)) {brushSize_X += analogU * 15 * increment;}
  if(select2 & (abs(analogV) > 0.1)) {brushSize_Y += -analogV * 15 * increment;}


  // GAMEPLAY FUNCTIONS

  if (M1 & M2) {saveImage();}
  if (L2 & R2) {resetBlack();}
  if (up & L2 & R2) {resetWhite();}

  // LIMIT SCALE
  A1_ctrl = limitScale(A1_ctrl, 0, 255);
  A2_ctrl = limitScale(A2_ctrl, 0, 255);
  A3_ctrl = limitScale(A3_ctrl, 0, 255);
  A4_ctrl = limitScale(A4_ctrl, 0, 255);
  dpY = limitScale(dpY, 0, 400);
  dpX = limitScale(dpX, 0, 400);
  brushSize_Y = limitScale(brushSize_Y, 1, 1000);
  brushSize_X = limitScale(brushSize_X, 1, 1000);

  drawShapes();
  drawParameters();
  // saveFrame();

  // DIAGNOSTICS
  println(joystick1, joystick2, analogX, analogY, analogU, analogV);
}
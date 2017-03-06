// File: Gamepad_Gaussians.pde
// Author: m-ezekiel
// PS4-style controller digital painting

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
Configuration config;
ControlDevice gpad;

// KEYLOGGING DEFINITIONS
PrintWriter output;
int [] XYpos_array;
int [] ParamValue_array;
int [] Keypress_array;
float [] Analog_array;

// VARIABLE DEFINITIONS
float analogX, analogY, analogU, analogV;
boolean A1, A2, A3, A4, M1, M2, L1, L2, R1, R2;
boolean left, right, up, down, select1, select2;

boolean imageSaved;

// INITIALIZE PARAMETERS
boolean writeData = true;
boolean actionPad_pressed = false;

int xpos = 0; int ypos = 0;
int dpX = 300; int dpY = 300;
int increment = 2;
int scalar = 50;
int mScalar = scalar / 1;
int brushSize_X = 350;
int brushSize_Y = 350;
int red = 60;
int blue = 60;
int green = 60;
int alpha = 60;

int x_mean;
int y_mean;


float fps = 20;


// ASSIGN CONTROL MAPPINGS (variables numbered CCW from left)
int A1_ctrl = blue;
int A2_ctrl = green;
int A3_ctrl = red;
int A4_ctrl = alpha;

// SETUP
public void setup() {
  size(1280, 800);
  background(0);
  noStroke();

  x_mean = width / 2;
  y_mean = height / 2;

  frameRate(fps);

  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("full_gamePad");
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }

  // Log play data
  if (writeData == true)
    createKeypressFile();
}




// DRAW
public void draw() {

  getUserInput();

  // REFRESH CONTROL VALUES
  blue = A1_ctrl;
  green = A2_ctrl;
  red = A3_ctrl;
  alpha = A4_ctrl;


  // ANALOG TO INTEGER
  int joystick1 = analogToInteger(analogX, analogY, scalar);
  int joystick2 = analogToInteger(analogU, analogV, scalar);


  // GET COORDINATES
  xpos = gaussianInt(dpX, x_mean);
  ypos = gaussianInt(dpY, y_mean);


  // COLOR & OPACITY BEHAVIORS (d-pad)

  if ((down|left) & A1) {A1_ctrl -= increment;}
  if ((down|left) & A2) {A2_ctrl -= increment;}
  if ((down|left) & A3) {A3_ctrl -= increment;}
  if ((down|left) & A4) {A4_ctrl -= increment;}
  if ((up|right) & A1) {A1_ctrl += increment;}
  if ((up|right) & A2) {A2_ctrl += increment;}
  if ((up|right) & A3) {A3_ctrl += increment;}
  if ((up|right) & A4) {A4_ctrl += increment;}


  // SIZE BEHAVIORS (d-pad)

  if (up & R1) {brushSize_Y += increment * 15;}
  if (down & R1) {brushSize_Y -= increment * 15;}
  if (right & R1) {brushSize_X -= increment * 15;}
  if (left & R1) {brushSize_X += increment * 15;}


  // DISPERSION BEHAVIORS (d-pad)

  if (up & L1) {dpY += increment * 10;}
  if (down & L1) {dpY -= increment * 10;}
  if (right & L1) {dpX -= increment * 10;}
  if (left & L1) {dpX += increment * 10;}


  // POSITION BEHAVIORS (d-pad)

  if (up & select2) {y_mean += -increment * 15;}
  if (down & select2) {y_mean -= -increment * 15;}
  if (right & select2) {x_mean += increment * 15;}
  if (left & select2) {x_mean -= increment * 15;}


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


  // LIMIT SCALE

  A1_ctrl = limitScale(A1_ctrl, 0, 255);
  A2_ctrl = limitScale(A2_ctrl, 0, 255);
  A3_ctrl = limitScale(A3_ctrl, 0, 255);
  A4_ctrl = limitScale(A4_ctrl, 0, 255);
  dpY = limitScale(dpY, 0, 400);
  dpX = limitScale(dpX, 0, 400);
  brushSize_Y = limitScale(brushSize_Y, 1, 999);
  brushSize_X = limitScale(brushSize_X, 1, 999);
  xpos = limitScale(xpos, 0, width);
  ypos = limitScale(ypos, 0, height);
  // x_mean = limitScale(x_mean, 0, width);
  // y_mean = limitScale(y_mean, 0, height);


  // SAVE IMAGE
  imageSaved = false;
  if (M1 & M2) {
    imageSaved = saveImage();
  }


  writeData(writeData, joystick1, joystick2);

  togglePreview();
  drawShapes();

  // DIAGNOSTICS
  // println(XYpos_array[0], XYpos_array[1]);

}
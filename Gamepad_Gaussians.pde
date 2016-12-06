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
int xpos = 0; int ypos = 0;
int dpX = 300; int dpY = 300;
int increment = 2;
int scalar = 50;
int mScalar = scalar / 1;
int brushSize_X = 200;
int brushSize_Y = 200;
int red, blue, green = 0;
int alpha = 60;

int x_mean;
int y_mean;


float fps = 30;


// ASSIGN CONTROL MAPPINGS (variables numbered CCW from left)
int A1_ctrl = blue;
int A2_ctrl = green;
int A3_ctrl = red;
int A4_ctrl = alpha;
// int S2_ctrl_X = dpX;
// int S2_ctrl_Y = dpY;

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

  if ((down|left|L1) & A1) {A1_ctrl -= increment;}
  if ((down|left|L1) & A2) {A2_ctrl -= increment;}
  if ((down|left|L1) & A3) {A3_ctrl -= increment;}
  if ((down|left|L1) & A4) {A4_ctrl -= increment;}
  if ((up|right|R1) & A1) {A1_ctrl += increment;}
  if ((up|right|R1) & A2) {A2_ctrl += increment;}
  if ((up|right|R1) & A3) {A3_ctrl += increment;}
  if ((up|right|R1) & A4) {A4_ctrl += increment;}


  // SIZE BEHAVIORS (d-pad)

  if (up & L1) {brushSize_Y += increment * 15;}
  if (down & L1) {brushSize_Y -= increment * 15;}
  if (right & L1) {brushSize_X += increment * 15;}
  if (left & L1) {brushSize_X -= increment * 15;}


  // DISPERSION BEHAVIORS (d-pad)

  if (up & R1) {dpY += increment * 10;}
  if (down & R1) {dpY -= increment * 10;}
  if (right & R1) {dpX -= increment * 10;}
  if (left & R1) {dpX += increment * 10;}


  // POSITION BEHAVIORS (d-pad)

  if (up & select1) {y_mean += -increment * 5;}
  if (down & select1) {y_mean -= -increment * 5;}
  if (right & select1) {x_mean += increment * 5;}
  if (left & select1) {x_mean -= increment * 5;}

  // RANDOM BEHAVIORS: if (L2) {variable = randomInt(min, max);}

  if ((L2)) {
    brushSize_Y = randomInt(0, 999);
    brushSize_X = randomInt(0, 999);
    dpY = randomInt(0, 400);
    dpX = randomInt(0, 400);
    A1_ctrl = randomInt(0, 255);
    A2_ctrl = randomInt(0, 255);
    A3_ctrl = randomInt(0, 255);
    A4_ctrl = randomInt(0, 200);
  }


  // MUTE VALUE: if (R2 & button) {variable = 0}

  if ((R2) & A1) {A1_ctrl = 0;}
  if ((R2) & A2) {A2_ctrl = 0;}
  if ((R2) & A3) {A3_ctrl = 0;}
  if ((R2) & A4) {A4_ctrl = 0;}


  // ANALOG MODIFIERS

  if (A1 & (abs(joystick1) > 2)) {A1_ctrl += increment * joystick1 / mScalar;}
  if (A2 & (abs(joystick1) > 2)) {A2_ctrl += increment * joystick1 / mScalar;}
  if (A3 & (abs(joystick1) > 2)) {A3_ctrl += increment * joystick1 / mScalar;}
  if (A4 & (abs(joystick1) > 2)) {A4_ctrl += increment * joystick1 / mScalar;}

  if (A1 & (abs(joystick2) > 2)) {A1_ctrl += increment * joystick2 / mScalar;}
  if (A2 & (abs(joystick2) > 2)) {A2_ctrl += increment * joystick2 / mScalar;}
  if (A3 & (abs(joystick2) > 2)) {A3_ctrl += increment * joystick2 / mScalar;}
  if (A4 & (abs(joystick2) > 2)) {A4_ctrl += increment * joystick2 / mScalar;}


  if((L1|R1) & (abs(analogX) > 0.15)) {dpX += -analogX * 10 * increment;}
  if((L1|R1) & (abs(analogY) > 0.15)) {dpY += -analogY * 10 * increment;}
  if((L1|R1) & (abs(analogU) > 0.15)) {dpX += analogU * 10 * increment;}
  if((L1|R1) & (abs(analogV) > 0.15)) {dpY += -analogV * 10 * increment;}

  if((select1|select2) & (abs(analogX) > 0.15)) {brushSize_X += -analogX * 15 * increment;}
  if((select1|select2) & (abs(analogY) > 0.15)) {brushSize_Y += -analogY * 15 * increment;}
  if((select1|select2) & (abs(analogU) > 0.15)) {brushSize_X += analogU * 15 * increment;}
  if((select1|select2) & (abs(analogV) > 0.15)) {brushSize_Y += -analogV * 15 * increment;}


  // RESET BACKGROUND

  if (R2 & up) {resetBlack();}
  if (R2 & down) {resetWhite();}


  // LIMIT SCALE

  A1_ctrl = limitScale(A1_ctrl, 0, 255);
  A2_ctrl = limitScale(A2_ctrl, 0, 255);
  A3_ctrl = limitScale(A3_ctrl, 0, 255);
  A4_ctrl = limitScale(A4_ctrl, 0, 255);
  dpY = limitScale(dpY, 0, 400);
  dpX = limitScale(dpX, 0, 400);
  brushSize_Y = limitScale(brushSize_Y, 1, 999);
  brushSize_X = limitScale(brushSize_X, 1, 999);
  x_mean = limitScale(x_mean, 0, width);
  y_mean = limitScale(y_mean, 0, height);


  // SAVE IMAGE
  imageSaved = false;
  if (M1 & M2) {
    imageSaved = saveImage();
  }


  // DRAW SHAPES
  drawShapes();
  drawParameters(width, height);


  // WRITE DATA

  XYpos_array = getXYpos();
  ParamValue_array = getParamValues();
  Keypress_array = getKeypresses();
  Analog_array = getAnalogValues();

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
    joystick1 + "\t" + joystick2 + "\t"

    );

  output.flush(); 


  // DIAGNOSTICS
  println(joystick1, joystick2, analogX, analogY, analogU, analogV);

}
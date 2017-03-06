// File: Gamepad_Gaussians.pde
// Author: Mario Ezekiel H. (@m_ezkiel)
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

int joystick1, joystick2;

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
  joystick1 = analogToInteger(analogX, analogY, scalar);
  joystick2 = analogToInteger(analogU, analogV, scalar);


  // GET COORDINATES
  xpos = gaussianInt(dpX, x_mean);
  ypos = gaussianInt(dpY, y_mean);

  // Call conditional statements for control behaviors
  behaviorSettings();


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


  writeData(writeData);

  togglePreview();
  drawShapes();

  // DIAGNOSTICS
  // println(XYpos_array[0], XYpos_array[1]);

}
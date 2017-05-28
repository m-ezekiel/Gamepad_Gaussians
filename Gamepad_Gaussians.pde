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
boolean writeData = false;
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

float fps = 30;


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
  refreshControlValues();

  joystick1 = analogToInteger(analogX, analogY, scalar);
  joystick2 = analogToInteger(analogU, analogV, scalar);

  println("joystick1: "+joystick1);
  println("joystick2: "+joystick2);

  // Get random gaussian distributed XY coordinates
  xpos = gaussianInt(dpX, x_mean);
  ypos = gaussianInt(dpY, y_mean);

  // Order matters here-- should verify that data writes correctly
  defineControlBehaviors();
  defineResetBehaviors();

  constrainParameters();
  togglePreview();

  drawShapes();

  writeData(writeData);

}
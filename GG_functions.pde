/*
File: GG_functions.pde
Author: m-ezekiel
Desc.: Function script for Gamepad Gaussians
*/


// -----------------
// Analog to integer
// -----------------

public int analogToInteger(float x, float y, int k) {
  int value = floor((x - y) * k);
  return(value);
}



// --------------------
// Create keypress file
// --------------------

public void createKeypressFile() {
  // Get datetime information
  int [] datetime = new int[6];
  datetime[0] = year();
  datetime[1] = month();
  datetime[2] = day();
  datetime[3] = hour();
  datetime[4] = minute();
  datetime[5] = second();

  // Define keylogging output file naming convention
  output = createWriter("data/" + join(nf(datetime, 0), "-") + "_gamepadKeys.txt");
  // Create headers on output file
  output.println("millis" + "\t" + "A1" + "\t" + "A2" + "\t" + "A3" + "\t" + "A4" + "\t" + "L1" + "\t" + "R1" + "\t" + "L2" + "\t" + "R2" + "\t" + "S1" + "\t" + "S2" + "\t" + "M1" + "\t" + "M2" + "\t" + "up" + "\t" + "dn" + "\t" + "lf" + "\t" + "rt");
}



// ---------------
// Draw parameters
// ---------------

public void drawParameters() {
  int wB = 150;
  int wH = 50;
  int wX = width - wB;
  int wY = 0;
  int gap = 28;
  fill(0, 155);
  rect(wX, wY, wB, wH);

  int centerPointX = wX + (wB/2);
  int centerPointY = wY + (wH/2);

  String dX = str(dpX/4);
  String dY = str(dpY/4);

  String a = str(alpha);
  String r = str(red);
  String g = str(green);
  String b = str(blue);

  textAlign(CENTER, TOP);
  textSize(11);

  fill(200);
  text(a, centerPointX + 4 + (1*gap), centerPointY - 20);      // alpha
  fill(0, 255, 0, 255);
  text(g, centerPointX + 4 + (1*gap), centerPointY + 10);      // green
  fill(255, 0, 0, 255);
  text(r, centerPointX + 8, centerPointY - 5);                 // red
  fill(0, 200, 255, 255);
  text(b, centerPointX + (2*gap), centerPointY - 5);           // blue


  stroke(150);
  fill(red, green, blue, 127);

  // X-DISPERSION
  line(centerPointX - (1.5*gap) - dpX/20, centerPointY, centerPointX - (1.5*gap) + dpX/20, centerPointY);

  ellipse(centerPointX - (1.5*gap) - dpX/20, centerPointY, brushSize_X/50, brushSize_Y/50);
  ellipse(centerPointX - (1.5*gap) + dpX/20, centerPointY, brushSize_X/50, brushSize_Y/50);

  // Y-DISPERSION
  line(centerPointX - (1.5*gap), centerPointY - dpY/30, centerPointX - (1.5*gap), centerPointY + dpY/30);

  ellipse(centerPointX - (1.5*gap), centerPointY - dpY/30, brushSize_X/50, brushSize_Y/50);
  ellipse(centerPointX - (1.5*gap), centerPointY + dpY/30, brushSize_X/50, brushSize_Y/50);

  // Colored ellipse
  noStroke();  
  fill(red, green, blue, alpha*3);
  ellipse(centerPointX + 4 + (1*gap), centerPointY + 1, 10, 10);

}



// -----------
// Draw shapes
// -----------

public void drawShapes() {
  fill(red, green, blue, alpha);
  ellipse(xpos, ypos, analogX * brushSize_X, analogY * brushSize_Y);
  ellipse(xpos, ypos, analogU * brushSize_X, analogV * brushSize_Y);
}



// ----------------------------------
// Limit values to variable scale a:b
// ----------------------------------

public int limitScale(int x, int min, int max) {
  if (x > max)
    x = max;
  if (x < min)
    x = min;
  return(x);
}



// ----------------
// Gaussian integer
// ----------------

public int gaussianInt(int dispersion, int dimension) {

  float rGauss = randomGaussian();  // Random number from Z~(0,1)
  float mean = dimension / 2;
  int value = floor((rGauss * dispersion) + mean);

  return(value);
}



// --------------
// Get keypresses
// --------------

public int [] getKPs() {
  int [] kp_array = new int[16];  

  kp_array[0] = int(A1);
  kp_array[1] = int(A2);
  kp_array[2] = int(A3);
  kp_array[3] = int(A4);

  kp_array[4] = int(L1);
  kp_array[5] = int(R1);
  kp_array[6] = int(L2);
  kp_array[7] = int(R2);

  kp_array[8] = int(select1);
  kp_array[9] = int(select2);

  kp_array[10] = int(M1);
  kp_array[11] = int(M2);

  kp_array[12] = int(up);
  kp_array[13] = int(down);
  kp_array[14] = int(left);
  kp_array[15] = int(right);

  return(kp_array);
}



// --------------
// Get user input
// --------------

public void getUserInput() {
  select1 = gpad.getButton("start").pressed();
  select2 = gpad.getButton("select").pressed();
  
  // Analog controller to position vars
  analogX =  gpad.getSlider("analogXL").getValue();
  analogY =  gpad.getSlider("analogYL").getValue();
  analogU =  gpad.getSlider("analogXR").getValue();
  analogV =  gpad.getSlider("analogYR").getValue();
  // Analog stick button presses
  M1 = gpad.getButton("M1").pressed();
  M2 = gpad.getButton("M2").pressed();
  
  // Action buttons
  A1 = gpad.getButton("a").pressed();
  A2 = gpad.getButton("b").pressed();
  A3 = gpad.getButton("x").pressed();
  A4 = gpad.getButton("y").pressed();

  // LR triggers
  L1 = gpad.getButton("L1").pressed();
  L2 = gpad.getButton("L2").pressed();
  R1 = gpad.getButton("R1").pressed();
  R2 = gpad.getButton("R2").pressed();
  
  // D-Pad values
  left = gpad.getHat("dPad").left();
  right = gpad.getHat("dPad").right();
  up = gpad.getHat("dPad").up();
  down = gpad.getHat("dPad").down();
}




// -----------
// Mute colors
// -----------

public void muteAlpha() {
  A4_ctrl = 0;
  increment = 2;
}



// --------------
// Random integer
// --------------

public int randomInt(int a, int b) {
  int value = floor(random(a, b));
  return(value);
}



// -----
// Reset
// -----

public void resetBlack() {
  // A4_ctrl = 60;
  dpX = 300; dpY = 300;
  brushSize_X = 200; brushSize_Y = 200;
  background(0);
}
public void resetWhite() {
  dpX = 300; dpY = 300;
  brushSize_X = 200; brushSize_Y = 200;
  background(255);
}



// ----------
// Save image
// ----------

public void saveImage() {
  // Get datetime information
  int [] datetime = new int[6];
  datetime[0] = year();
  datetime[1] = month();
  datetime[2] = day();
  datetime[3] = hour();
  datetime[4] = minute();
  datetime[5] = second();

  // Create new datestamped file in the sketch directory
  save("IMG_exports/gamePad_sketch_" + join(nf(datetime, 0), "-") + ".png");  
}





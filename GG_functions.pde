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

  int [] datetime = dateTime();

  // Define keylogging output file naming convention
  output = createWriter("data/" + join(nf(datetime, 0), "-") + "_gamepadKeys.txt");

  // Create headers on output file
  output.println(

    // Temporal data
    "millis" + "\t" + "xpos" + "\t" + "ypos" + "\t" + 

    // Size and dispersion {sX, sY, dpX, dpY}
    "sX" + "\t" + "sY" + "\t" + "dpX" + "\t" + "dpY" + "\t" + 

    // Color values {R, G, B, A}
    "red" + "\t" + "green" + "\t" + "blue" + "\t" + "opacity" + "\t" + 

    // Keypress booleans {action, LR, select/M*, d-pad}
    "A1" + "\t" + "A2" + "\t" + "A3" + "\t" + "A4" + "\t" + 
    "L1" + "\t" + "R1" + "\t" + "L2" + "\t" + "R2" + "\t" + 
    "S1" + "\t" + "S2" + "\t" + "M1" + "\t" + "M2" + "\t" + 
    "up" + "\t" + "down" + "\t" + "left" + "\t" + "right" + "\t" + 

    // Analog axis values
     "anlgX" + "\t" + "anlgY" + "\t" + "anlgU" + "\t" + "anlgV" + "\t" +

    // Joystick integers
    "joy1_int" + "\t" + "joy2_int"
     );
}



// ---------
// Date time
// ---------

public int [] dateTime() {
  int [] datetime = new int[6];
  datetime[0] = year();
  datetime[1] = month();
  datetime[2] = day();
  datetime[3] = hour();
  datetime[4] = minute();
  datetime[5] = second();

  return(datetime);
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


  // IMAGE SAVED
  if (imageSaved == true) {
    fill(255);
    text("SAVED", centerPointX, centerPointY - 20); 
  }

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




// -----------------
// Get analog values
// -----------------

public float [] getAnalogValues() {
  float [] AV_array = new float[4];  

  AV_array[0] = analogX;
  AV_array[1] = analogY;
  AV_array[2] = analogU;
  AV_array[3] = analogV;

  return(AV_array);
}


// ---------------------------------------
// Get parameter values (color, disp, size)
// ----------------------------------------

public int [] getParamValues() {
  int [] DV_array = new int[8];  

  DV_array[0] = red;
  DV_array[1] = green;
  DV_array[2] = blue;
  DV_array[3] = alpha;

  DV_array[4] = dpX;
  DV_array[5] = dpY;
  DV_array[6] = brushSize_X;
  DV_array[7] = brushSize_Y;

  return(DV_array);
}


// --------------
// Get keypresses
// --------------

public int [] getKeypresses() {
  int [] kp_array = new int[26];  

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



// ------------------------
// Get position coordinates
// ------------------------

public int [] getXYpos() {
  int [] XYpos = new int[2];

  XYpos[0] = xpos;
  XYpos[1] = ypos;

  return(XYpos);
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
  background(0);
}
public void resetWhite() {
  background(255);
}



// ----------
// Save image
// ----------

public boolean saveImage() {
  int [] datetime = dateTime();
  save("IMG_exports/gamePad_sketch_" + join(nf(datetime, 0), "-") + ".png");  
  return(true);
}






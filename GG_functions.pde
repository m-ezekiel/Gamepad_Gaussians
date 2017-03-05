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
// Toggle preview
// ---------------

public void togglePreview() {
  int w = width;
  int h = height;

  // Outer window
  int owB = w/7; // 160 (default is 8)
  float owH = owB/2.5; // 60
  int owX = width - owB - 300; // Minus 300 for the video demo, 0 otherwise
  int owY = 0;
  int gap = w/45; // 28
  // Inner window
  float iwB = owB/3.125;
  float iwH = iwB * 0.625;
  // Centerpoints
  float owCX = owX + (owB/2);
  float owCY = owY + (owH/2);
  float iwCX = owX + owB/12 + iwB/2;
  float iwCY = owY + owH/6 + iwH/2;  
  // Parameter values
  String opacity = str(alpha);
  String rd = str(red);
  String grn = str(green);
  String blu = str(blue);
  String x_mn = str(x_mean);
  String y_mn = str(y_mean);
  String dX = str(dpX/4);
  String dY = str(dpY/4);

  int brushScale = w/45;

  // Head Up Display (outer window)
  fill(0, 155);
  rect(owX, owY, owB, owH);


  // Prototype for inner window preview
  stroke(100);
  rect(owX + owB/12, owY + owH/6, iwB, iwH);
  noStroke();


  stroke(150);
  fill(red, green, blue, 127);

  // X-DISPERSION
  ellipse(iwCX - dpX/20 + (x_mean - width/2)/25, iwCY + (y_mean - height/2)/25, 
    brushSize_X/brushScale, brushSize_Y/brushScale);

  ellipse(iwCX + dpX/20 + (x_mean - width/2)/25, iwCY + (y_mean - height/2)/25, 
    brushSize_X/brushScale, brushSize_Y/brushScale);

  // Y-DISPERSION
  ellipse(iwCX + (x_mean - width/2)/25, iwCY - dpY/30 + (y_mean - height/2)/25, 
    brushSize_X/brushScale, brushSize_Y/brushScale);
  ellipse(iwCX + (x_mean - width/2)/25, iwCY + dpY/30 + (y_mean - height/2)/25, 
    brushSize_X/brushScale, brushSize_Y/brushScale);

  // Brush pigment colored ellipse
  noStroke();
  fill(red, green, blue, alpha*3);
  ellipse(owCX + gap + gap/11, owCY - gap/11, gap/2, gap/2);


  // Display color values according to controller position
  textAlign(CENTER, TOP);
  textSize(owB/15);
  // Color Values
  fill(200);
  text(opacity, owCX + gap + gap/11, owCY - gap/1.1);

  fill(0, 255, 0, 255);
  text(grn, owCX + gap + gap/11, owCY + gap/3);

  fill(0, 200, 255, 255);
  text(blu, owCX + gap/5, owCY - gap/3);

  fill(255, 0, 0, 255);
  text(rd, owCX + (2*gap), owCY - gap/3);

  // Position Values
  fill(180);
  text(x_mn, iwCX - gap/2, owCY + gap/2);
  text(y_mn, iwCX + gap/2, owCY + gap/2);


  // IMAGE SAVED
  if (imageSaved == true) {
    fill(255);
    text("SAVED", owCX, owCY - 20); 
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

public int gaussianInt(int dispersion, int mean) {

  float rGauss = randomGaussian();  // Random number from Z~(0,1)
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



// -----------------
// Get direction pad
// -----------------

public boolean getDPad() {
  boolean value = false;

  // If buttons are pressed then value is false
  if (left | right | up | down)
    value = true;

  return(value);
}


// --------------
// Get action pad
// --------------

public boolean getActionPad() {
  boolean value = false;

  // If buttons are pressed then value is false
  if (A1 | A2 | A3 | A4 | R1 | L1 | up | down | left | right | select1 | select2)
    value = true;

  return(value);
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
public void resetColor() {
  background(red, green, blue, alpha);
}
public void resetInverse() {
  background(255 - red, 255 - green, 255 - blue, 255 - alpha);
}



// ----------
// Save image
// ----------

public boolean saveImage() {
  int [] datetime = dateTime();
  save("IMG_exports/gamePad_sketch_" + join(nf(datetime, 0), "-") + ".png");  
  return(true);
}



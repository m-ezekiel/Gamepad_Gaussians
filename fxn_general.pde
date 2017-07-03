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
// 1. GENERAL FUNCTIONS //
// -------------------- //


public int analogToInteger(float x, float y, int k) {
  int value = floor((x - y) * k);
  return(value);
}


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


public void drawShapes() {
  fill(red, green, blue, alpha);
  ellipse(xpos, ypos, analogX * brushSize_X, analogY * brushSize_Y);
  ellipse(xpos, ypos, analogU * brushSize_X, analogV * brushSize_Y);
}


public int limitScale(int x, int min, int max) {
  if (x > max)
    x = max;
  if (x < min)
    x = min;
  return(x);
}


public int gaussianInt(int dispersion, int mean) {
  float rGauss = randomGaussian();  // Random number from Z~(0,1)
  int value = floor((rGauss * dispersion) + mean);
  return(value);
}


public float [] getAnalogValues() {
  float [] AV_array = new float[4];  
  AV_array[0] = analogX;
  AV_array[1] = analogY;
  AV_array[2] = analogU;
  AV_array[3] = analogV;
  return(AV_array);
}


public int [] getParamValues() {
  // Get values (color, disp, size)
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


public int [] getXYpos() {
  int [] XYpos = new int[2];
  XYpos[0] = xpos;
  XYpos[1] = ypos;
  return(XYpos);
}


public boolean getDPad() {
  // Get direction pad
  boolean value = false;

  // If buttons are pressed then value is false
  if (left | right | up | down)
    value = true;

  return(value);
}


public boolean getActionPad() {
  boolean value = false;

  // If buttons are pressed then value is false
  if (A1 | A2 | A3 | A4 | R1 | R2 | L1 | up | down | left | right)
    value = true;

  return(value);
}


public int randomInt(int a, int b) {
  int value = floor(random(a, b));
  return(value);
}


public void resetBlack() {background(0);}
public void resetWhite() {background(255);}
public void resetColor() {background(red, green, blue, alpha);}
public void resetInverse() {background(255 - red, 255 - green, 255 - blue, 255 - alpha);}


public void refreshControlValues() {
  red = A1_ctrl;
  green = A2_ctrl;
  blue = A3_ctrl;
  alpha = A4_ctrl;  
}


public boolean saveImage() {
  int [] datetime = dateTime();
  save("IMG_exports/" + join(nf(datetime, 2), "-") + "_gamePad_sketch" + ".png");
  save("gameplay_data/" + join(nf(datetime, 2), "-") + "_gamePad_sketch" + ".png");  
  return(true);
}



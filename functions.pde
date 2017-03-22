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
  if (A1 | A2 | A3 | A4 | R1 | R2 | L1 | up | down | left | right | select1 | select2)
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
  save("IMG_exports/gamePad_sketch_" + join(nf(datetime, 2), "-") + ".png");
  save("gameplay_data/gamePad_sketch_" + join(nf(datetime, 2), "-") + ".png");  
  return(true);
}





// ----------------- //
// 2. GET USER INPUT //
// ----------------- //


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





// ----------------------- //
// 3. CREATE KEYPRESS FILE //
// ----------------------- //


public void createKeypressFile() {

  int [] datetime = dateTime();

  // Define keylogging output file naming convention
  output = createWriter("gameplay_data/" + join(nf(datetime, 2), "-") + "_gamepadKeys.txt");

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

    // Focal points {x_mean, y_mean}
    "x_mean" + "\t" + "y_mean" + "\t" +

    // Joystick integers
    "joy1_int" + "\t" + "joy2_int"
     );
}





// ------------- //
// 4. WRITE DATA //
// ------------- //


public void writeData(boolean writeData) {

  if (writeData == true) {

    XYpos_array = getXYpos();
    ParamValue_array = getParamValues();
    Keypress_array = getKeypresses();
    Analog_array = getAnalogValues();

    // if thumb keys above threshold...
    if (abs(analogX) > .15 | abs(analogY) > .15 | abs(analogU) > .15 | abs(analogV) > .15 | actionPad_pressed == true) {

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

        // Focal points: {x_mean, y_mean}
        x_mean + "\t" + y_mean + "\t" +

        // Joystick integers
        joystick1 + "\t" + joystick2

        );

      output.flush(); 
    }
  }   
}





// -------------------- //
// 5. BEHAVIOR SETTINGS //
// -------------------- //


public void defineControlBehaviors() {

  // Color & opacity (d-pad)
  if ((down|left) & A1) {A1_ctrl -= increment;}
  if ((down|left) & A2) {A2_ctrl -= increment;}
  if ((down|left) & A3) {A3_ctrl -= increment;}
  if ((down|left) & A4) {A4_ctrl -= increment;}
  if ((up|right) & A1) {A1_ctrl += increment;}
  if ((up|right) & A2) {A2_ctrl += increment;}
  if ((up|right) & A3) {A3_ctrl += increment;}
  if ((up|right) & A4) {A4_ctrl += increment;}


  // Size (d-pad)
  if (up & R1) {brushSize_Y += increment * 15;}
  if (down & R1) {brushSize_Y -= increment * 15;}
  if (right & R1) {brushSize_X -= increment * 15;}
  if (left & R1) {brushSize_X += increment * 15;}


  // Dispersion (d-pad)
  if (up & L1) {dpY += increment * 10;}
  if (down & L1) {dpY -= increment * 10;}
  if (right & L1) {dpX -= increment * 10;}
  if (left & L1) {dpX += increment * 10;}


  // Position (d-pad)
  if (up & R2) {y_mean += -increment * 15;}
  if (down & R2) {y_mean -= -increment * 15;}
  if (right & R2) {x_mean += increment * 15;}
  if (left & R2) {x_mean -= increment * 15;}


  // Mute values: if (mute & button) {variable = 0}
  if ((select1) & A1) {A1_ctrl = 0;}
  if ((select1) & A2) {A2_ctrl = 0;}
  if ((select1) & A3) {A3_ctrl = 0;}
  if ((select1) & A4) {A4_ctrl = 0;}
  if (select1 & L1) {
    brushSize_X = 350;
    brushSize_Y = 350;
  }
  if (select1 & R1) {
    dpX = 300;
    dpY = 300;
  }
  if (select1 & R2) {
    x_mean = width/2;
    y_mean = height/2;
  }


  // RANDOM BEHAVIORS: if (L2) {variable = randomInt(min, max);}
  actionPad_pressed = getActionPad();

  if ((L2 & !actionPad_pressed)) {
    brushSize_Y = randomInt(0, 500);
    brushSize_X = randomInt(0, 500);
    dpY = randomInt(0, 400);
    dpX = randomInt(0, 400);
    A1_ctrl = randomInt(0, 255);
    A2_ctrl = randomInt(0, 255);
    A3_ctrl = randomInt(0, 255);
    // A4_ctrl = randomInt(1, 255);

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
    brushSize_Y = randomInt(0, 500);
    brushSize_X = randomInt(0, 500);
  }
  if (L2 & R2) {
    x_mean = randomInt(0, width);
    y_mean = randomInt(0, height);
  }

  // Color & opacity (analog)
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
  if(R2 & (abs(analogX) > 0.15)) {x_mean += analogX * 15 * increment;}
  if(R2 & (abs(analogY) > 0.15)) {y_mean += analogY * 15 * increment;}
  if(R2 & (abs(analogU) > 0.15)) {x_mean += analogU * 15 * increment;}
  if(R2 & (abs(analogV) > 0.15)) {y_mean += analogV * 15 * increment;}

  // Map D-Pad to colors when Joystick 2 is activated
  if (left & (abs(joystick2) > 2)) {A1_ctrl += increment * joystick2 / mScalar;}
  if (down & (abs(joystick2) > 2)) {A2_ctrl += increment * joystick2 / mScalar;}
  if (right & (abs(joystick2) > 2)) {A3_ctrl += increment * joystick2 / mScalar;}
  if (up & (abs(joystick2) > 2)) {A4_ctrl += increment * joystick2 / mScalar;}

  // Save image
  // if (L2 & R2)
  //   saveImage();

}





// --------------------
// 6. RESET SETTINGS
// --------------------


public void defineResetBehaviors() {

  // Reset background only
  if (select1) {
    // int bgColor = randomInt(0, 2);
    // if (bgColor == 0)
    //   resetBlack();
    // if (bgColor > 0)
    //   resetWhite();

    resetBlack();

    if (writeData == true) {
      output.close();
      createKeypressFile();
    }
  }

  // Reset background and set all params to default
  if (select2) {
    saveImage();
  }
}





// ----------------------- //
// 7. CONSTRAIN PARAMETERS //
// ----------------------- //


public void constrainParameters() {
  A1_ctrl = limitScale(A1_ctrl, 0, 255);
  A2_ctrl = limitScale(A2_ctrl, 0, 255);
  A3_ctrl = limitScale(A3_ctrl, 0, 255);
  A4_ctrl = limitScale(A4_ctrl, 0, 255);
  dpY = limitScale(dpY, 0, height/2);
  dpX = limitScale(dpX, 0, height/2);
  brushSize_Y = limitScale(brushSize_Y, 1, height);
  brushSize_X = limitScale(brushSize_X, 1, height);
  xpos = limitScale(xpos, 0, width);
  ypos = limitScale(ypos, 0, height);
  x_mean = limitScale(x_mean, 0, width);
  y_mean = limitScale(y_mean, 0, height);
}





// ----------------- //
// 8. TOGGLE PREVIEW //
// ----------------- //


public void togglePreview() {
  int w = width;
  int h = height;

  // Outer window
  int owB = w/7; // 160 (default is 8)
  float owH = owB/2.5; // 60
  int owX = width - owB - 0; // Minus 300 for the video demo, 0 otherwise
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
  String A4_val = str(alpha);
  String A3_val = str(blue);
  String A2_val = str(green);
  String A1_val = str(red);
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
  fill(red, green, blue, alpha*2);

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
  // Add inverse color stroke to offset low value colors
  stroke(255-red, 255-green, 255-blue, 60);
  fill(red, green, blue, 255);
  ellipse(owCX + gap + gap/11, owCY - gap/11, gap/2, gap/2);

  noStroke();

  // Display color values according to controller position
  textAlign(CENTER, TOP);
  textSize(owB/15);
  // Color Values
  fill(200);
  text(A4_val, owCX + gap + gap/11, owCY - gap/1.1);

  fill(0, 255, 0, 255);
  text(A2_val, owCX + gap + gap/11, owCY + gap/3);

  fill(255, 0, 0, 255);
  text(A1_val, owCX + gap/5, owCY - gap/3);

  fill(0, 200, 255, 255);
  text(A3_val, owCX + (2*gap), owCY - gap/3);

  // Position Values
  // fill(180);
  // text(x_mn, iwCX - gap/2, owCY + gap/2);
  // text(y_mn, iwCX + gap/2, owCY + gap/2);

  // Display save text
  if (select2) {
    fill(255);
    text("IMG Saved", iwCX + gap/10, owCY + gap/2);
  }
}

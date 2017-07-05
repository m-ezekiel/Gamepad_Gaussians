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

// ----------------- //
// 8. TOGGLE PREVIEW //
// ----------------- //


public void togglePreview() {
  int w = width;
  int h = height;

  // Outer window
  int owB = w/7; // 160 (default is 8)
  float owH = owB/2.4; // 60
  int owX = width - owB - 0; // Minus 300 for the video demo, 0 otherwise
  int owY = 0;
  int gap = w/45; // 28
  // Inner window
  float iwB = owB/3.125;
  float iwH = iwB * 0.625;
  // Centerpoints
  float owCX = owX + (owB/2);
  float owCY = owY + (owH/2);
  float iwCX = owX + owB/6 + iwB/2;
  float iwCY = owY + owH/6 + iwH/2;  
  // Parameter values
  String A4_val = str(alpha);
  String A3_val = str(blue);
  String A2_val = str(green);
  String A1_val = str(red);
  String x_mn = str(x_mean - width/2);
  String y_mn = str(-(y_mean - height/2));
  String dX = str(dpX/4);
  String dY = str(dpY/4);

  int brushScale = w/45;

  // Head Up Display (outer window)
  fill(0, 155);
  rect(owX, owY, owB, owH);


  // Prototype for inner window preview
  stroke(100);
  rect(owX + owB/6, owY + owH/6, iwB, iwH);
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
  ellipse(owCX + gap + gap/1.7, owCY - gap/11, gap/2, gap/2);

  noStroke();

  // Display color values according to controller position
  textAlign(CENTER, TOP);
  textSize(owB/15);
  // Color Values
  fill(200);
  text(A4_val, owCX + gap + gap/1.7, owCY - gap/1.1);

  fill(0, 255, 0, 255);
  text(A2_val, owCX + gap + gap/1.7, owCY + gap/3);

  fill(255, 0, 0, 255);
  text(A1_val, owCX + gap/1.5, owCY - gap/3);

  fill(0, 200, 255, 255);
  text(A3_val, owCX + (2*gap) + gap/2, owCY - gap/3);

  // Position Values
  textSize(owB/16);
  fill(140);
  text(x_mn, iwCX - gap/2, owCY + gap/2);
  text(y_mn, iwCX + gap/2, owCY + gap/2);

  // Display save text
  if (select1 & select2) {
    fill(255);
    text("IMG Saved", iwCX + gap/10, owCY + gap/2);
  }
}
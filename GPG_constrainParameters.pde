/*
File: GPG_constrainParameters.pde
Author: Mario Ezekiel H. (@m_ezkiel)
Desc.: Function script for Gamepad Gaussians
*/


// --------------------
// Constrain parameters
// --------------------

public void constrainParameters() {

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

}
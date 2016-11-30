// --------------
// Get keypresses
// --------------

public int [] getKPs() {
  int [] kp_array = new int[4];  

  kp_array[0] = int(A1);
  kp_array[1] = int(A2);
  kp_array[2] = int(A3);
  kp_array[3] = int(A4);

  return(kp_array);
}
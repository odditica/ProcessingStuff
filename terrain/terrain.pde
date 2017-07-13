float cellW, cellH;
int cellCount = 32;
float camRot = PI * 2 + PI / 6;
float planeWOff, planeHOff;
PShader shader;
int frame = 0;
float res = 0;
float sizeZ;

void setup(){
  System.gc();
  size(560, 560, P3D);
  cellW = width / cellCount * 6;
  cellH = height / cellCount * 6;
  planeWOff = max(0, cellW * cellCount - width);
  planeHOff = max(0, cellW * cellCount - height);
  shader = loadShader("shader.glsl");
}

void draw(){
  background(#000000);
  camRot += .01;
  camera(width / 2 + cos(camRot) * 4000, height / 2 - sin(camRot) * 4000, -1400, width / 2, height / 2, 0, 0, 0, 1);
  ortho(-width * 4.55, width * 4.55, -height * 4.55, height * 4.55);
  blendMode(ADD);
  colorMode(HSB);
  
  for (int yy = 0; yy < cellCount; yy++){
    for (int xx = 0; xx < cellCount; xx++){
      pushMatrix();
      float _xx = xx - cellCount / 2;
      float _yy = yy - cellCount / 2;
      sizeZ = (sin((_xx * .14) * (_yy * .14) + camRot * 4 + .25 * cos(_xx * .14 + _yy * .14 + camRot)) * .8 + 1) * 400 + 100;
      fill((xx + yy + (camRot * (PI / 4)) *  255) % 255, 100, sizeZ * .025); 
      stroke((xx + yy + (camRot * (PI / 4)) *  255) % 255, 200, 255 * .2);
      strokeWeight(sizeZ * .05);
      translate(xx * cellW + cellW / 2 - planeWOff / 2, yy * cellH + cellH / 2 - planeHOff / 2, -100 - sizeZ / 2 + 500);
      box(cellW, cellH, cellW + sizeZ);
      popMatrix();
    }
  }
  
  blendMode(NORMAL);
  filter(shader);
  shader.set("time", camRot * 6);
}
// [  Pondering     ] 
// [   by Blokatt   ] 
// [ 31/08/2017 2AM ] 

PGraphics wave;
PShader frag;
int gridSize = 32;
float grid[][];
float time, timeLimit;
int frame = 0;
int frameLimit = 100;

void setup(){
  size(720, 720, P2D);
  smooth(5);
  frameRate(60);
  grid = new float[gridSize + 2][gridSize + 2]; 
  time = 0;
  wave = createGraphics(width, height);
  frag = loadShader("frag.glsl");
  frag.set("image", wave);
  frag.set("resolution", width, height);
}

void draw(){
  time = (time + .01) % 1;
  wave.ellipseMode(CENTER);
  wave.beginDraw();
  wave.background(255);
  wave.fill(0);
  //wave.noFill();
  float gridBlockSize = (float)width / (float)gridSize; 
  for (int yy = 0; yy < gridSize + 2; yy++){
    for (int xx = 0; xx < gridSize + 2; xx++){
      grid[xx][yy] = sin(dist((float)xx, (float)yy, (float)gridSize / 2, (float)gridSize / 2) + time * TAU) / 2 + .5;
      float origX = (float)xx * gridBlockSize;
      float origY = (float)yy * gridBlockSize;
      float size = (gridBlockSize * .5) * grid[xx][yy];
      //wave.strokeWeight(1 + grid[xx][yy]);
      wave.noStroke();
      float vecX = origX - width / 2;
      float vecY = origY - height / 2;
      float len = sqrt(pow(vecX, 2) + pow(vecY, 2));
      vecX /= len;
      vecY /= len;
      if (xx == gridSize / 2 && yy == gridSize / 2){
        vecX = 0;
        vecY = 0;
      }
      wave.ellipse(origX + vecX * size, origY + vecY * size, size, size);
    }
  }
  fill(0);
  wave.endDraw();
  
  float margin = width * .05;
  float tm =  sin(time * TAU) - QUARTER_PI;
  float c0X = width - margin  + cos(tm) * 40;
  float c0Y = margin          - sin(tm) * 40;
  float c1X = margin          + cos(tm + HALF_PI) * 40;
  float c1Y = margin          - sin(tm + HALF_PI) * 40;
  float c2X = margin          + cos(tm + PI) * 40;
  float c2Y = height - margin - sin(tm + PI) * 40;   
  float c3X = width - margin  + cos(tm + PI + HALF_PI) * 40;
  float c3Y = height - margin - sin(tm + PI + HALF_PI) * 40;
  
  //too lazy to do proper vector rotation, leave me alone, it's 1:33 AM
  
  float c4X = width - margin  + cos(tm + PI) * 40;
  float c4Y = margin          - sin(tm + PI) * 40;
  float c5X = margin          + cos(tm + HALF_PI + PI) * 40;
  float c5Y = margin          - sin(tm + HALF_PI + PI) * 40;
  float c6X = margin          + cos(tm + PI + PI) * 40;
  float c6Y = height - margin - sin(tm + PI + PI) * 40;   
  float c7X = width - margin  + cos(tm + PI + HALF_PI + PI) * 40;
  float c7Y = height - margin - sin(tm + PI + HALF_PI + PI) * 40;

  image(wave, 0, 0);
  
  shader(frag);
  for (float i = 0; i <= 1.6; i += .2){
    float offset = width / 2 * (1. - (i + time * .2));
    pushMatrix();
    translate(offset, offset);
   
    scale(i + time * .2);
    
    beginShape(TRIANGLE_STRIP);
    vertex(c4X, c4Y);
    vertex(c0X, c0Y);
    vertex(c5X, c5Y);
    vertex(c1X, c1Y);
    vertex(c6X, c6Y);
    vertex(c2X, c2Y);
    vertex(c7X, c7Y);
    vertex(c3X, c3Y);
    vertex(c4X, c4Y);
    vertex(c0X, c0Y);
    endShape();
    popMatrix();
  }
  rect(0, 0, width, margin);
  rect(0, 0, margin, height);
  rect(0, height - margin, width, margin);
  rect(width - margin, 0, margin, height);
  resetShader();
  noFill();
  
  if (frame < frameLimit)  save("i_(" + str(frame) + ").png");
  frame += 1;
}
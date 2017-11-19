/* [  n = 10         ] 
   [     by Blokatt  ] 
   [ 19/11/2017 11PM ] */ 

PImage bFront;
PImage bBack;
PImage bOverlay;
PShader frag;
PGraphics preRender;
PGraphics trailRender;
float wind;
float time;
float fullTime;

void drawTree(float x, float y, int n, float windOff, float alpha){
  wind = sin(time * TAU + windOff) * .2;
  drawBranch(n, x, y, PI / 2, windOff, alpha);
}

void drawBranch(int n, float x, float y, float angle, float windOff, float alpha){
  if (n <= 0) return;
  preRender.stroke(0, alpha * n / 10);
  angle += wind / (float)(n+1);
  float len = n * (float)width * .0122;
  float x2 = x + cos(angle) * len;
  float y2 = y - sin(angle) * len;
  preRender.fill(0, alpha * n / 10);
  preRender.ellipse(x2, y2, n, n);
  preRender.line(x, y, x2, y2);
  drawBranch(n - 1, x2, y2, angle - PI / 5, windOff, alpha);
  drawBranch(n - 1, x2, y2, angle + PI / 5, windOff, alpha);
}

void setup(){
  size(750, 750, P3D);
  smooth(5);
  time = 0;
  bFront = loadImage("front.png");
  bBack = loadImage("back.png");
  bOverlay = loadImage("overlay.png");
  preRender = createGraphics(width, height, P3D);
  trailRender = createGraphics(width, height, P3D);
  frag = loadShader("frag.glsl");
}

void draw(){
  fullTime += .0075;
  time = fullTime % 1;
  preRender.beginDraw();
  preRender.beginCamera();
  preRender.camera();
  float scl = 1.02 + sin(time * (TAU * 2)) * .005 + random(-.002, .002);
  preRender.scale(scl);
  preRender.translate(-(width / 2) * (scl - 1.0), -(height / 2) * (scl - 1.0));
  
  float angle = time * TAU;
  float len = sin(time * (TAU * 5));
  
  preRender.translate(sin(angle) * len * 2, -cos(angle) * len * 2);
  preRender.endCamera();  

  preRender.pushMatrix();
  preRender.translate(0, 0, -2);
  preRender.pushMatrix();
  preRender.tint(255, 255, 255);
  preRender.image(bBack, 0, 0, width, height);
  preRender.noTint();
  preRender.popMatrix();
  preRender.popMatrix();
  
  preRender.strokeWeight(3);
  preRender.fill(0);

  preRender.pushMatrix();
  preRender.translate(width * .475, height * .701, -1);
  preRender.rotate(-.1);
  preRender.pushMatrix();
  drawTree(0, 0, 10, .1, 255);
  preRender.popMatrix();
  preRender.popMatrix();

  preRender.pushMatrix();
  preRender.translate(width * .3, height * .69, -1);
  preRender.rotate(-.1);
  preRender.scale(.6);
  preRender.pushMatrix();
  drawTree(0, 0, 10, .5, 100);
  preRender.noTint();
  preRender.popMatrix();
  preRender.popMatrix();

  preRender.pushMatrix();
  preRender.translate(width * .92, height * .66, -1);
  preRender.rotate(-.1);
  preRender.scale(.4);
  preRender.pushMatrix();
  drawTree(0, 0, 10, .75, 45);
  preRender.noTint();
  preRender.popMatrix();
  preRender.popMatrix();
  
  preRender.tint(255, 255, 255, 255);
  preRender.image(bFront, 0, 0, width, height);
  preRender.noTint();
  preRender.endDraw();
  
  trailRender.beginDraw();
  trailRender.tint(255, 255, 255, 80);
  trailRender.image(preRender, 0, 0);
  trailRender.noTint();
  trailRender.endDraw();
  noTint();
  
  shader(frag);
  image(trailRender, 0, 0);
  resetShader();

  blendMode(MULTIPLY);
  image(bOverlay, 0, 0);
  noTint();
  blendMode(SUBTRACT);
  noStroke();
  fill(80, 80, 50);
  float margin = width * .02;
  float tm =  time * TAU;
  float c0X = width;
  float c0Y = 0;
  float c1X = 0;
  float c1Y = 0;
  float c2X = 0;
  float c2Y = height;   
  float c3X = width;
  float c3Y = height;
  float c4X = width - margin  + cos(tm + PI) *  5;
  float c4Y = margin          - sin(tm + PI) *  5;
  float c5X = margin          + cos(tm + HALF_PI + PI) *  5;
  float c5Y = margin          - sin(tm + HALF_PI + PI) *  5;
  float c6X = margin          + cos(tm + PI + PI) *  5;
  float c6Y = height - margin - sin(tm + PI + PI) *  5;   
  float c7X = width - margin  + cos(tm + PI + HALF_PI + PI) *  5;
  float c7Y = height - margin - sin(tm + PI + HALF_PI + PI) *  5;
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
  blendMode(ADD);
  fill(20 + sin(time * TAU) * 5, 20 + sin(time * TAU + PI) * 5, 0);
  rect(0, 0, width, height);
  blendMode(NORMAL);
}
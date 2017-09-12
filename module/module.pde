/*
    •    Module    •
    •  by Blokatt  •
    •  12/09/2017  •
    •              •
    •  blokatt.net •
    •   @blokatt   •
*/

PGraphics image;
PShader frag;
float time = 0;
int frame = 0;
void setup(){
  size(750, 750, P3D);
  frag = loadShader("frag.glsl");
  image = createGraphics(width, height, P3D);
  frag.set("tex", image);
  frag.set("resolution", width, height);
}

void draw(){
  background(0);
  float len = sin(TAU * time);
  image.beginDraw();
  image.pointLight(255, 255, 255, width / 2, height / 2, 500);
  image.background(0);

  image.strokeWeight(0);
  image.pushMatrix();
  image.translate(width / 2, height / 2);
  image.scale(1);
  image.pushMatrix();
  image.rotateX((time) * TAU);
  image.rotateY((time) * TAU);
  image.rotateZ((time) * TAU);
 
  image.box(220, 220, 220);
  image.pushMatrix();
  image.translate(200 * len, 0, 0);
  image.box(150, 150, 150);
  image.popMatrix();
  
  image.pushMatrix();
  image.translate(-200 * len, 0, 0);
  image.box(150, 150, 150);
  image.popMatrix();
  
  image.pushMatrix();
  image.translate(0, 200 * len, 0);
  image.box(150, 150, 150);
  image.popMatrix();
  
  image.pushMatrix();
  image.translate(0, -200 * len, 0);
  image.box(150, 150, 150);
  image.popMatrix();
  
  image.pushMatrix();
  image.translate(0, 0, 200 * len);
  image.box(150, 150, 150);
  image.popMatrix();
  
  image.pushMatrix();
  image.translate(0, 0, -200 * len);
  image.box(150, 150, 150);
  image.popMatrix();
  
  image.popMatrix();
  image.popMatrix();
  image.endDraw();
  
  shader(frag);
  image(image, 0, 0);
  resetShader();

  time = (time + .002) % 1;
}
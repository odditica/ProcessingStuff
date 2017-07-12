float w, h, rotX = 0;
PShader shader;

void setup(){
  size(560, 560, P3D);
  w = min(height, width) * .9;
  h = min(width, height) * .9; 
  smooth(4);
  shader = loadShader("shader.glsl");
}

void draw(){
  tint(#ffffff, 0.5);
  background(0);   
  colorMode(HSB, 255);
  pointLight((rotX * 40) % 255, 128, 12.5, width / 2 + cos(rotX * 1.2) * 30, height / 2 - sin(rotX * 1.2) * 30, 0);
  rotX += .05;
  blendMode(ADD);

  translate(width / 2, height / 2, -1000);
  
  for (float i = 50; i < 50 * 30.5; i+= 10){
    pushMatrix();
    rotateX(rotX + i * .0025);
    rotateZ(rotX + PI / 2 + i * .0025);
    sphereDetail(1 + floor(i * .005));
    sphere(i);
    popMatrix();
  }
  
  filter(shader); 
  shader.set("resolution", width, height);
}
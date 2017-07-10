//Array of Reflections
//By Blokatt (@blokatt, /u/blokatt, blokatt.net)
//10/07/2017 

float timeNoWrap = -QUARTER_PI / 2;
float time = -QUARTER_PI / 2;
float angTo = 0;
float angTween = 0;
PShader skyShader;
PImage skyTexture;

void setup(){
  size(750, 750, P3D);
  skyShader = loadShader("frag.glsl", "vert.glsl");
  skyTexture = loadImage("texture.png");
}

void draw(){
  float m = pow(2, 1 + floor(.25 + timeNoWrap * 2));
  float num = m * m;
  float s = sqrt(num);
  float margin = width / 2 - ((width / s) / 2);
  
  angTo = QUARTER_PI * floor(timeNoWrap * 4);
  angTween += (angTo - angTween) * .28;
  
  ortho(-margin, margin, -margin, margin);
  timeNoWrap += .005;
  time = timeNoWrap % 1;
  background(0);
  skyShader.set("skyTex", skyTexture);
  shader(skyShader);
  noStroke();
  
  for (float i = 0; i < num; i++){
    pushMatrix(); 
    translate(width / s * (i % (sqrt(num))) + width / s / 2, height / s * (floor(i / (sqrt(num)))) + width / s / 2, 100);
    float ang = QUARTER_PI + angTween;
    rotateX(ang);
    rotateY(ang);
    pushMatrix();
    box(width / s);
    popMatrix();
    popMatrix();
  }
  resetShader();
}
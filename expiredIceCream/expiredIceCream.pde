float time;
PGraphics mainImage;
PShader invert;

void setup(){
  size(750, 750, P2D);
  time = 0;
  mainImage = createGraphics(width, height, P2D);
  invert = loadShader("frag.glsl");
  invert.set("image", mainImage);
  invert.set("resolution", width, height);
  smooth(8);
}

void ellipseDetail(PGraphics p, float x, float y, float radius, float detail, float rot){
  p.beginShape();
  for (int i = 0; i <= detail; i++){
    p.vertex(x + cos((TAU / detail) * i + rot) * radius, y - sin((TAU / detail) * i + rot) * radius);
    p.vertex(x + cos((TAU / detail) * i + rot) * (radius * .9), y - sin((TAU / detail) * i + rot) * (radius * .9));
  }
  p.endShape();
}

void draw(){
  time = (time + .005) % 1;
  float n = 125;
  float gap = (width / n);
  mainImage.beginDraw();
  mainImage.background(0);
  mainImage.noStroke();
  for (int i = int(n); i > -2; i--){
    float radius = gap * i + (gap * 2) * time;
    mainImage.colorMode(HSB);
    if (i % 2 == 0){
      mainImage.fill(0);
      mainImage.fill((radius / float(width)) * 255, 255, 50);
    }else{
      mainImage.fill((radius / float(width)) * 255, 50, 255);
    }
    ellipseDetail(mainImage, width / 2F, height / 2F, radius, 10F, (radius / (500F + sin(time * TAU) * 1F) * 2));
  }
  mainImage.stroke(0);
  mainImage.fill(255);
  mainImage.endDraw();
  image(mainImage, 0, 0);
  shader(invert);
  noStroke();
  fill(0, 255, 50);
  ellipse(width / 2, height / 2, width / 94, width / 94);
  resetShader();
}
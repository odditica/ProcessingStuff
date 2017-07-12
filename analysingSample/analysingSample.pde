float time;
PGraphics pg;
String[] lines = 
{"XXXXXXX-XXXXXXX-XXXXXXXXXXX-XXXXXXX-XXXXXXXXX",
 "XX-XXXXXXXXX-XXXXXXX-XXX-XXXXXXX-XXXXX-XXXXXX",
 "XXXXXXXXX-XXXXXXX-XXXXXXXXX-XXXXXXXX-XXXX-XXX",
 "XXX-XXXXXXXXXXX-XXXXXXX-XXXXXXXXXXX-XXXXXXX-X",
 "XX-XXX-XXXX-XXXXXX-XXXXXXXXXXX-XXXXXX-XXXXXXX",
 "XXXX-XXXX-XXXX-XXXXXX-XXXX-XXXXXXXX-XXXXXXX-X",
 "XXXXXX-XXXX-XXXXXXXXXXXXXXXX-XXX-XXXXX-X-XXXX",
 "XXXXXXXXX-XXXXXXX-XXXXX-XXXXXXXXX-XX-XXXXXXXX",
 "XXX-XXXXXXXXX-XXXXXX-XXX-XXXXX-XXXXXXX-XXXXXX",
 "XXXXXXXXXXX-XXXX-XXXXX-XXXXXXXXXXX-XXXXXXXX-X",
 "XXXXX-XX-XXXXXXXXXX-XXXXXXX-XXXX-XXXX-XX-XXXX",
 "X-XXXXXXXXXXXX-XXXXXXX-XXXXXXXXXXXX-XXXXXXX-X",
 "XXXX-XX-XXX-XXXX-XX-XXXX-XXXXX-XXXXXX-XXXXXXX",
 "X-XXXXXXX-XXXXXXXXXXXXX-XXXXXXX-XX-XXXXX-XXXX"};
float lineOffset = 1;
float lineOffsetL = 0;
float timeNoWrap;
void setup(){
  size(520, 520, P3D);  
  smooth(8);
  frameRate(60);
  pg = createGraphics(width, height, P3D);
  
}

void cylinder(PGraphics p, float r, float h){
  //bottom
  p.beginShape(TRIANGLE_FAN);
  p.vertex(0, 0, 0);
  for (float i = 0; i <= TAU + TAU / 20; i += TAU / 20){
    p.vertex(cos(i) * r, -sin(i) * r, 0); 
  }
  p.endShape();
  
  p.beginShape(TRIANGLE_STRIP);
  p.vertex(0, 0, h);
  for (float i = 0; i <= TAU + TAU / 20; i += TAU / 20){
    p.vertex(cos(i) * r, -sin(i) * r, 0); 
    p.vertex(cos(i) * r, -sin(i) * r, h); 
  }
  p.endShape();
  
  //top
  p.beginShape(TRIANGLE_FAN);
  p.vertex(0, 0, h);
  for (float i = 0; i <= TAU + TAU / 20; i += TAU / 20){
    p.vertex(cos(i) * r, -sin(i) * r, h); 
  }
  p.endShape();
}

void strand(PGraphics p, float l){
  p.sphereDetail(10);
  p.pushMatrix();
  p.translate(-l / 2, 0, 0);
  p.sphere(15);
  p.popMatrix();
  p.pushMatrix();
  p.translate(l / 2, 0, 0);
  p.pushMatrix();
  p.rotateY(PI / 2);
  cylinder(p, 5, -(l / 2 + 15 * 2));
  p.popMatrix();
  p.popMatrix();
  p.translate(l / 2, 0, 0);
  p.pushMatrix();
  p.sphere(15);
  p.popMatrix();
}

void ellipseDetail(PGraphics p, float x, float y, float radius, float detail, float rot){
  p.beginShape();
  for (int i = 0; i <= detail; i++){
    p.vertex(x + cos((TAU / detail) * i + rot) * radius, y - sin((TAU / detail) * i + rot) * radius);
  }
  p.endShape();
}

float snapTimer = 0;
void draw(){
  timeNoWrap += .01; 
  time = timeNoWrap % 1;
  
  fill(#CD3F42, 255); //trail
  rect(0, 0, width, height);
  lineOffset += ((floor(((lines.length) / 2) * timeNoWrap)) - lineOffset) * .5;

  pg.beginDraw();
  pg.clear();
  pg.noStroke();
  pg.beginCamera();
  pg.camera();
  pg.endCamera();
  pg.fill(255);
  
  pg.clip(width / 25, height / 25, width - width / 25 * 2, height - height / 25 * 2);
  for (float i = 0; i < 800; i += 40){
    pg.pushMatrix();
    float y = height - i + ((time) * 40) % 40;
    pg.translate(width / 2 + width / 3.25, y, 0);
    pg.rotateY(y / 80 + TAU * time);
    strand(pg, 80);
    pg.popMatrix();  
  }
  pg.clip(0, 0, width, height);
  
  pg.pushMatrix();
  //pg.translate(width / 30, height - height / 30, 0);
  pg.rectMode(CORNER);
  for (float i = 0; i < 8; i++){
    pg.rect(width / 25 + width / 25 * (i * 2), height - height / 25, 20, -max(0, 140 + sin((TAU * time) + (i * i * 40)) * 120 + cos(i * i * 25) * (20 * sin(i))));
  }
  pg.popMatrix();  
  pg.pushMatrix();  
  
  pg.translate(width / 2, height / 2);  
  pg.pushMatrix();

  pg.rotateY(time * (TAU / 10));

  pg.sphereDetail(10);
  pg.fill(0, 0);
  pg.stroke(0, 20);
  pg.strokeWeight(10);
  pg.sphere(1000);
  pg.noStroke();
  pg.popMatrix();  
  pg.popMatrix(); 
  


  for (float i = 0; i < 300; i += 10){
    pg.fill(0, random(50, 255));
    pg.rect(width / 25 + i, height / 25, 10, 10);    
    pg.fill(0, random(50, 255));
    pg.rect(width / 25 + i, height / 25 + 20, 10, 10);    
  }
  pg.fill(1);
  
  pg.clip(0, height / 25 + 40, width, 160);
  for (float j = 0; j < lines.length + 3; j++){
    int lineI = (int(j) + int(lineOffset)) % lines.length;
    for (float i = 0; i < lines[lineI].length(); i ++){
      if (lines[lineI].charAt(int(i)) == 'X')
      pg.rect(width / 25 + i * 5, height / 25 + 30 + j * 10 - (lineOffset * 10) % 10, 5, 5);    
    }
  }
 
  pg.clip(0, 0, width, height);
  
  pg.noFill();
  pg.stroke(0);
  pg.strokeWeight(3);
  for (int i = 0; i < 4; i++){
    ellipseDetail(pg, width / 1.96 + (i % 2) * width / 13, height / 6.9 + width / 13 * floor(i / 2), width / 35, 3 + i, TAU * (time * (i + 1)));
  }
  pg.strokeWeight(2);
  for (int i = 0; i < 4; i++){
    ellipseDetail(pg, width / 1.96 + (i % 2) * width / 13, height / 6.9 + width / 13 * floor(i / 2), width / 80, 3 + i, -(TAU * time));
  }
  pg.strokeWeight(1.8);
  
  pg.beginShape();
  for (int i = 0; i < 20; i++){
    pg.vertex(width / 2.075 + ((width / (6.9999 + random(-.2, .2))) / 20) * i, height / 3.15 + tan((i / 5)) * width / 50 + random(width / 120));  
  }
  pg.endShape();
  pg.noStroke();
  for (float i = 0; i < 140; i += 5){
    pg.fill(0, random(20, 80));
    pg.rect(width / 2.075 + i / 2, height / 3.15, 2, 2);     
  }
  
  for (float i = 0; i < 60 + sin(TAU * time) * 30; i += 15){
    pg.fill(0, random(100, 200));
    pg.rect(width / 2.075 + i / 2.5, height / 2.635, 3, 3);     
  }
  for (float i = 0; i < 80 + sin(TAU * time * 4) * 20 + sin(TAU * time * 2) * 20; i += 15){
    pg.fill(0, random(100, 200));
    pg.rect(width / 2.075 + i / 2.5, height / 2.565, 3, 3);     
  }
  
  pg.fill(0, random(100, 200));
  pg.ellipse(width / 1.65, height / 2.5778, 8, 8);
  pg.fill(0, random(100, 150));
  pg.ellipse(width / 1.7, height / 2.5778, 5, 5);  
  pg.fill(1);

  float margin = 35;
  pg.fill(0, 50);
  pg.rect(0, 0, width, height / margin);
  pg.rect(0, height / margin, width / margin, height - height / margin * 2);
  pg.rect(height - height / margin, height / margin, width / margin, height - height / margin * 2);
  pg.rect(0, height - height / margin, width, height / margin);
  pg.fill(1);
  
  pg.strokeWeight(2);
  pg.stroke(0, 10);

  for (float i = 0; i < height; i += 5){
    pg.line(0, i, width, i);
  }
  pg.stroke(1);
  pg.endDraw();
  
  tint(0, 0, 0, 20);
  image(pg, 4, 0);
  tint(0);
  image(pg, 0, 0);
}
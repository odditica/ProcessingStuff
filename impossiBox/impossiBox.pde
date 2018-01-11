/* [ Impossi-box     ] 
   [      by Blokatt ] 
   [ 11/01/2018 1AM  ] */ 

import java.util.Arrays; 
import java.util.Comparator; 
import java.util.Collections; 

final static float BOX_S = 100;
final static int BALL_N = 140;
final static int BALL_RADIUS = 20;
final static int SEED = 7159;
final static float SPEED = .5;

PGraphics ballBuffer;
PGraphics cubeMaskBuffer;
PGraphics postBuffer;
PGraphics postTrailBuffer;

PShader shdMetaball;
PShader shdPost;

float time, fullTime, randX, randY, shakeFactor, fade, camX, camY, camShake = 0;
float boxS = BOX_S;

Ball[] balls;

float cosTween(float a, float b, float v){
  return a + ((cos(PI + PI * max(min(v, 1), 0)) / 2) + .5) * (b - a);
}

void setup(){
  smooth(5);
  size(750, 750, P3D);
  randomSeed(SEED);
  ballBuffer = createGraphics(width, height, P3D);
  cubeMaskBuffer = createGraphics(width, height, P3D);
  postBuffer = createGraphics(width, height, P3D);
  postTrailBuffer = createGraphics(width, height, P3D);
  
  shdMetaball = loadShader("metaball.glsl");
  shdMetaball.set("resolution", width, height);
  
  shdPost = loadShader("post.glsl");
  
  balls = new Ball[BALL_N];  
  
  for (int i = 0; i < BALL_N; i++){
    balls[i] = new Ball();
  }
 
  for (Ball b : balls){
    b.x = (float)round(random(-BOX_S, BOX_S));
    b.y = (float)round(random(-BOX_S, BOX_S));
    b.z = (float)round(random(-BOX_S, BOX_S));
    b.startX = b.x;
    b.startY = b.y;
    b.startZ = b.z;
  }
}

void draw(){
  beginCamera();
  camera();
  translate(0, 0, 280);
  endCamera();
  
  if (time >= .99){
    for (Ball b : balls){
      b.x = b.startX;
      b.y = b.startY;
      b.z = b.startZ;
    }  
    time = 0;
  }

  if ((fullTime % 2) > .82  && (fullTime % 2) < 1.8){
    fade += .015;
    
    shakeFactor += (BOX_S - boxS) * .0005;
    
    if ((fullTime % 2) > (1.8 - .01 * SPEED)){
      boxS -= 2;
    }else{
      boxS = cosTween(BOX_S, 60, fade);
    }
    
    if ((fullTime % 2) > 1.78) camShake = 1;
    
  }else{
    camShake += (0 - camShake) * .05;
    fade = 0;
    boxS += (BOX_S - boxS) * .3;
    shakeFactor += (0 - shakeFactor) * .05;
  }
  float shake = sin((TAU * 10 * shakeFactor) * time);
  randX = -sin((TAU * 1 * shakeFactor) * time) * shake * shakeFactor;
  randY =  cos((TAU * 1 * shakeFactor) * time) * shake * shakeFactor;
  
  camX =  sin(2 * fullTime * TAU + PI) * sin(TAU * 5 * fullTime) * camShake * 10;
  camY =  cos(2 * fullTime * TAU + PI) * sin(TAU * 5 * fullTime) * camShake * 50;
  
  fullTime += .01 * SPEED;
  time += .01 * SPEED;

  noFill();
  for (Ball b : balls){
    b.move();
  }
  
  float shakeRot =  + sin(TAU * fullTime * 2 * shakeFactor) * shakeFactor * .01;
  
  cubeMaskBuffer.beginDraw();  
  cubeMaskBuffer.beginCamera();
  cubeMaskBuffer.camera();
  cubeMaskBuffer.translate(0, 0, 280);
  cubeMaskBuffer.endCamera();
  cubeMaskBuffer.background(255);
  cubeMaskBuffer.fill(0);
  cubeMaskBuffer.pushMatrix();
  cubeMaskBuffer.translate(width / 2 + randX, height / 2 + randY, 0);
  cubeMaskBuffer.rotateY(sin(TAU * (fullTime % 1)) + shakeRot);
  cubeMaskBuffer.rotateX(shakeRot);
  cubeMaskBuffer.rotateZ(-shakeRot);
  cubeMaskBuffer.stroke(0);
  cubeMaskBuffer.box(boxS * 2.1 + BALL_RADIUS - 2);
  cubeMaskBuffer.popMatrix();
  cubeMaskBuffer.endDraw();
  
  ballBuffer.beginDraw();
  
  ballBuffer.blendMode(SUBTRACT);
  ballBuffer.fill(70 + sin(-.33 + (TAU / 2) * fullTime) * 60);
  ballBuffer.pushMatrix();
  ballBuffer.translate(0, 0, -280);
  ballBuffer.rect(0, 0, width, height);
  ballBuffer.popMatrix();
  ballBuffer.fill(255);
  ballBuffer.blendMode(NORMAL);
  
  ballBuffer.beginCamera();
  ballBuffer.camera();
  ballBuffer.translate(0, 0, 280);
  ballBuffer.endCamera();

  ballBuffer.directionalLight(140, 140, 140, 0, 0, -1);
  ballBuffer.lightFalloff(0, 0, 0);
  ballBuffer.pushMatrix();
  
  ballBuffer.translate(width / 2 + randX, height / 2 + randY);
  ballBuffer.strokeWeight(10);
  ballBuffer.stroke(255);
  ballBuffer.noFill();
  ballBuffer.rotateY(sin(TAU * (fullTime % 1)) + shakeRot);
  ballBuffer.rotateX(shakeRot);
  ballBuffer.rotateZ(-shakeRot);
  ballBuffer.box(boxS * 2.1 + BALL_RADIUS - 5);
  ballBuffer.sphereDetail(10);
  ballBuffer.fill(50);
  ballBuffer.noStroke();
  
  ballBuffer.blendMode(ADD);
  ballBuffer.pushMatrix();
 
  Arrays.sort(balls, new Comparator()
    { 
      public int compare( Object o1, Object o2 ) 
      { 
        if (((Ball)o1).z > ((Ball)o2).z){
          return 1;
        }else{
          if (((Ball)o1).z < ((Ball)o2).z) return -1;
          return 0;
        }
     
      }  
    }
    );

  for (Ball b : balls){
    b.draw();
  }
  
  ballBuffer.popMatrix();
  ballBuffer.popMatrix();
  ballBuffer.blendMode(NORMAL);
  ballBuffer.endDraw();

  pushMatrix();
  translate(width / 2, height / 2);
  rotateY(sin(TAU * time));
  stroke(255);
  strokeWeight(2);
  popMatrix();
  beginCamera();
  camera();
  endCamera();
  
  postBuffer.beginDraw();
  postBuffer.blendMode(NORMAL);
  postBuffer.shader(shdMetaball);
  postBuffer.image(ballBuffer, camX, camY);
  postBuffer.resetShader();
  postBuffer.blendMode(SUBTRACT);
  postBuffer.image(cubeMaskBuffer, camX, camY);
  postBuffer.blendMode(NORMAL);
  postBuffer.endDraw();
  
  postTrailBuffer.beginDraw();
  postTrailBuffer.shader(shdPost);
  postTrailBuffer.image(postBuffer, camX, camY);
  postTrailBuffer.resetShader();
  postTrailBuffer.endDraw();
  
  blendMode(MULTIPLY);
  fill(100);
  rect(0, 0, width, height);
  blendMode(SCREEN);
  image(postTrailBuffer, 0, 0);
  blendMode(NORMAL);
}
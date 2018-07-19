/* 
   [ It's terminal. ] 
   [   by Blokatt   ] 
   [    19/07/2018  ] 
   
   Model (badly) made in Blender.
   Font: http://laemeur.sdf.org/fonts/
   Gradient: http://paulbourke.net/dataformats/asciiart/
*/ 

PShape objSkull;
PFont fntDOS;
PGraphics fntMap;
PGraphics post;
PShader shdASCII;
float time = .25;
static String strGradient = "MQBW#pqmdbX8@O$UZwkh0a&xCfY%LonzucJjvItr}{li?1][<>)(*!;|/\\:,\"^.\'` ";
static int fntMapCharN = strGradient.length();
static int fntMapWidth = fntMapCharN * 9;
static int fntMapHeight = 16;
static int charWidth = fntMapWidth / fntMapCharN;

void setup(){  
  smooth(8);
  size(512, 512, P3D);  
    
  objSkull = loadShape("skull2.obj");  
  fntDOS = loadFont("font.vlw");
  
  // Prepare gradient
  textureWrap(REPEAT); //Essential
  fntMap = createGraphics(fntMapWidth, fntMapHeight);    
  fntMap.beginDraw();
  fntMap.textAlign(LEFT, TOP);
  fntMap.clear();
  fntMap.textFont(fntDOS, 16);  
  fntMap.text(strGradient, 1, 2);
  fntMap.endDraw();
  
  // Prepare shader
  post = createGraphics(width, height, P3D);
  shdASCII = loadShader("frag.glsl");    
  shdASCII.set("charSizePix", 9.0, (float)fntMapHeight);
  shdASCII.set("resolution", (float)width, (float)height, (float)fntMapWidth, (float)fntMapHeight);
  shdASCII.set("charTexture", fntMap);
  shdASCII.set("screenTexture", post);  
}

void draw(){
  time = (time + .0025) % 1.;
 
  // Skull
  post.beginDraw();
  post.clear();  
  post.lightFalloff(.00001, -.0002,  0.000002);
  post.pointLight(120, 80, 180, width / 2, height / 2, 800);
  post.ortho(-width / 2, width / 2, -height / 2, height / 2, -2500, 2500);
  post.pushMatrix();  
  post.translate(width / 2., height / 2.1 + 3);
  post.pushMatrix();  
  post.scale(height / 6.);
  post.rotateY(TAU * time);  
  post.rotateZ(PI);
  post.pointLight(2, 1, 3, 3.2, 0, -1.25);
  post.pointLight(2, 1, 3, 3.2, 0, 1.25);  
  post.pushMatrix();    
  post.shape(objSkull);
  post.popMatrix();
  post.popMatrix();
  post.popMatrix();
  post.endDraw();
      
  // Post
  background(0);  
  shader(shdASCII);
  shdASCII.set("time", time);
  clip(2, 2, width - 4, height - 4);
  rect(0, 0, width, height);  
  resetShader();  
}

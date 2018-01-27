/* 
   [ Basic Ordered     ]
   [    Dithering Demo ] 
   [        by Blokatt ] 
   [    27/01/2018     ] 
   
   See the shader.
   
   PICO-8 (default) palette
   by Lexaloffle Games.
*/ 

PImage imgLenna;
PImage imgPalette;
PShader shdDither;
float time;

void setup(){
  size(512, 512, P3D);
  imgLenna = loadImage("lena.png");
  imgPalette = loadImage("palette0.png");
  shdDither = loadShader("post.glsl");
  shdDither.set("smpPalette", imgPalette);
  shdDither.set("paletteSize", 4F, 4F);
}

void draw(){
  time += .5;
  shdDither.set("time", time);
  background(0);
  shader(shdDither);
  image(imgLenna, 0, 0);
  resetShader();
}
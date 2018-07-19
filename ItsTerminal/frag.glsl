// Written by Blokatt (19/07/18)
// @blokatt | blokatt.net
// WARNING: QUESTIONABLE MATHS AHEAD
// Seriously, I wrote most of this half-awake.

#define TAU  6.28318530718
uniform sampler2D charTexture;
uniform sampler2D screenTexture;
uniform vec2 charSizePix;
uniform vec4 resolution;
uniform float time;

vec2 mapSize = vec2((resolution.x / resolution.z) / resolution.x, (resolution.y / resolution.w) / resolution.y);
vec2 cellResolution = vec2(resolution.x / (charSizePix.x + 1.), resolution.y / charSizePix.y);
vec2 cellSpace = vec2(charSizePix.xy / resolution.xy);
float levels = resolution.z / charSizePix.x - 1.;
float t = TAU * time;
int dither[64];

float dither8x8(vec2 position, float col) {	
	int X = int(mod(position.x, 8.0));
	int Y = int(mod(position.y, 8.0));

	//8x8 Bayer dither "matrix" (hehe)
	dither[0]  = 0;
	dither[1]  = 32;
	dither[2]  = 8;
	dither[3]  = 40;
	dither[4]  = 2;
	dither[5]  = 34;
	dither[6]  = 10;
	dither[7]  = 42;
	dither[8]  = 48;
	dither[9]  = 16;
	dither[10] = 56;
	dither[11] = 24;
	dither[12] = 50;
	dither[13] = 18;
	dither[14] = 58;
	dither[15] = 26;
	dither[16] = 12;
	dither[17] = 44;
	dither[18] = 4;
	dither[19] = 36;
	dither[20] = 14;
	dither[21] = 46;
	dither[22] = 6;
	dither[23] = 38;
	dither[24] = 60;
	dither[25] = 28;
	dither[26] = 52;
	dither[27] = 20;
	dither[28] = 62;
	dither[29] = 30;
	dither[30] = 54;
	dither[31] = 22;
	dither[32] = 3;
	dither[33] = 35;
	dither[34] = 11;
	dither[35] = 43;
	dither[36] = 1;
	dither[37] = 33;
	dither[38] = 9;
	dither[39] = 41;
	dither[40] = 51;
	dither[41] = 19;
	dither[42] = 59;
	dither[43] = 27;
	dither[44] = 49;
	dither[45] = 17;
	dither[46] = 57;
	dither[47] = 25;
	dither[48] = 15;
	dither[49] = 47;
	dither[50] = 7;
	dither[51] = 39;
	dither[52] = 13;
	dither[53] = 45;
	dither[54] = 5;
	dither[55] = 37;
	dither[56] = 63;
	dither[57] = 31;
	dither[58] = 55;
	dither[59] = 23;
	dither[60] = 61;
	dither[61] = 29;
	dither[62] = 53;
	dither[63] = 21;	

	return max(0., col - step((dither[8 * Y + X] - 1.) / 64., col) / levels);
}

float getOffset(float v){
	return floor(levels * (1. - v));	
}

float brightness(in vec4 col){	
	return (col.r * 0.3 + col.g * 0.59 + col.b * 0.11);
}

vec2 cellFragmentPosition(float offset, vec2 pos) {	
	return vec2((charSizePix.x * getOffset(offset) + mod(pos.x, charSizePix.x + 1.)) * mapSize.x, pos.y * mapSize.y);
}

vec4 ascii(in vec2 position){		
	vec2 cell = vec2(floor(position.x / (charSizePix.x + 1.)), floor(position.y / charSizePix.y));	
	float offsetPlasma = floor(levels / 2. + sin(length(vec2((cell.xy / cellResolution.xy) - .5)) * 35. - t * 2.) * levels * .442);		
	vec4 screenFrag = texture2D(screenTexture, vec2(cell.x / cellResolution.x + cellSpace.x * .5, 1.0 - cell.y / cellResolution.y - cellSpace.y * .5));	
	////
	vec4 plasmaFrag = texture2D(charTexture, cellFragmentPosition(dither8x8(cell, offsetPlasma), position)) *
											 vec4(.15, .12, 1., .3) * pow(1.275, 1. + (1. - offsetPlasma / levels)) + vec4(.35, .4, 1.8, .1) *
											 step(1., cell.x) * step(1., cell.y) * (1. - step(cellResolution.x - 2., cell.x)) * (1. - step(cellResolution.y - 1., cell.y));	

	vec4 skullFrag = texture2D(charTexture, cellFragmentPosition(dither8x8(cell, brightness(screenFrag)), position)) *
											screenFrag * 1.2 * vec4(1., 1.1, 1.4, 1.) + vec4(.42, .24, .8, .5);

	return mix(plasmaFrag, skullFrag, 1. - step(0., -screenFrag.r));
} 

void main(){
	gl_FragColor = ascii(vec2(gl_FragCoord.x, (resolution.y - gl_FragCoord.y)));
}


uniform sampler2D texture;
varying vec4 vertTexCoord;
int dither[64];

float posterise(float value, float level){
	return floor(value * level) / level;
}
vec3 nearestColour(vec3 col){
	col.rgb = ((col.rgb - .5) * 1.5 + .5);
    return vec3(posterise(col.r, floor(2. + col.r)), posterise(col.g, floor(2.5 + col.g * .2)), posterise(col.b, floor(3. + col.b)));
	//return outCol;
}

vec4 dither8x8(vec2 position, vec4 col) {
	vec3 preCol = vec3(col.rgb);
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
	
	float match = float(dither[8 * Y + X]) / 64.;
	preCol.rgb += match / 3.;
	return vec4(nearestColour(preCol), col.a);
	//return vec4(nearestColour(preCol), 1.);
}

void main(){
	vec4 col = texture2D(texture, vertTexCoord.xy);
	
	gl_FragColor = mix(col, dither8x8(vec2(gl_FragCoord.x, gl_FragCoord.y), col), .35);
}
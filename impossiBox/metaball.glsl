uniform sampler2D texture;
uniform vec2 resolution;
varying vec4 vertTexCoord;

vec2 pixel = vec2(1. / resolution.x,  1. / resolution.y);

float luma(vec4 colour){
	return 0.2126 * colour.r + 0.7152 * colour.g + 0.0722 * colour.b;
}

vec4 metaball(vec2 coord){
	float blur = 2.0;

	vec4 col = vec4(0.0);
	col += texture2D(texture, vec2(coord.x - 4.0 * blur * pixel.x, coord.y - 4.0 * blur * pixel.y)) * 0.0162162162;
	col += texture2D(texture, vec2(coord.x - 3.0 * blur * pixel.x, coord.y - 3.0 * blur * pixel.y)) * 0.0540540541;
	col += texture2D(texture, vec2(coord.x - 2.0 * blur * pixel.x, coord.y - 2.0 * blur * pixel.y)) * 0.1216216216;
	col += texture2D(texture, vec2(coord.x - 1.0 * blur * pixel.x, coord.y - 1.0 * blur * pixel.y)) * 0.1945945946;
	col += texture2D(texture, vec2(coord.x + 4.0 * blur * pixel.x, coord.y - 4.0 * blur * pixel.y)) * 0.0162162162;
	col += texture2D(texture, vec2(coord.x + 3.0 * blur * pixel.x, coord.y - 3.0 * blur * pixel.y)) * 0.0540540541;
	col += texture2D(texture, vec2(coord.x + 2.0 * blur * pixel.x, coord.y - 2.0 * blur * pixel.y)) * 0.1216216216;
	col += texture2D(texture, vec2(coord.x + 1.0 * blur * pixel.x, coord.y - 1.0 * blur * pixel.y)) * 0.1945945946;
	col += texture2D(texture, vec2(coord.x, coord.y)) * 0.2270270270;
	col += texture2D(texture, vec2(coord.x + 1.0 * blur * pixel.x, coord.y + 1.0 * blur * pixel.y)) * 0.1945945946;
	col += texture2D(texture, vec2(coord.x + 2.0 * blur * pixel.x, coord.y + 2.0 * blur * pixel.y)) * 0.1216216216;
	col += texture2D(texture, vec2(coord.x + 3.0 * blur * pixel.x, coord.y + 3.0 * blur * pixel.y)) * 0.0540540541;
	col += texture2D(texture, vec2(coord.x + 4.0 * blur * pixel.x, coord.y + 4.0 * blur * pixel.y)) * 0.0162162162;
	col += texture2D(texture, vec2(coord.x - 1.0 * blur * pixel.x, coord.y + 1.0 * blur * pixel.y)) * 0.1945945946;
	col += texture2D(texture, vec2(coord.x - 2.0 * blur * pixel.x, coord.y + 2.0 * blur * pixel.y)) * 0.1216216216;
	col += texture2D(texture, vec2(coord.x - 3.0 * blur * pixel.x, coord.y + 3.0 * blur * pixel.y)) * 0.0540540541;
	col += texture2D(texture, vec2(coord.x - 4.0 * blur * pixel.x, coord.y + 4.0 * blur * pixel.y)) * 0.0162162162;

	float l = luma(col);
	if ((l >= .175 && l <= .265) || l > .9){
		float c;
		if (l < .9){
			c = 1. * min(1., sin((l - .175) * 34.9065850399));
			
		}else{
			c = (l - .9) * 1.5;
		}
		col = vec4(c, c, c, 1.);
	}else{
		col = vec4(0., 0., 0., 1.);
	}
	return col;
}

void main(){
	float blur = 1.0;

	vec4 col = vec4(0.0);
	col += metaball(vec2(vertTexCoord.x - 4.0 * blur * pixel.x, vertTexCoord.y - 4.0 * blur * pixel.y)) * 0.0162162162;
	col += metaball(vec2(vertTexCoord.x - 3.0 * blur * pixel.x, vertTexCoord.y - 3.0 * blur * pixel.y)) * 0.0540540541;
	col += metaball(vec2(vertTexCoord.x - 2.0 * blur * pixel.x, vertTexCoord.y - 2.0 * blur * pixel.y)) * 0.1216216216;
	col += metaball(vec2(vertTexCoord.x - 1.0 * blur * pixel.x, vertTexCoord.y - 1.0 * blur * pixel.y)) * 0.1945945946;
	col += metaball(vec2(vertTexCoord.x + 4.0 * blur * pixel.x, vertTexCoord.y - 4.0 * blur * pixel.y)) * 0.0162162162;
	col += metaball(vec2(vertTexCoord.x + 3.0 * blur * pixel.x, vertTexCoord.y - 3.0 * blur * pixel.y)) * 0.0540540541;
	col += metaball(vec2(vertTexCoord.x + 2.0 * blur * pixel.x, vertTexCoord.y - 2.0 * blur * pixel.y)) * 0.1216216216;
	col += metaball(vec2(vertTexCoord.x + 1.0 * blur * pixel.x, vertTexCoord.y - 1.0 * blur * pixel.y)) * 0.1945945946;
	col += metaball(vec2(vertTexCoord.x, vertTexCoord.y)) * 0.2270270270;
	col += metaball(vec2(vertTexCoord.x + 1.0 * blur * pixel.x, vertTexCoord.y + 1.0 * blur * pixel.y)) * 0.1945945946;
	col += metaball(vec2(vertTexCoord.x + 2.0 * blur * pixel.x, vertTexCoord.y + 2.0 * blur * pixel.y)) * 0.1216216216;
	col += metaball(vec2(vertTexCoord.x + 3.0 * blur * pixel.x, vertTexCoord.y + 3.0 * blur * pixel.y)) * 0.0540540541;
	col += metaball(vec2(vertTexCoord.x + 4.0 * blur * pixel.x, vertTexCoord.y + 4.0 * blur * pixel.y)) * 0.0162162162;
	col += metaball(vec2(vertTexCoord.x - 1.0 * blur * pixel.x, vertTexCoord.y + 1.0 * blur * pixel.y)) * 0.1945945946;
	col += metaball(vec2(vertTexCoord.x - 2.0 * blur * pixel.x, vertTexCoord.y + 2.0 * blur * pixel.y)) * 0.1216216216;
	col += metaball(vec2(vertTexCoord.x - 3.0 * blur * pixel.x, vertTexCoord.y + 3.0 * blur * pixel.y)) * 0.0540540541;
	col += metaball(vec2(vertTexCoord.x - 4.0 * blur * pixel.x, vertTexCoord.y + 4.0 * blur * pixel.y)) * 0.0162162162;

	gl_FragColor = col * 2. * vec4(.65, .25, vertTexCoord.x * .5, 1.);
}
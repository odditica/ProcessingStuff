varying vec4 gl_TexCoord;
uniform sampler2D tex;
uniform vec2 resolution;
float cells = 50.;

float lightness(sampler2D s, vec2 coord){
	vec4 c = texture2D(s, vec2(floor(coord.x * cells) / cells, floor(coord.y * cells) / cells));
	return (c.r * 0.3 + c.g * 0.59 + c.b * 0.11);
}

void main(){
	float cellRadius = (1. / cells) * .5;
	vec2 loc = vec2(gl_FragCoord.x / resolution.x, 1. - (gl_FragCoord.y / resolution.y));
	vec2 inCell = vec2(floor(loc.x * cells) / cells, floor(loc.y * cells) / cells);
	vec2 target = vec2(inCell.x + cellRadius, inCell.y + cellRadius);
	float value = (((resolution.x / cells) * .22) * (lightness(tex, loc))) - (min(1., (cellRadius * .025 + distance(loc, target) * 2.))) * 150.;
	vec4 col = vec4(1. * value, 1. * value, 1. * value, 1.);
	gl_FragColor = col;
}
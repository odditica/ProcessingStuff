uniform sampler2D image;
uniform vec2 resolution;
varying vec2 texCoord;

void main(){

	//gl_FragColor = vec4(1., 1., 1., 1.);
	vec4 texPixel = texture2D(image, vec2(gl_FragCoord.x / resolution.x, 1. - (gl_FragCoord.y / resolution.y)));
	gl_FragColor = vec4(1. - texPixel.rgb, 1.);
	//vec4(pixel.r, pixel.g * .1, pixel.b * .1, 1.)
}
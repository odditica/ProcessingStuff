varying vec3 vertNormal;
varying vec4 vertTexCoord;
varying vec2 screenCoord;
varying vec4 vertColor;
uniform sampler2D skyTex;

void main(){
	vec3 light = vec3(0., 0., 1.);
	float lightMultiplier = dot(light, vertNormal);
	vec2 preCoord = vec2(gl_FragCoord.x / 750 - vertNormal.x * .2, 1. - (gl_FragCoord.y / 750. - vertNormal.y * .2));
	float mult = .65;
	preCoord.x *= mult;
	preCoord.y *= mult;
	preCoord.x += (1. - mult) * .5;
	preCoord.y += (1. - mult) * .5;
	vec4 pixel = texture2D(skyTex, preCoord);
	pixel.rgb -= .5;
	pixel.rgb *= 3.;
	float luma = (pixel.r + pixel.g + pixel.b) / 3.;
	pixel.gb *= .25;
	gl_FragColor = (pixel * (1. + lightMultiplier * .4)) * vertColor;
}
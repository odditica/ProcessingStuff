uniform sampler2D texture;
varying vec4 vertTexCoord;

vec3 grayscale(vec4 col){
	float l = ((col.r * 0.299 + col.g * 0.587 + col.b * 0.114) / 3.);
	return vec3(l, l, l);
}

void main(){
	vec4 texPixel = texture2D(texture, vertTexCoord.xy);
	gl_FragColor = vec4((grayscale(texPixel).rgb) * vec3(3.1, 2.4, 6.3) * 1.5, 1.);
}
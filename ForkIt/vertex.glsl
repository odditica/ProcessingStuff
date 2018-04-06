uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;
uniform mat3 projection;
uniform mat4 modelView;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;

flat varying vec3 vertNormal;
flat varying vec4 vertColor;
flat varying vec4 vertTexCoord;
flat varying vec4 screenCoord;


void main() {
  vertColor = color;
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
  vertNormal = normalize(normalMatrix * normal);
  gl_Position = transform * (position + vec4(normalize(normal) * .15, 0.));

  
  //gl_Position.xyz += vertNormal * 20.5;
  //screenCoord = position * transform;

  //screenCoord.xy /= 1. / position.w;
  
 

}
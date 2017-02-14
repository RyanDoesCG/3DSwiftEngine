/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Shader.vert
 *  WolfRun
 *
 *  Created by user on 13/02/2017.
 *  Copyright © 2017 Baked Goods Studios. All rights reserved.
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform vec4 colour;

uniform mat3 normalMatrix;

void main() {
   // vec3 eyeNormal     = normalize(normalMatrix * normal);
   // vec3 lightPosition = vec3(0.0, 0.0, 6.0);
   // vec4 diffuseColor  = vec4(0.26, 0.2, 0.2, 1.0);
    
   // float nDotVP       = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    colorVarying       = colour;
    
    gl_Position = projection * view * model * position;
}

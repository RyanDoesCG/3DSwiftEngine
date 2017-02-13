//
//  Shader.fsh
//  WolfRun
//
//  Created by user on 13/02/2017.
//  Copyright © 2017 Baked Goods Studios. All rights reserved.
//

varying lowp vec4 colorVarying;

void main() {
    gl_FragColor = colorVarying;
}

/* 
   [ Fork it.     ] 
   [  by Blokatt  ] 
   [   06/04/2018 ] 
   
   Models made in Blender.
*/ 

PShader shdPost;
PShader shdFat;
PShape socket;
PShape socketSmooth;
PShape fork;
PShape forkSmooth;
PGraphics post;
float colourOffset;
float time, fullTime;

void drawModel(PGL pgl, PShape modelSmooth, PShape model) {
    pgl.enable(PGL.CULL_FACE);
    pgl.frontFace(PGL.CCW);
    post.shader(shdFat);
    post.shape(modelSmooth, 0, 0);
    post.resetShader();
    pgl.frontFace(PGL.CW);
    pgl.disable(PGL.CULL_FACE);
    post.shape(model, 0, 0);
}

void setup() {
    size(750, 750, P3D);
    smooth(8);
    shdPost = loadShader("post.glsl");
    shdFat = loadShader("frag.glsl", "vertex.glsl");
    socket = loadShape("socket2.obj");
    socketSmooth = loadShape("socket2Smooth.obj");
    fork = loadShape("fork.obj");
    forkSmooth = loadShape("forkSmooth.obj");
    post = createGraphics(width, height, P3D);
    time = 1;
    fullTime = 0;
    noCursor();
}

void draw() {
    fullTime += .005;
    time = fullTime % 1;
    colourOffset = 0;
    colorMode(HSB);
    post.beginDraw();
    post.colorMode(HSB);
    post.background(27, 80, 230);
    post.ortho(-width / 2, width / 2, -height / 2, height / 2, -2500, 2500);
    post.directionalLight(255, 0, 55, -.2, 1, .2);
    post.directionalLight(255, 0, 55, 0, -1, 0);
    post.directionalLight(255, 0, 55, 0, 1, 0);
    post.directionalLight(255, 0, 135, -1, 0, 1);
    post.directionalLight(255, 0, 135, 1, 0, -1);
    post.directionalLight(255, 0, 135, -1, 0, 0);
    post.directionalLight(255, 0, 225, 0, 0, -1);

    PGL pgl = beginPGL();
    
    float _x, _y;
    for (float y = -1; y < 7; ++y) {
        for (float x = -1; x < 7; ++x) {
            _x = x * 130;
            _y = y * 140;
            if ((x % 2) == 0) {
                _y += time * 140;
            } else {
                _y -= time * 140;
            }
            post.pushMatrix();

            post.translate(50 + _x, 25 + _y);
            post.pushMatrix();
            post.scale(15);
            post.pushMatrix();
            post.rotateX(-PI / 6.5 + sin((_x - _y) * .05) * .03);
            post.rotateZ(PI);
            post.rotateY(-(PI / 4.1) * 3 + sin((_x + _y) * .05) * .03);
            socket.setFill(color(((_x + _y) * .022 + colourOffset) % 255, 150, 255));
            post.colorMode(HSB);

            drawModel(pgl, socketSmooth, socket);

            post.pushMatrix();

            if ((x % 2) == 0) {
                post.translate(6.4, 0, cos(time * TAU) * 2.25 + .5);
            } else {
                post.translate(6.4, 2.8, .5 + cos(time * TAU) * 2.85);
            }

            post.pushMatrix();
            post.rotateZ(cos(time * TAU) * .4);

            if ((x % 2) == 0) {
                post.rotateX(-1.3 + time * TAU);
            } else {
                post.rotateX(1.3 + time * TAU);
            }

            post.translate(-100 - 100 * time, 0, sin(time * TAU) * 2);
            for (float z = 0; z < 3; ++z) {
                fork.setFill(color(constrain(((_x + _y) * .022 + colourOffset) % 255 + sin(time * PI) * 15, 0, 14), 150, 255));
                drawModel(pgl, forkSmooth, fork);
                post.translate(100, 0, 0);
            }
            post.popMatrix();
            post.popMatrix();
            post.popMatrix();
            post.popMatrix();
            post.popMatrix();
        }
    }

    endPGL();

    post.blendMode(ADD);
    post.fill(250, 155, 60);
    post.strokeWeight(2);
    post.translate(0, 0, 1000);
    post.rectMode(CENTER);
    post.rect(width / 2, height / 2, width, height);
    post.blendMode(NORMAL);
    post.endDraw();

    shader(shdPost);
    image(post, 0, 0);
    resetShader();
}
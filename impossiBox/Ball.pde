class Ball{
  public float startX, startY, startZ, x, y, z, dX, dY, dZ;
  
  public Ball(){
    dX = 4 * SPEED;
    dY = 4 * SPEED;
    dZ = 4 * SPEED;
    if (random(1) <= .5) dX *= -1;
    if (random(1) <= .5) dY *= -1;
    if (random(1) <= .5) dZ *= -1;
  }
  
  void move(){
    if ((x + dX) <= -BOX_S){
      while (x - 1 >= -BOX_S){
        x -= 1;
      }
      dX = -dX;
    }
    
    if ((x + dX) >= BOX_S){
      while (x + 1 <= BOX_S){
        x += 1;
      }
      dX = -dX;
    }
     
    x += dX;
    if ((y + dY) <= -BOX_S){
      while (y - 1 >= -BOX_S){
        y -= 1;
      }
      dY = -dY;
    }
    
    if ((y + dY) >= BOX_S){
      while (y + 1 <= BOX_S){
        y += 1;
      }
      dY = -dY;
    }
    y += dY;
    if ((z + dZ) <= -BOX_S){
      while (z - 1 >= -BOX_S){
        z -= 1;
      }
      dZ = -dZ;
    }
    
    if ((z + dZ) >= BOX_S){
      while (z + 1 <= BOX_S){
        z += 1;
      }
      dZ = -dZ;
    }
    z += dZ;
  }
  
  void draw(){
    ballBuffer.pushMatrix();
    ballBuffer.translate(x, y, z);
    ballBuffer.rotateY(-(sin(TAU * time)));
    ballBuffer.rotateX(PI / 2);
    ballBuffer.pushMatrix();
    ballBuffer.sphere(BALL_RADIUS);
    ballBuffer.popMatrix();
    ballBuffer.popMatrix();
  }
}
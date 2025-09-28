Enemy zombie;
Player leon;
boolean wPressed, aPressed, sPressed, dPressed;

float camX = 0;
float camY = 0;

ArrayList<Enemy>zombies = new ArrayList<Enemy>();


//randomize potion for player (its might boost the enemy risks are high)




void setup() {
  size(1000, 800);
  for (int i = 0; i <20; i++) {
    float zx = random(width*2) - width;
    float zy = random(height*2) - height;

    zombies.add(new Enemy(zx, zy));
  }

  leon = new Player(width/2, height/2);
}

void draw() {
  background(50);
  //imageMode(CENTER);
  camX = width/2 - leon.x;
  camY = height/2 - leon.y;
  
  //apply camera
  pushMatrix();
  translate(camX,camY);
  //scale(0.5);
  //imageMode(CENTER);
  
  leon.update(wPressed,aPressed,sPressed,dPressed);
  
  for(Enemy z : zombies){
    z.update(leon);
    z.display();
    
  }
  
  leon.display();
  popMatrix();
}




void keyPressed() {

  if (key == 'w' || key == 'W') wPressed = true;
  if (key == 'a' || key == 'A') aPressed = true;
  if (key == 's' || key == 'S') sPressed = true;
  if (key == 'd' || key == 'D') dPressed = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') wPressed = false;
  if (key == 'a' || key == 'A') aPressed = false;
  if (key == 's' || key == 'S') sPressed = false;
  if (key == 'd' || key == 'D') dPressed = false;
}

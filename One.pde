Enemy zombie;
Player leon;
int framecount =0;
float x, y;

float speed = 5;




void setup() {
  size(800, 600);
  zombie = new Enemy();
  zombie.walk = new PImage[17];
  for(int i = 0 ; i < zombie.walk.length;i++){
     zombie.walk[i] = loadImage("skeleton-move_"+i+".png");
     if (zombie.walk[i] == null) {
    println("Failed to load: skeleton-move_" + i + ".png");
  }
  }
  leon = new Player();
  //leon.charachter = loadImage("survivor-move_rifle_0.png");
  leon.walk = new PImage[18];
  for(int i = 0 ; i < leon.walk.length;i++){
    leon.walk[i] = loadImage("survivor-move_rifle_" + i +".png");
  }
  /*walk = new PImage[18];
  for (int i = 0; i < walk.length; i++) {
    walk[i] = loadImage("survivor-move_rifle_" + i +".png");
  }
  */
  zombie.x =0;
  zombie.y =100;
  leon.x = width/2;
  leon.y = height/2;
  //x = width/2;
  //y = height/2;
}

void draw() {
  background(50);
  imageMode(CENTER);

  //image(zombie.enemyImage, zombie.x, zombie.y);
  //println("the zombie x is : " +zombie.x);

    if (keyPressed) {
    if (keyCode == LEFT)  leon.x -= speed;
    if (keyCode == RIGHT) leon.x += speed;
    if (keyCode == UP)    leon.y -= speed;
    if (keyCode == DOWN)  leon.y += speed;


    framecount = (frameCount / 5) % zombie.walk.length;
  } else {
    framecount = 0;
  }
  
  //TODO: make sure the zombie will flw leon
  if(zombie.isFlwing == true){
    if(zombie.x < leon.x){
       zombie.x++; 
    }else if(zombie.x > leon.x){
      zombie.x-=1;
    }
    if(zombie.y > leon.x){
        zombie.y -=1;
    }else if(zombie.y < leon.x){
      zombie.y++;
    }
    
    
    
  }

  image(zombie.walk[framecount],zombie.x,zombie.y);
  image(leon.walk[framecount], leon.x, leon.y);
}

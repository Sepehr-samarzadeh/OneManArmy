class Enemy {
 float x;
 float y;
 int framecount;
 PImage enemyImage;
 PImage[] walk;
 boolean isFlwing;
 
 Enemy(float zomX,float zomY){
  x = zomX;
  y = zomY;
  walk = new PImage[17];
  for(int i = 0; i < walk.length; i++){
    walk[i] = loadImage("skeleton-move_" + i + ".png");
    walk[i].resize(walk[i].width/2,walk[i].height/2);
  }
   
 }
 
 void update(Player target){
  float speed = 1.5; 
  
  if(x < target.x) x += speed;
  if(x > target.x) x -= speed;
  if(y < target.y) y += speed;
  if(y > target.y) y -= speed;
  
  framecount = (frameCount / 5) % walk.length;

 }
 
 void display(){
  image(walk[framecount],x,y); 
   
 }
 
}

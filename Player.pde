class Player {
 float x;
 float y;
 float speed = 5;
 int framecount;
 PImage [] walk;
 PImage charachter;
 
 Player(float px,float py){
  x = px;
  y = py;
  walk = new PImage[18];
  for(int i = 0; i < walk.length; i++){
   walk[i] = loadImage("survivor-move_rifle_" + i + ".png");
   walk[i].resize(walk[i].width/2,walk[i].height/2);
    
  }
 }
 void update(boolean w,boolean a,boolean s,boolean d){
  if(w) y -= speed; 
  if(s) y += speed; 
  if(a) x -= speed; 
  if(d) x += speed; 
  
  framecount = (frameCount / 5)% walk.length;
  
 }
 
 void display() {
  image(walk[framecount],x,y); 
 }
 
}

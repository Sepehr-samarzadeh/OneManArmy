class Bullet {
  
  float x,y;
  float vx,vy;
  float speed = 10;
  float size = 10;
  
  Bullet(float startX,float startY,float targetX,float targetY){
    
    this.x = startX;
    this.y = startY;
    
    float angle = atan2(targetY - startY,targetX - startX);
    vx = cos(angle) * this.speed;
    vy = sin(angle) * this.speed;
  }
  
  void update(){
   this.x += vx;
   this.y += vy;
    
  }
  
  void display(){
   fill(255,200,0);
   noStroke();
   ellipse(this.x,this.y,this.size,this.size);
    
  }
  
  boolean offScreen(){
     return(x < -5000 || x > 5000 || y < -5000 || y > 5000); 
  }
  
  
  
  
  
  
}

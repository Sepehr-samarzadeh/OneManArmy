import processing.sound.*;
SoundFile gunshot;
SoundFile bgMusic;
SoundFile iHateyou;

Enemy zombie;
Player leon;



boolean wPressed, aPressed, sPressed, dPressed;



float camX = 0;
float camY = 0;

boolean gameOver = false;
boolean gameIntro = true;

ArrayList<Enemy>zombies = new ArrayList<Enemy>();


ArrayList<Bullet> bullets = new ArrayList<Bullet>();
boolean shooting = false;


String joke;

int startTime;
float survivalTime = 0;
float bestRecord = 0;


void setup() {
  size(960, 640);

  getJoke();



  for (int i = 0; i <20; i++) {
    float zx = random(width*2) - width;
    float zy = random(height*2) - height;

    zombies.add(new Enemy(zx, zy));
  }

  leon = new Player(width/2, height/2);

  gunshot = new SoundFile(this, "gun.mp3");
  bgMusic = new SoundFile(this, "bgmusic.mp3");
  iHateyou = new SoundFile(this, "ihateyou.mp3");
  bgMusic.loop();
  startTime = millis();
}

void draw() {
  background(50);
  
  if(gameIntro) {
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(40);
    text("ONE Army Man",width/2,height/3 - 60);
    textSize(18);
    text("HOW TO PLAY : ",width/2,height/3 +10);
    textSize(16);
    text("W, A, S, D for moving around\n hold left mouse button to shoot \n Survive as long as possible. good luck!\nPress Enter to start",width/2,height/2);
    return;
  }
  

  if (gameOver) {
    if (survivalTime > bestRecord) bestRecord = survivalTime;

    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("YOU DIED", width/2, height/2);
    textSize(20);
    text("press R to restart", width/2, height/2 + 60);

    textSize(24);
    text("You survived: " +nf(survivalTime, 0, 2)+ "s", width/2, height/2 +100);
    text("Best record: " +nf(bestRecord, 0, 2)+ "s", width/2, height/2 +130);

    textAlign(CENTER, BOTTOM);
    textSize(18);
    text(joke, width/2, height/3);

    if (bgMusic.isPlaying()) bgMusic.stop();
    iHateyou.play();


    noLoop();
    return;
  }


  //imageMode(CENTER);
  camX = width/2 - leon.x;
  camY = height/2 - leon.y;


  //apply camera
  pushMatrix();
  translate(camX, camY);


  leon.update(wPressed, aPressed, sPressed, dPressed);

  if (shooting && frameCount %10 == 0) {
    float targetX = mouseX - camX;
    float targetY = mouseY - camY;
    bullets.add(new Bullet(leon.x, leon.y, targetX, targetY));
  }

  for (int i = bullets.size() -1; i >=0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    for (int j = zombies.size() -1; j >=0; j--) {
      Enemy z = zombies.get(j);
      if (dist(b.x, b.y, z.x, z.y) < 30) {
        zombies.remove(j);
        bullets.remove(i);
        break;
      }
    }
    if (b.offScreen()) bullets.remove(i);
  }

  for (Enemy z : zombies) {
    z.update(leon);
    z.display();


    if (checkCollision(leon.x, leon.y, leon.getWidth(), leon.getHeight(), z.x, z.y, z.getWidth(), z.getHeight())) {
      gameOver = true;
    }
  }



  leon.display();
  popMatrix();

  survivalTime = (millis() - startTime) / 1000.0;

  textSize(14);
  textAlign(RIGHT, TOP);
  text("Time: " + nf(survivalTime, 0, 2) + "s", width - 10, 10);
  text("Best: " + nf(bestRecord, 0, 2) + "s", width - 10, 30);
}




void keyPressed() {
  if(key == ENTER || key == RETURN){
    if(gameIntro) {
      gameIntro = false;
      startTime = millis();
      return;
    }
  }
    
    
    
  
  if (key == 'w' || key == 'W') wPressed = true;
  if (key == 'a' || key == 'A') aPressed = true;
  if (key == 's' || key == 'S') sPressed = true;
  if (key == 'd' || key == 'D') dPressed = true;

  if (gameOver && key == 'r' || key == 'R') {
    restartGame();
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') wPressed = false;
  if (key == 'a' || key == 'A') aPressed = false;
  if (key == 's' || key == 'S') sPressed = false;
  if (key == 'd' || key == 'D') dPressed = false;
}


void mousePressed() {
  if (mouseButton == LEFT) {
    shooting = true;
    gunshot.play();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) shooting = false;
}








boolean checkCollision(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {

  float hitboxScale = 0.5; // smaller = needs to be closer (0.5 = half size box)

  float hw1 = (r1w * hitboxScale) / 2;
  float hh1 = (r1h * hitboxScale) / 2;
  float hw2 = (r2w * hitboxScale) / 2;
  float hh2 = (r2h * hitboxScale) / 2;

  return (r1x - hw1 < r2x + hw2 &&
    r1x + hw1 > r2x - hw2 &&
    r1y - hh1 < r2y + hh2 &&
    r1y + hh1 > r2y - hh2);
}

void restartGame() {

  leon = new Player(width/2, height/2);
  zombies.clear();
  for (int i = 0; i < 20; i++) {
    float zx = random(width*2) - width;
    float zy = random(height*2) - height;
    zombies.add(new Enemy(zx, zy));
  }
  gameOver = false;
  getJoke();
  loop();
  bgMusic.loop();

  startTime = millis();
}

void getJoke() {
  JSONObject jokeAPI = loadJSONObject("https://v2.jokeapi.dev/joke/Programming,Miscellaneous?type=single");
  joke = jokeAPI.getString("joke");
}

import processing.sound.*;
SoundFile gunshot;
SoundFile bgMusic;
SoundFile iHateyou;

Enemy zombie;
Player leon;

JSONObject map;
JSONArray layers, tilesets;

boolean wPressed, aPressed, sPressed, dPressed;

int tileWidth, tileHeight, mapWidth, mapHeight;

float camX = 0;
float camY = 0;

boolean gameOver = false;

ArrayList<Enemy>zombies = new ArrayList<Enemy>();
Tileset[] loadedTilesets;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
boolean shooting = false;


String joke;


void setup() {
  size(960, 640);
  map = loadJSONObject("themap.json");

  getJoke();

  tileWidth = map.getInt("tilewidth");
  tileHeight = map.getInt("tileheight");
  mapWidth = map.getInt("width");
  mapHeight = map.getInt("height");

  tilesets = map.getJSONArray("tilesets");
  loadedTilesets = new Tileset[tilesets.size()];


  for (int i = 0; i <tilesets.size(); i++) {
    JSONObject ts = tilesets.getJSONObject(i);
    Tileset t = new Tileset();
    t.firstgid = ts.getInt("firstgid");
    t.tilecount = ts.getInt("tilecount");
    t.columns = ts.getInt("columns");
    t.imageFile = ts.getString("image");
    t.image = loadImage(t.imageFile);
    t.tileWidth = ts.getInt("tilewidth");
    t.tileHeight = ts.getInt("tileheight");

    loadedTilesets[i] = t;
  }

  layers = map.getJSONArray("layers");

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
}

void draw() {
  background(50);

  if (gameOver) {
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("YOU DIED", width/2, height/2);
    textSize(20);
    text("press R to restart", width/2, height/2 + 60);
    textAlign(CENTER,BOTTOM);
    textSize(18);
    text(joke, width/2,height/3);

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
  //scale(0.5);
  //imageMode(CENTER);


  for (int l = 0; l <layers.size(); l++) {
    JSONObject layer = layers.getJSONObject(l);
    if (!layer.getString("type").equals("tilelayer")) continue;
    JSONArray data = layer.getJSONArray("data");

    for (int y = 0; y < mapHeight; y++) {
      for (int x = 0; x< mapWidth; x++) {
        int gid = data.getInt(y * mapWidth + x);
        if (gid == 0) continue;

        Tileset ts = findTileset(gid);
        if (ts == null) continue;

        int localId = gid - ts.firstgid;
        int sx = (localId % ts.columns) * ts.tileWidth;
        int sy = (localId / ts.columns) * ts.tileHeight;

        PImage tile = ts.image.get(sx, sy, ts.tileWidth, ts.tileHeight);
        image(tile, x * tileWidth, y* tileHeight);
      }
    }
  }







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
}




void keyPressed() {

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



Tileset findTileset(int gid) {
  Tileset result = null;
  for (int i = 0; i < loadedTilesets.length; i++) {
    Tileset ts = loadedTilesets[i];

    if (gid >= ts.firstgid && gid < ts.firstgid + ts.tilecount) {
      result = ts;
    }
  }
  return result;
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
}

void getJoke(){
 JSONObject jokeAPI = loadJSONObject("https://v2.jokeapi.dev/joke/Programming,Miscellaneous?type=single");
 joke = jokeAPI.getString("joke");
}

Enemy zombie;
Player leon;
JSONObject map;
JSONArray layers,tilesets;
boolean wPressed, aPressed, sPressed, dPressed;
int tileWidth,tileHeight,mapWidth,mapHeight;

float camX = 0;
float camY = 0;

ArrayList<Enemy>zombies = new ArrayList<Enemy>();
Tileset[] loadedTilesets;

//TODO:
//add consuamables //make it randomize so sometimes its better to not pickup an item
//add healthbar (not really want to do)
//background
//better flw logic




void setup() {
  size(960, 640);
  map = loadJSONObject("themap.json");
  
  tileWidth = map.getInt("tilewidth");
  tileHeight = map.getInt("tileheight");
  mapWidth = map.getInt("width");
  mapHeight = map.getInt("height");
  
  tilesets = map.getJSONArray("tilesets");
  loadedTilesets = new Tileset[tilesets.size()];
  
  
  for(int i = 0;i <tilesets.size();i++){
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
  
  
  for(int l = 0; l <layers.size();l++){
    JSONObject layer = layers.getJSONObject(l);
    if(!layer.getString("type").equals("tilelayer")) continue;
    JSONArray data = layer.getJSONArray("data");
    
    for(int y = 0 ; y < mapHeight; y++){
      for(int x = 0; x< mapWidth; x++){
        int gid = data.getInt(y * mapWidth + x);
        if(gid == 0) continue;
        
        Tileset ts = findTileset(gid);
        if(ts == null) continue;
        
        int localId = gid - ts.firstgid;
        int sx = (localId % ts.columns) * ts.tileWidth;
        int sy = (localId / ts.columns) * ts.tileHeight;
        
        PImage tile = ts.image.get(sx,sy,ts.tileWidth,ts.tileHeight);
        image(tile,x * tileWidth,y* tileHeight);
      }
    }
  }
  
  
  
  
  
  
  
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

Tileset findTileset(int gid){
  Tileset result = null;
  for(int i = 0; i < loadedTilesets.length; i++){
    Tileset ts = loadedTilesets[i];
    
    if(gid >= ts.firstgid && gid < ts.firstgid + ts.tilecount){
      result = ts;
    }
  }
  return result;
  
}

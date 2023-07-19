class Rock{
  float x;
  float y;
  float size;
  float speed;
  float gravity = 0.2;
  float shift;
  float angle;
  float changeAngle;
  boolean active = true;
  PImage image;
  PImage[] dust;
  boolean dustDone = false;
  
  int count;
  int currentDelay = 0;
  int delay = 5; // number of frames one pic is repeated
 
 
  public Rock(float x, float y, float size, float speed, float angle, float shift){
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
    this.angle = angle;
    this.shift = shift;
    this.changeAngle = random(-3, 4);
    image = loadImage("media/rock/rock0.png");
    
    dust = new PImage[4];
    for(int i=0; i<4; i++){ dust[i] = loadImage("media/dust/dust" + i + ".png"); }
  }
  
  
  float getX(){ return x; }
  float getY(){ return y; }
  float getSize(){ return size; }
  boolean getActive(){ return active; }
  boolean dustDone(){ return dustDone; }
  
  
  void changeActive(){ 
    if (active){ active = false; }
  }
  
  
  void display(){
    if (active){ 
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(image, 0, 0, size, size); 
      popMatrix();
      angle += changeAngle;
    }
  }
  
  void drawDust(){
    if (currentDelay % delay == 0){ count++; }
    if(count >= 4){ 
      count = 0; 
      dustDone = true;
    }
    if(!dustDone){ image(dust[count], x, 660, dust[count].width * 0.65, dust[count].height * 0.65); }
    currentDelay++;
  }
  
 
  void update(){
    y = y + speed;
    x = x + shift;
    speed = speed + gravity;
  }
  
}

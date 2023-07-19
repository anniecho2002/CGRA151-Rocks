class Potion{
  float x;
  float y;
  float size = 80;
  float speed;
  float gravity = 0.2;
  String prefix;
  PImage image;
  
  public Potion(float x, float y, float speed, String prefix){
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.prefix = prefix;
    image = loadImage("media/potions/potion0.png");
  }
  
  void display() {
    image(image, x, y, size, size);
  }


  void update() { 
    y = y + speed; 
    speed = speed + gravity;
  }
  
  float getX(){ return x; }
  float getY(){ return y; }
  float getSize(){ return size; }
  String getPrefix(){ return prefix; }
  
}

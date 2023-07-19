class Coin {
  float x;
  float y;
  float size = 50;
  float speed;
  float gravity = 0.2;
  PImage[] images;

  int count;
  int currentDelay = 0;
  int delay; // number of frames one pic is repeated



  public Coin(float x, float y, float speed, int delay) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.delay = delay;
    images = new PImage[6];
    for (int i=0; i<6; i++) {
      images[i] = loadImage("media/coins/coin" + i + ".png");
    }
  }


  void display() {
    if (currentDelay % delay == 0) { count++; }
    if (count >= 6) { count = 0; }
    image(images[count], x, y, size, size);
    currentDelay++;
  }


  void update() { 
    y = y + speed; 
    speed = speed + gravity;
  }
  
  float getX() { return x; }
  float getY() { return y; }
  float getSize() { return size; }
  
  void coinSound(){
    int num = int(random(1,3));
    if(num == 1){coinSound1.play();}
    else if(num == 2){coinSound2.play();}
  }
  
  
}

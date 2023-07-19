class Warning{
  PImage[] images;
  float x;
  float y = 95;
  
  int imageCount = 9;
  int count;
  int currentDelay = 0;
  int delay = 10; // number of frames one pic is repeated
  boolean done = false;
  
  public Warning(float x){
    this.x = x;
    images = new PImage[9];
    for(int i=0; i<imageCount; i++){ // for the number of images in the array
       images[i] = loadImage("media/warning/warning" + i + ".png");
    }
  }
  
  void display(){
    if (currentDelay % delay == 0){ count++; }
    if(count >= imageCount){ 
      count = 0; 
      done = true;
    }
    image(images[count], x, y, 80, 80);
    currentDelay++;
   }
   
   boolean isDone(){ return done; }
   float getX(){ return x; }
}

class State{
  PImage[] images;
  String name;
  int imageCount;
  int count;
  int currentDelay = 0;
  int delay; // number of frames one pic is repeated
  float scale;
  
  
  
  State(String prefix, int count, int delay, float scale){
    this.name = prefix;
    this.imageCount = count;
    this.delay = delay;
    this.scale = scale;
    images = new PImage[imageCount];
    for (int i=0; i<imageCount; i++){
      images[i] = loadImage("media/" + prefix + "/" + prefix + i + ".png");
    }
  }
  
  
  void displayState(float xpos, float ypos){
    if (currentDelay % delay == 0){
      count++;
    }
    if(count >= imageCount){
      if(name.equals("death")){ 
        deathAnimation = false;
        deathDone = true; 
        return;
      }
      if(name.equals("hurt")){ 
        count = 0;
        hurtAnimation = false; 
        return;
      }
      else{
        count = 0;
      }
    }
    if(deathDone == false){image(images[count], xpos, ypos, images[count].width * 0.75, images[count].height * 0.75); }
    currentDelay++;
  }
  
  
  void displayStateFlip(float xpos, float ypos){
    if (currentDelay % delay == 0){
      count++;
    }
    if(count >= imageCount){
      if(name.equals("death")){
        deathAnimation = false;
        deathDone = true;
        return;
      }
      else if(name.equals("hurt")){
        count = 0;
        hurtAnimation = false;
        return;
      }
      else{
      count = 0;
      }
    }
    pushMatrix();
    scale(-1, 1);
    if(deathDone == false){image(images[count], -xpos, ypos, images[count].width * scale, images[count].height * scale);}
    popMatrix();
    currentDelay++;     
  }
  
  int getWidth(){ return images[0].width; }
  
  void reset(){
    count = 0;
    currentDelay = 0;
  }
  
}

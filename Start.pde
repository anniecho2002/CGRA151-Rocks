class Start{
  PImage[] background;
  PFont font;
  PFont secondary;
  int imageCount;
  int count;
  int currentDelay = 0;
  int delay;
  
  public Start(int numImages, int delay, PFont font, PFont secondary){
    imageMode(CENTER);
    this.imageCount = numImages;
    this.delay = delay;
    this.font = font;
    this.secondary = secondary;
    background = new PImage[imageCount];
    for (int i=0; i<imageCount; i++){
      background[i] = loadImage("media/background/background" + i + ".jpeg");
    }
  }
  
  void display(){
    if(currentDelay % delay == 0){ count++; }
    if(count >= imageCount){ count = 0; }
    image(background[count], width/2, height/2, background[count].width * height/background[count].height, background[count].height * height/background[count].height);
    currentDelay++;
    displayText();
  }
  
  void displayText(){
    textAlign(CENTER, CENTER);
    textFont(font);
    textSize(100);
    fill(0);
    text("ROCKS!", width/2 + 5, height/2 - 65);
    fill(244,137,246);
    text("ROCKS!", width/2, height/2 - 70);
    
    textSize(30);
    fill(0);
    text("** PRESS SCREEN TO START **", width/2 + 3, height/2 + 123);
    fill(244,137,246);
    text("** PRESS SCREEN TO START **", width/2, height/2 + 120);
    
    textSize(23);
    fill(0);
    text("** MOVE PINKY WITH MOUSE**", width/2 + 3, height/2 + 153);
    fill(244,137,246);
    text("** MOVE PINKY WITH MOUSE**", width/2, height/2 + 150);
    
    textSize(20);
    fill(0);
    text("CURRENT HIGHSCORE: " + highScore, width/2 + 3, height/2 + 183);
    fill(244,137,246);
    text("CURRENT HIGHSCORE: " + highScore, width/2, height/2 + 180);
    
    textFont(secondary);
    textSize(25);
    fill(0);
    text("by annie", width/2 + 2, height/2 + 2 - 10);
    fill(244,137,246);
    text("by annie", width/2, height/2 - 10);
  }
}

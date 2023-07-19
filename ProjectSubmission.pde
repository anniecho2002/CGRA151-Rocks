import processing.sound.*;
Start startPage;        // initializing startpage
public PFont startFont;
public PFont startFont2;
public SoundFile startMusic;
public SoundFile coinSound1;
public SoundFile coinSound2;
public SoundFile rockSound1;
public SoundFile runSound1;
public SoundFile potionSound;
String path; 

Character pinky;        // initializing the sprite
float xpos = width/2;   // character starting x value
float ypos = 625;       // character starting y value
float drag = 20.0;      // character drag when you move the mouse

PImage bgImage;
PImage bgImage2;
PImage coinCounter;
PImage heart;
int coinCount = 0;
int level = 1;
int health = 3;

boolean startGame = false;
boolean startText = true;
boolean wonGame = false;

boolean tintDecreasing = true;
float rTint = 255;
float gTint = 255;
float bTint = 255;

public boolean hurtAnimation = false;
public boolean deathDone = false;
public boolean deathAnimation = false;
boolean runningSound = false;

ArrayList<Integer> coinGoal = new ArrayList<Integer>();
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Warning> warnings = new ArrayList<Warning>();
ArrayList<Coin> coins = new ArrayList<Coin>();
ArrayList<Potion> potions = new ArrayList<Potion>();

String[] highScores;
public int highScore;

void setup(){
  frameRate(40);
  size(750,750);
  
  imageMode(CENTER);
  initializeImages();
  initializeStart();
  initializeMusic();
  

  
  coinGoal.add(10); // level one
  coinGoal.add(15); // level two
  coinGoal.add(1000); // level three
  pinky = new Character("Pinky");
  pinky.loadStates();
  
  highScores = loadStrings("highScores.txt");
  highScore = int(highScores[highScores.length - 1]);
}



void draw(){  
  if(startGame == false){ startPage.display(); }
  else if(deathDone == true){ displayDeathText(); }
  else if(deathDone == false){
    tint(rTint, gTint, bTint);
    adjustTint(); // adjusts the tint of the upcoming pictures
    image(bgImage, width/2, height/2);
    float dx = mouseX - xpos; // difference between where pinky is vs where mouse is
    xpos = xpos + dx/drag;
    
    if(startText){ displayStartText(); }
    if(!startText && !deathAnimation && !wonGame && !deathDone){
        makeRock();
        if(level > 1){
          makeWarning();
          checkWarning();
        }
        if(level > 2){
          makePotion();
          checkPotions();
        }
        checkRocks(); // checks all the rocks
        checkCoins(); // checks all the coins
    }
    
    if(hurtAnimation == false && deathAnimation == false && deathDone == false){ // then pinky is fine      
      if(mouseX > xpos){ // if the mouse is on the right of pinky
        if(abs(dx) < 30){
          pinky.drawState("idle", false, xpos, ypos);
          if(runningSound == true){ runSound1.pause(); }
          runningSound = false;
        }
        else{ 
          pinky.drawState("walk", false, xpos, ypos);
          runningSound();
        }
      }
      else{ // if it is on the left of pinky
        if(abs(dx) < 30){
          pinky.drawState("idle", true, xpos, ypos);
          if(runningSound == true){ runSound1.pause(); }
          runningSound = false; 
        }
        else{   
          pinky.drawState("walk", true, xpos, ypos);
          runningSound();
        }
      }
    }
    else if(hurtAnimation == true && deathAnimation == false && deathDone == false){
      if(mouseX > xpos){ pinky.drawState("hurt", false, xpos, ypos); }
      else{ pinky.drawState("hurt", true, xpos, ypos); }
    }
    else if(deathAnimation == true && deathDone == false){
      if(mouseX > xpos){ pinky.drawState("death", false, xpos, ypos); }
      else{ pinky.drawState("death", true, xpos, ypos); }
    }
    image(bgImage2, width/2, height/2);
    tint(255);    
    if(wonGame){ displayWinText(); }
    else{
      drawCoinCount();
      drawHearts();
    }
 }
  
}

// displays and checks all the rocks against pinky
void checkRocks(){
  ArrayList<Rock> rockRemoved = new ArrayList<Rock>();
  for(Rock r: rocks){
    r.update();
    if(r.getY() > 660 - r.getSize()/2){ 
      r.drawDust();
      if(r.dustDone()){ rockRemoved.add(r); }
    }
    else{ r.display(); }
    if(pinky.hitRock(r, xpos, ypos) == true){
      r.changeActive();
      rockRemoved.add(r);
      rockSound1.play();
      health--;
      if(health <= 0){ 
        deathAnimation = true; 
        break; 
      }
      else{ hurtAnimation = true; }
    }
  }
  for(Rock r: rockRemoved){ rocks.remove(r); }
}


// displays and checks all the potions against pinky
void checkPotions(){
  ArrayList<Potion> potionRemoved = new ArrayList<Potion>();
  makePotion();
  for(Potion p: potions){
    p.display();
    p.update();
    if(p.getY() > height + p.getSize()/2){ potionRemoved.add(p); }
    if(pinky.hitPotion(p, xpos, ypos) == true){
      potionRemoved.add(p);
      health = 3;
      potionSound.play(1, 1);
    }
  }
  for(Potion p: potionRemoved){ potions.remove(p); }
}


// displays and checks all the coins against pinky
void checkCoins(){
  ArrayList<Coin> coinRemoved = new ArrayList<Coin>();
  makeCoin();
  for(Coin c: coins){
    c.display();
    c.update();
    if(c.getY() > height + c.getSize()/2){ coinRemoved.add(c); }
    if(pinky.hitCoin(c, xpos, ypos) == true){
      coinCount++;
      coinRemoved.add(c);
      c.coinSound();
    }
  }
  for(Coin c: coinRemoved){ coins.remove(c); }
  if(coinCount >= coinGoal.get(level-1)){ wonGame = true; }
}


// checks if the warnings are done, if so, create a fast rock
void checkWarning(){
  ArrayList<Warning> removeWarning = new ArrayList<Warning>();
  for(Warning w: warnings){
    w.display();
    if(w.isDone()){ removeWarning.add(w); }
  }
  for(Warning w: removeWarning){ 
    makeFastRock(w.getX());
    warnings.remove(w); 
  }
}


// randomly generates a rock
void makeRock(){
  int chance = 0;
  int extraSpeed = 0;
  int extraShift = 0;
  if(level == 1){ chance = 41; }
  else if(level == 2) {
    chance = 35; 
    extraSpeed = 2;
    extraShift = 1;
  }
  else if(level > 2){
    chance = 29;
    extraSpeed = 4;
    extraShift = 2;
  }
  int randomNum = int(random(0, chance));
  if(randomNum == 1){
    float randomSize = random(70, 110);
    float randomX = random(randomSize/2, width - randomSize/2);  
    float randomSpeed = random(10, 16) + extraSpeed;
    float randomAngle = random(1, 11);
    float randomShift = random(-3 - extraShift, 3 + extraShift);
    rocks.add(new Rock(randomX, -randomSize/2, randomSize, randomSpeed, randomAngle, randomShift));
  }
}


// randomly generates a warning
void makeWarning(){
  int chance = 0;
  if(level == 2){ chance = 325; }
  else if (level > 2) { chance = 300; }
  int randomNum = int(random(0,chance));
  if(randomNum == 5){
    float randomX = random(50, width - 50);
    warnings.add(new Warning(randomX));
  }
}


// randomly generates a potion
void makePotion(){
  int chance = 1800;
  int randomNum = int(random(0, chance));
  if(randomNum == 5){
    String prefix = "";
    int randomPrefix = int(random(0,2));
    if(randomPrefix == 0){ prefix = "speed"; }
    else if(randomPrefix == 2){ prefix = "health"; }
    float randomX = random(50, width - 50);
    float randomSpeed = random(3, 7);
    potions.add(new Potion(randomX, -50.0, randomSpeed, prefix));
  }
  
  
}

// creates a fast rock (called after finishing a warning)
void makeFastRock(float x){
  int extraSpeed = 0;
  if(level > 2){ extraSpeed = 5; }
  float randomSize = random(100, 110);
  float randomAngle = random(1, 11);
  rocks.add(new Rock(x, -randomSize/2, randomSize, 45 + extraSpeed, randomAngle, 0));
}


// randomly generates a coin
void makeCoin(){
  int chance = 0;
  if(level <= 2){ chance = 101; }
  else if (level > 2) { chance = 85; }
  int randomNum = int(random(0,chance));
  if(randomNum == 5){
    float randomX = random(20, width - 20); // as to not include the edges
    float randomSpeed = random(5, 12);
    int randomSpin = int(random(7, 12));
    coins.add(new Coin(randomX, -25.0, randomSpeed, randomSpin));
  }
}


// starts the running sound
void runningSound(){
  if(runningSound == false){
    runningSound = true;
    runSound1.loop(1, 1);
  }
}



// draws the coincounter
void drawCoinCount(){
  image(coinCounter, 50, 50, 50, 50);
  textSize(50);
  textFont(startFont);
  if(level<3){
    fill(0);
    text(coinCount + "/" + coinGoal.get(level-1), 130+3, 45+3);
    fill(255);
    text(coinCount + "/" + coinGoal.get(level-1), 130, 45);
  }
  else{
    fill(0);
    text(coinCount, 100+3, 45+3);
    fill(255);
    text(coinCount, 100, 45);
    
  }
}


// draws the heart counter
void drawHearts(){
  if(health >= 1){ 
    tint(0);   image(heart, width - 47, 53, 45, 42);
    tint(255); image(heart, width - 50, 50, 45, 42);
  }
  if(health >= 2){ 
    tint(0);   image(heart, width - 97, 53, 45, 42);
    tint(255); image(heart, width - 100, 50, 45, 42); 
  }
  if(health >= 3){ 
    tint(0);   image(heart, width - 147, 53, 45, 42); 
    tint(255); image(heart, width - 150, 50, 45, 42);
  } 
}


/* adjusts the tint for day/night */
void adjustTint(){
  if(tintDecreasing){
    rTint = rTint - 0.06;
    gTint = gTint - 0.06;
    bTint = bTint - 0.04;
  }
  else if (!tintDecreasing && rTint < 250){
    rTint = rTint + 0.06;
    gTint = gTint + 0.06;
    bTint = bTint + 0.04;
  }
  if(bTint < 125){ tintDecreasing = false; }
  else if (rTint > 250) { tintDecreasing = true; }
}



void initializeMusic(){
  path = sketchPath("media/music/startMusic.mp3");
  startMusic = new SoundFile(this, path);
  path = sketchPath("media/music/coinSound1.mp3");
  coinSound1 = new SoundFile(this, path);
  path = sketchPath("media/music/coinSound2.mp3");
  coinSound2 = new SoundFile(this, path);
  path = sketchPath("media/music/rockSound1.mp3");
  rockSound1 = new SoundFile(this, path);
  path = sketchPath("media/music/runSound1.mp3");
  runSound1 = new SoundFile(this, path);
  path = sketchPath("media/music/potionSound.mp3");
  potionSound = new SoundFile(this, path);
  startMusic.loop();
}


/* initializing images and start page */
void initializeImages(){
  bgImage = loadImage("media/background/background3.png");
  bgImage2 = loadImage("media/background/background5.png");
  coinCounter = loadImage("media/coins/coin0.png");
  heart = loadImage("media/coins/heart2.png");
}


void initializeStart(){
  startFont = createFont("media/upheavtt.ttf", 32);
  startFont2 = createFont("media/second.ttf", 32);
  startPage = new Start(2, 30, startFont, startFont2);
}


void restartGame(){
  if(deathDone == true){ 
    if(level == 3 && coinCount > highScore){ 
      highScore = coinCount; // sets the new highscore as the highest coin count in level three
      highScores[0] = str(highScore);
      saveStrings("highScores.txt", highScores);
    }
    startGame = false;
    level = 1; 
    tintDecreasing = true;
    rTint = 255;
    gTint = 255;
    bTint = 255;
    drag = 20;
  }
  else{ level++; }
  health = 3;
  coinCount = 0;
  startText = true;
  hurtAnimation = false;
  deathDone = false;
  deathAnimation = false;
  runningSound = false;
  wonGame = false;
  rocks.clear();
  coins.clear();
  potions.clear();
  warnings.clear();
  pinky.resetStates();
  if(level > 2){ drag = 15; }
}



void mousePressed(){
  if(startGame == false) { startGame = true; }       // start the game
  else if(startGame == true) { startText = false; }  // if the game has already started, and the mouse is pressed, then the text will disappear
  if(startText == false && deathDone == true) { restartGame(); } // if deathdone, then restart!
  if(wonGame == true) { restartGame(); }
  
}





// displays all the text aahhh
void displayDeathText(){
    textSize(60);
    fill(0);           text("UH OH! YOU DIED.", width/2 + 3, height/2 - 30);
    fill(244,137,246); text("UH OH! YOU DIED.", width/2, height/2 - 33);
    textSize(25);
    fill(0);           text("** PRESS SCREEN TO RESTART. **", width/2 + 3, height/2 + 10);
    fill(255);         text("** PRESS SCREEN TO RESTART. **", width/2, height/2 - 3 + 10);
}

void displayWinText(){
    textSize(60);
    fill(0);           text("WOOHOO! YOU DID IT.", width/2 + 3, height/2 - 30);
    fill(244,137,246); text("WOOHOO! YOU DID IT.", width/2, height/2 - 33);
    textSize(25);
    fill(0);           text("** PRESS SCREEN TO CONTINUE. **", width/2 + 3, height/2 + 10);
    fill(255);         text("** PRESS SCREEN TO CONTINUE. **", width/2, height/2 - 3 + 10);
}

void displayStartText(){
    textFont(startFont);
    if(level == 1){
      textSize(40);
      fill(0);           text("HI THERE!", width/2 + 3, height/6);
      fill(244,137,246); text("HI THERE!", width/2, height/6 - 3);
      textSize(30);
      fill(0);   text("IT'S RAINING MONEY TODAY (:", width/2 + 3, height/6 + 33);
      fill(255); text("IT'S RAINING MONEY TODAY (:", width/2, height/6 + 30);
      fill(0);   text("COLLECT THE COINS", width/2 + 3, height/6 + 63);
      fill(255); text("COLLECT THE COINS", width/2, height/6 + 60);
      fill(0);   text("BUT WATCH OUT FOR THE ROCKS!", width/2 + 3, height/6 + 93);
      fill(255); text("BUT WATCH OUT FOR THE ROCKS!", width/2, height/6 + 90);
      textSize(25);
      fill(0);   text("LEVEL ONE: COLLECT 15 COINS.", width/2 + 2, height/6 + 492);
      fill(244,137,246); text("LEVEL ONE: COLLECT 15 COINS.", width/2, height/6 + 490);
      textSize(25);
      fill(0);   text("** PRESS SCREEN FOR ROCKS! **", width/2 + 2, height/6 + 522);
      fill(255); text("** PRESS SCREEN FOR ROCKS! **", width/2, height/6 + 520);
    }
    else if (level == 2){
      fill(0);           text("WOAH THAT WAS CLOSE!", width/2 + 3, height/6);
      fill(244,137,246); text("WOAH THAT WAS CLOSE!", width/2, height/6 - 3);
      textSize(30);
      fill(0);   text("BUT BE CAREFUL NOW,", width/2 + 3, height/6 + 33);
      fill(255); text("BUT BE CAREFUL NOW,", width/2, height/6 + 30);
      fill(0);   text("THERE ARE FASTER ROCKS COMING!", width/2 + 3, height/6 + 63);
      fill(255); text("THERE ARE FASTER ROCKS COMING!", width/2, height/6 + 60);
      fill(0);   text("LOOK OUT FOR THE WARNING SIGNS.", width/2 + 3, height/6 + 93);
      fill(255); text("LOOK OUT FOR THE WARNING SIGNS.", width/2, height/6 + 90);
      textSize(25);
      fill(0);   text("LEVEL TWO: COLLECT 20 COINS.", width/2 + 2, height/6 + 492);
      fill(244,137,246); text("LEVEL TWO: COLLECT 20 COINS.", width/2, height/6 + 490);
      textSize(25);
      fill(0);   text("** PRESS SCREEN FOR ROCKS! **", width/2 + 2, height/6 + 522);
      fill(255); text("** PRESS SCREEN FOR ROCKS! **", width/2, height/6 + 520);
    }
    else if (level == 3){
      fill(0);           text("YEAH!!!", width/2 + 3, height/6);
      fill(244,137,246); text("YEAH!!!", width/2, height/6 - 3);
      textSize(30);
      fill(0);   text("IT'S PRETTY HARD TO SEE THE", width/2 + 3, height/6 + 33);
      fill(255); text("IT'S PRETTY HARD TO SEE THE", width/2, height/6 + 30);
      fill(0);   text("WARNINGS AT NIGHT, HUH?", width/2 + 3, height/6 + 63);
      fill(255); text("WARNINGS AT NIGHT, HUH?", width/2, height/6 + 60);
      fill(0);   text("MMM, I THINK THERE'S", width/2 + 3, height/6 + 123);
      fill(255); text("MMM, I THINK THERE'S", width/2, height/6 + 120);
      fill(0);   text("SOMETHING ELSE FALLING...", width/2 + 3, height/6 + 153);
      fill(255); text("SOMETHING ELSE FALLING...", width/2, height/6 + 150);
      fill(0);   text("ARE THOSE... POTIONS?!", width/2 + 3, height/6 + 183);
      fill(255); text("ARE THOSE... POTIONS?", width/2, height/6 + 180);
      textSize(25);
      fill(0);   text("LEVEL THREE: SURVIVE AS LONG AS YOU CAN.", width/2 + 2, height/6 + 492);
      fill(244,137,246); text("LEVEL THREE: SURVIVE AS LONG AS YOU CAN.", width/2, height/6 + 490);
      textSize(25);
      fill(0);   text("** PRESS SCREEN FOR ROCKS! **", width/2 + 2, height/6 + 522);
      fill(255); text("** PRESS SCREEN FOR ROCKS! **", width/2, height/6 + 520);
    }
}

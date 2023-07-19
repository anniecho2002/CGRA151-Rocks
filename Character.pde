class Character{
  HashMap<String, State> states = new HashMap<String, State>();
  String name;
  
  Character(String name){
    this.name = name;
  }
  
  void loadStates(){
    states.put("idle", new State("idle", 4, 8, 0.75));
    states.put("walk", new State("walk", 6, 5, 0.7));
    states.put("hurt", new State("hurt", 4, 4, 0.75));
    states.put("death", new State("death", 8, 8, 0.75));
  }
  
  
  void drawState(String stateName, boolean flip, float x, float y){
    if (flip){ states.get(stateName).displayStateFlip(x, y); }
    else { states.get(stateName).displayState(x, y); }
  }
  
  void resetStates(){
    for(State s: states.values()){
      s.reset();
    }
  }
  
  int getWidth(String state){
    return states.get(state).getWidth();
  }
  
  boolean hitCoin(Coin c, float x, float y){
    if (dist(x, y, c.getX(), c.getY()) < c.getSize()/2 + 40){ return true; }
    return false;
  }
  
  boolean hitRock(Rock r, float x, float y){
    if (dist(x, y, r.getX(), r.getY()) < r.getSize()/2 + 40){ return true; }
    return false;
  }
  
  boolean hitPotion(Potion p, float x, float y){
    if (dist(x, y, p.getX(), p.getY()) < p.getSize()/2 + 40){ return true; }
    return false;
  }
  
  
  
}

import java.util.ArrayList;

int bulletTime = 0;
int moveTime = 0;

Tile[][] tiles; //represents board

color backgroundColor = color(122, 78, 209);

ArrayList<Snake> snakes = new ArrayList<Snake>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<FoodPellet> food = new ArrayList<FoodPellet>;
int maxFood;

Gun bigGun = new Gun();


int findDirection(int startX,int startY, int endX, int endY){

  ArrayList<Tile> open = new ArrayList<Tile>; //used for A*
  ArrayList<Tile> closed = new ArrayList<Tile>; //used for A*
  
  open.add(tiles[startY][startX]);
  
  //tiles[startY][startX].changeList(true);
  while(!open.isEmpty()){
    
    for(int i=0;i<open.size();i++){ //set f-values
      int gVal = calcManhattanDistance(startX,startY,open.get(i).getXcor(),open.get(i).getYcor());
      int hVal = calcManhattanDistance(open.get(i).getXcor(),open.get(i).getYcor(),endX,endY);
      int fVal = gVal + hVal;
      open.get(i).setFval(fVal);
    } 
    
    //find unit with lowest f-value
    int minDist = Integer.MAX_INT;
    int minDistIndex = 0;
    for(int i=0;i<open.size();i++){
      if(open.get(i).getFval() < minDist){
        minDist = open.get(i).getFval();
        minDistIndex = i;
      }
    }
    
    Tile goldenTile = open.get(minDistIndex); //currently considering this tile
    
    if(goldenTile.equals(Tile[endY][endX])){
      break; //***FIX
    }
    else{
      closed.add(0,open.remove(goldenTile));
      
    
    
    
    open.add(0,tmp);
    if(!tiles[startY+1][startX].isSnake() && !tiles[startY+1][startX].isList()){
      open.add(tiles[startY+1][startX]);
      tiles[startY+1][startX].changeList(true);
    }
    if(!tiles[startY-1][startX].isSnake() && !tiles[startY-1][startX].isList()){
      open.add(tiles[startY-1][startX]);
      tiles[startY-1][startX].changeList(true);
    }
    if(!tiles[startY][startX+1].isSnake() && !tiles[startY][startX+1].isList()){
      open.add(tiles[startY][startX+1]);
      tiles[startY][startX+1].changeList(true);
    }
    if(!tiles[startY][startX-1].isSnake() && !tiles[startY][startX-1].isList()){
      open.add(tiles[startY][startX-1]);
      tiles[startY][startX-1].changeList(true);
    }
    
    closed.add(0,open.remove(0));
   
    
    //set parent of unit
    closed.get(0).setParexnt(open.get(minDistIndex));
    //remove unit with lowest f-value from open list and add to closed list
    closed.add(open.remove(minDistIndex));
    
    
    
    
  }
}



int calcManhattanDistance(int startX,int startY,int finX,int finY) { //calculates manhattan distance- helps A*
  return abs(finX - startX) + abs(finY - startY); 
}

void setup() {
  bulletTime = millis();
  moveTime = millis();
  
  size(500, 640);
  background(backgroundColor);
  snakes.add(new Snake(5));
  
  tiles = new Tile[50][60];
  
  for(int i=0;i<tiles.length;i++){ //sets up each tile
    for(int j=0;i<tiles[0].length;j++){
      tiles[i][j] = new Tile(i*10,j*10);
    }
  }
}

void draw() {

  noStroke();
  fill(0);
  rectMode(CORNERS);
  rect(0, height - 40, width, height);

  if(snakes.size()==1){ maxFood = 1; } //alters max food
  else if(snakes.size()==2){ maxFood = 2; }
  else{ maxFood = 3; }

  if(food.size() < maxFood){
    while(food.size() < maxFood){
      food.add(newFood()); //adds food until max reached
    }
  }

  checkBullet(); //checks bullets and collides if necessary
  bulletMovement(); //removes bullets that are off the board and displays remaining bullets
  snakeMovement(); //moves snake in 500ms intervals, then displays

  bigGun.display();
  
  for(int i=0;i<food.size();i++){
    food.display();
  }
}

void snakeMovement() {
  for (int i = 0; i < snakes.size (); i++) {
    Snake snake = snakes.get(i);
    if (millis() - moveTime >= 500) {
      snake.move();
      moveTime = millis();
    }
    snake.display();
  }
}

void bulletMovement() {
  tiles[bullets.getYcor()][bullets.getXcor()].changeBullet(false); //remove bullet from previous position tile
  for (int i=0; i<bullets.size(); i++) {
    if (bullets.get(i).getYcor() < 0) {
      bullets.remove(i);
    } else {
      bullets.get(i).flying();
      tiles[bullets.getYcor()][bullets.getXcor()].changeBullet(true); //add bullet to new position tile
      bullets.get(i).display();
    }
  }
}

void newFood() {
  int randX = random(50);
  int randY = random(60);
  Tile tmp = tiles[randY][randX];
  
  while(tmp.isSnake() || tmp.isFood()){
    randX = random(50);
    randY = random(60);
    tmp = tiles[randY][randX];
  }
  
  tiles[randY][randX].changeFood(true);
  
  food.add(new FoodPellet(randX,randY));
}

void checkBullet() { //checks for collisions
  for (int i=0;i<bullets.size();i++){
    int xcor = bullets.get(i).getXcor();
    int ycor = bullets.get(i).getYcor();
    if(tiles[ycor][xcor].isSnake()){
      for(int a=0;a<snakes.size();a++){
        for(int b=0;b<snakes.get(a).getUnits().size();b++){
          if(snakes.get(a).getUnits().get(b).getXcor() == xcor && snakes.get(b).getUnits().get(b).getYcor() == ycor){
            snakes.get(a).getUnits().get(b).die();
            snakes.remove(j); //add this!!
            tiles[ycor][xcor].changeSnake(false);
            tiles[ycor][xcor].changeBullet(false);
          }
        }
      }
    }
  }
}


void keyPressed() {
  if (key == CODED || key == 'a' || key == 'd') {
    if (keyCode == RIGHT || key == 'd') {
      bigGun.moveRight();
      bigGun.display();
    } else if (keyCode == LEFT || key == 'a') {
      bigGun.moveLeft();
      bigGun.display();
    }
  } else if (key == ' ') {
    if (millis() - bulletTime >= 250) {
      Bullet bigBullet = new Bullet(bigGun.getXcor(), bigGun.getYcor() - 20);
      bullets.add(bigBullet);
      bulletTime = millis();
    }
  }
}

Tile getClosestFood(Tile n) {
  int closestDist = Integer.MAX_INT;
  int xcor, ycor;
     
  for (int i=0;i<tiles.length;i++){
    for (int j=0;j<tiles[0].length;j++){
      if(tiles[i][j].isFood()){
         if(abs(n.getXcor()-j) + abs(n.getYcor()-i) < closestDist){
           closestDist = abs(n.getXcor()-j) + abs(n.getYcor()-i);
           xcor = j;
           ycor = i;
         }
      }
    }
  }
  return tiles[ycor][xcor];
}

//1=north, 2=east, 3=south, 4=west
int AStarSearching(Tile a, Tile b){
  

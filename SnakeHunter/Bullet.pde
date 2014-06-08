class Bullet {
  float xcor, ycor;
  color backgroundColor = color(122,78,209);
  float spd; //you only need one- vertical
  color col = color(62);
  
  //Bullet() { } //?
  
  Bullet(float xcor, float ycor) {
    spd = 10;
    this.xcor = xcor;
    this.ycor = ycor;
  }
  
  void display() {
    stroke(255);
    fill(col);
    rectMode(CENTER);
    rect(xcor*10, ycor*10, 10, 10);
  }
  
  void flying() {
    die();
    ycor -= spd;
  }
  
  void die(){
    rectMode(CENTER);
    stroke(backgroundColor);
    fill(backgroundColor);
    rect(xcor*10,ycor*10,10,10);
  }
  
  float getXcor() { return xcor; }
  float getYcor() { return ycor; }
   
}

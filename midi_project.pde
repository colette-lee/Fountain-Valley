import megamu.mesh.*;

import themidibus.*;
import java.util.*;


MidiBus myBus;
int n = 6;
float note1;
int frame;
//<NoteParticle> particles;
Voronoi myVoronoi;
int numPoints;
boolean drop = false;
float[][]points;
float[][]newPointsArray;
int c;
int thresh;
boolean black = true;
boolean chan3 = false;

float m = 0;
int pNotes=0;
boolean piano;
int melodyNote=0;
int shade;
boolean vocals;
boolean vor;
Key[] keys;
Map<Integer,Integer> keyMap;

ArrayList<NoteTriangle> trigs;

void setup(){
  size(1280,720, P3D);
  background(0);
  MidiBus.list();
  myBus = new MidiBus(this, 1,1);
  //particles = new ArrayList<NoteParticle>();
  fill(255);
  c = 0;
  piano = true;
  thresh=40;
  shade = 80;
  vocals = false;
  vor=false;
  frameRate(50);
  
  keyMap = new HashMap<Integer,Integer>();
  keyMap.put(69,0);
  keyMap.put(65,1);
  keyMap.put(64,2);
  keyMap.put(62,3);
  keyMap.put(60,4);
  keyMap.put(57,5);
  keyMap.put(55,6);
  keyMap.put(53,7);
  keyMap.put(50,8);
  keyMap.put(48,9);
  keyMap.put(46,10);
  keyMap.put(45,11);
  
  keys = new Key[12];
  for(int i=0; i<12; i++){
    keys[i] = new Key(i);
  }
  
  trigs = new ArrayList<NoteTriangle>();
  
  numPoints = 2;
  points = new float[numPoints][2];

  points[0][0] = width*3/4;
  points[0][1] = height/4;
  points[1][0] = width/4;
  points[1][1] = height*3/4;
  

  
  

  
  myVoronoi = new Voronoi( points );
  //fill(0);
  
  rectMode(CENTER);
}

void draw(){
  background(0);
  println(frameRate);

  if(vocals){
    movePoints(newPointsArray);
  }

  if(drop) {
    movePoints(newPointsArray);
  }
  
  myVoronoi = new Voronoi( points );
  
  if(chan3)
    circles(points, thresh);
  
  
  MPolygon[] myRegions = myVoronoi.getRegions();

  for(int i=0; i<myRegions.length; i++)
  {
    // an array of points
    //float[][] regionCoordinates = myRegions[i].getCoords();
  
    //fill(0,0,0);
    if(black){
      fill(0);
      stroke(255);
    } else {
      fill(255);
      stroke(0);
    }
    if(melodyNote!=0){
      
      int poly = melodyNote%numPoints;
      if(i%3 == poly%3){

        if(black){
          fill(shade);
          //stroke(0);
        } else {
          fill(0);
          //stroke(255);
        }
      }
    }
    if(vor){

      myRegions[i].draw(this);
    }// draw this shape
  }
  if(melodyNote!=0)
    shade--;
  

  
 
    //stroke(255);

    strokeWeight(4);

    if(piano){
      push();
      translate(width/2,0);
      for(int i=0; i<12; i++){
        fill(255);
        stroke(0);
        keys[i].display();
      }
      pop();
    }
    
    if(!drop){
      push();
      translate(width/2,height/2);
      for(int i=0; i<trigs.size();i++){
        trigs.get(i).display();
      }
      
      pop();
    }


}

void movePoints(float[][] newPositions){
  for(int i=0; i< numPoints; i++){
    float newX = newPositions[i][0];
    float newY = newPositions[i][1];
    float speedX = (newX-points[i][0])/10;
    float speedY = (newY-points[i][1])/10;
    points[i][0]+=speedX;
    points[i][1] += speedY;
  }
}

void circles(float[][] points, int thresh){
  for(int i=0; i<numPoints; i++){
    noFill();
    float s = map(c%thresh, 0,thresh,0,PI);
    float r = map(-cos(s), -1,1,0,15);
    if(thresh==25){
      r = map(-cos(s),-1,1,4,20);
      strokeWeight(r);
    } else {
      circle(points[i][0],points[i][1],r);
    }
    
    //println(r);
 
  }
  if(c<thresh)
    c++;
}


void noteOn(Note note){

  if(note.channel==0){
    
    //print(note.name()+" ");
    //println(note.pitch());
    int keyNum = keyMap.get(note.pitch());
    keys[keyNum].pressed();
      
  }
  if(note.channel==5){
    //piano=false;
    if(note.pitch()==60){
      trigs.add(new NoteTriangle());
    } 
    if (note.pitch()==62){
      vocals = true;
      vor=true;
      piano = false;
      newPointsArray = new float[numPoints][2];
      newPointsArray[0][0] = width/4;
      newPointsArray[0][1] = height/4;
      newPointsArray[1][0] = width*3/4;
      newPointsArray[1][1] = height*3/4;

    }
      if (note.pitch()==63){
      vocals = true;
      vor=true;
      piano = false;
      newPointsArray = new float[numPoints][2];
      newPointsArray[0][0] = width/4;
      newPointsArray[0][1] = height*3/4;
      newPointsArray[1][0] = width*3/4;
      newPointsArray[1][1] = height/4;

    }
    
     if (note.pitch()==64){
      vocals = true;
      vor=true;
      piano = false;
      newPointsArray = new float[numPoints][2];
      newPointsArray[1][0] = width/4;
      newPointsArray[1][1] = height/4;
      newPointsArray[0][0] = width*3/4;
      newPointsArray[0][1] = height*3/4;

    }
    
    if (note.pitch()==65){
      vocals = true;
      vor=true;
      piano = false;
      newPointsArray = new float[numPoints][2];
      newPointsArray[1][0] = width/4;
      newPointsArray[1][1] = height*3/4;
      newPointsArray[0][0] = width*3/4;
      newPointsArray[0][1] = height/4;

    }
    
    if(note.pitch()==61){
      vocals = false;
    }
    
  }
  if(note.channel==1&&note.pitch()==60){
    piano=false;

    float[][] newPoints = new float[numPoints+1][2];
    for(int i=0; i< numPoints; i++){
      newPoints[i][0] = points[i][0];
      newPoints[i][1] = points[i][1];
    }
    newPoints[numPoints][0] = random(width);
    newPoints[numPoints][1] = random(height);
    
    points = newPoints;
    numPoints++;


  
    myVoronoi = new Voronoi( points );
    
    

  }
  if(note.channel()==1 && note.pitch()==62){
    if(black){
      fill(255);
      stroke(0);
      black = false;
    } else {
      fill(0);
      stroke(255);
      black = true;
    }
  }
   if(note.channel()==2){
      drop=true;
      newPointsArray = new float[numPoints][2];
      for(int i=0; i< numPoints; i++){
        newPointsArray[i][0] = random(width);
        newPointsArray[i][1] = random(height);
      }
    }
    
    if(note.channel()==3){
      
      chan3 = true;
      if(note.pitch()==62){
        thresh = 25;
      } else {
        thresh = 40;
      }
      c = 0;
    }
  //println(particles.size());
  if(note.channel()==4){
    println(note.pitch());
    melodyNote = note.pitch();
    shade = 120;
  }
}

void noteOff(Note note){
  if(note.channel()==4){
    melodyNote = 0;
  }
}

class Key {
  int n;
  float w;
  float yPos;
  float speed;
  float maxW;
  public Key(int n){
    this.n = n;
    this.w = 0;
    this.yPos = (height/24)+n*height/12;
    this.speed = random(4,7);
    this.maxW = floor(random(width*0.7,width*0.9));
  }
  
  void pressed(){
    this.w = this.maxW;
  }
  
  void display(){
    
    if(this.w>this.speed){
      this.w-=this.speed;
    } else {
      this.w = 0;
    }
    rect(0,this.yPos,this.w,height/12);
  }
}

class NoteTriangle{
  float size;
  float speed;
  float angle;
  float angleSpeed;
  public NoteTriangle(){
    size = 0;
    speed = 5;
    angle = 0;
    angleSpeed = 0.01;
    
  }
  void display(){
    size += speed;
    angle += angleSpeed;
    float x1 = size*cos(angle);
    float y1 = size*sin(angle);
    float x2 = size*cos(angle + (2*PI/3));
    float y2 = size*sin(angle + (2*PI/3));
    float x3 = size*cos(angle + (4*PI/3));
    float y3 = size*sin(angle + (4*PI/3));
    triangle(x1,y1,x2,y2,x3,y3);
  
    
    
  }
}

//class NoteParticle{
//  Note note;
//  float xPos;
//  float yPos;
//  float incr;
//  float len;
//  float xSpeed;
//  float ySpeed;
//  public NoteParticle(Note note, int t){
//    this.note = note;
//    //this.xPos = map(note.pitch()%12,0,12,0,width);
//    //this.yPos = map(t%5,0,5,0,height);
//    this.xPos = width/2;
//    this.yPos = height/2;
//    this.incr=0;
//    this.len = note.ticks();
//    this.xSpeed = random(-3,3);
//    this.ySpeed = random(-2,2);
    
//  }
//  void display(){
//    this.xPos += this.xSpeed;
//    this.yPos += this.ySpeed;
//    circle(this.xPos,this.yPos,30);
//    incr++;
//  }
//}


import peasy.*;
PeasyCam cam;

import picking.*;
Picker picker;

ChildApplet child;

import controlP5.*;
ControlP5 cp5;

//print out current mutation value
//print UI mutation range

//allow 1-14 ports for connection - slider 7%-100%

//constrain to 10, 20 cells
//UI

//ray trace exposed surface area

//look for growth that shares less neighboring faces

//should crossover be more random?
//build bridge between islands
//3d intuive exlporation UI

//tunnels

//3D array arranged in fitness level
//user selection of winners


//fitness ranges
int minCells=10;
int maxCells=20;

Population population;  // Population


//float mutationRate = 0.00015;
float mutationRate = 0.00005;

//float mutationRate = 0.000015;

//float mutationRate = 0.00000005;

int margin=75;

int xCount=3; //clusters per row in population
//int populationSize=xCount*xCount;//make square rootable
int populationSize=100;//

float cellR=30; //cell radius
int nCells=8; //nunmber of cells in cluster row and column
boolean runOptimize=false;

import nervoussystem.obj.*;
boolean saveOBJ=false;
int currentCluster=-1;

float  s1f, s2f,  s4f;
int s3i;

int clusterSize=20;
boolean didCullIslands=true;

int nConnections=4;



void settings() {
  size(900, 900, P3D);
}

void setup() {

  picker = new Picker(this);

  cam = new PeasyCam(this, 900);
  cam.setWheelScale(.1); // 1.0 by default

  population = new Population(mutationRate, populationSize);

  surface.setTitle("Main");
  child = new ChildApplet();

  textMode(SHAPE);
}




void draw() {
  cam.getState().apply(picker.getBuffer());

  colorMode(RGB, 255);

  background(200);
  //lights();
  //population.testFitness();
  //don't include in peasycam rotation and zoom
  //cam.beginHUD();
  ////drawGUI();

  //cam.endHUD(); // always!

  //lighting messes up picker
  //directionalLight(126, 126, 126, 1.5, 1, -1);
  //ambientLight(150, 150, 150);

  if (runOptimize) {

    population.selection();
    population.reproduction();
    //if (frameCount%100==0) population.cullSmallIslands();
    //if (frameCount%100==0) population.adjustClusterSize();
    population.cullIslands();
    population.testFitness(); //end with test fitness to display current fitness


    //population.testFitness();
  } else if (didCullIslands==false) {
    population.cullIslands();
    population.testFitness();
    didCullIslands=true;
  }


  //if (!saveOBJ) {
  //  population.live();
  //}
  if (saveOBJ && currentCluster>=0) {
    int cellCount=population.clusters[currentCluster].nVisible;
    float fit=population.clusters[currentCluster].fitness;

    String desktopPath = System.getProperty("user.home") + "/Desktop/"+cellCount+"-"+fit+".obj";

    beginRecord("nervoussystem.obj.OBJExport", desktopPath);
    population.clusters[currentCluster].draw();
    endRecord();
    saveOBJ = false;
  } else {
    population.live();
  }
}

void keyPressed() {

  if (keyCode == ENTER ) {

    runOptimize=!runOptimize;
    didCullIslands=false;
  } else if (key == 'm' ) { //force drastic mutation
    population.mutate(.2);
  } else if (key == 'g' ) {
    population.grow();
  } else if (key == 'f' ) {
    population.testFitness();
  } else if (key == 'c' ) {
    population.cullIslands();
  } else if (key == 'r' ) {
    setup();
    runOptimize=false;
  } else if (key == 's' ) {
    saveOBJ=true;
  }
  //else if (key == 'i' ) {
  //  population.cullIslands();
  //}
}

//void mouseMoved() {
//  int id= picker.get(mouseX, mouseY);

//  if (id >= 0 && id<population.clusters.length) {
//    population.clusters[id].showFitness=true;
//  } else {
//    //population.clusters[id].showFitness=false;
//  }
//}
void mouseReleased() {
  int id = picker.get(mouseX, mouseY);
  if (id >= 0 && id<population.clusters.length) {
    //println(id);
    cam.lookAt(population.clusters[id].pos.x+nCells*cellR/sqrt(2)/2, population.clusters[id].pos.y+nCells*cellR/sqrt(2)/2, population.clusters[id].pos.z+nCells*cellR/sqrt(2)/2, 320, 400);
  }

  //highlight
  for (int i=0; i<population.clusters.length; i++) {
    if (id ==i) {
      //println(id);
      population.clusters[id].setColor(color(255, 0, 0));
      population.clusters[id].showFitness=true;

      currentCluster=id;
      return;
    } else {
      population.clusters[i].setColor(color(255));
      population.clusters[i].showFitness=false;

      currentCluster=-1;
    }
  }
}

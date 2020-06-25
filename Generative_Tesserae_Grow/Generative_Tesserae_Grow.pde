
import peasy.*;
PeasyCam cam;

import picking.*;
Picker picker;

ChildApplet child;

import controlP5.*;

ControlP5 cp5;

//track cell neighbors. for counting and for constraining growth
//allow 1-14 ports for connection


//constrain to 10, 20 cells
//UI
//ray trace exposed surface area

//sliders for fitness criteria
//branch length fitness
//look for growth that shares less neighboring faces

//print out current mutation value
//print UI mutation range

//should crossover be more random?

//survey islands and delete all but main island
//build bridge between islands

//increase population size. hide in background. display sub matrix

//mouse hover to show fitness in UI

//3d intuive exlporation UI



//filled out ports, all hex ports

//tunnels

//3D array arranged in fitness level
//user selection of winners


//fitness ranges
int minCells=10;
int maxCells=20;

Population population;  // Population


float mutationRate = 0.00015;

//float mutationRate = 0.00000005;

int margin=75;

int xCount=3; //clusters per row in population
int populationSize=xCount*xCount;//make square rootable

float cellR=30; //cell radius
int nCells=8; //nunmber of cells in cluster row and column
boolean runOptimize=false;

import nervoussystem.obj.*;
boolean saveOBJ=false;
int currentCluster=-1;

float s1f,s2f;

void settings() {
  size(900, 900, P3D);
}

void setup() {

  picker = new Picker(this);

  cam = new PeasyCam(this, 900);
  cam.setWheelScale(.1); // 1.0 by default

  population = new Population(mutationRate, populationSize);

  surface.setTitle("Main sketch");
  child = new ChildApplet();
}




void draw() {
  cam.getState().apply(picker.getBuffer());

  colorMode(RGB, 255);

  background(200);
  lights();
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
    population.cullIslands();
  }

  population.testFitness();

  //if (!saveOBJ) {
  //  population.live();
  //}
  if (saveOBJ && currentCluster>=0) {
    int cellCount=population.clusters[currentCluster].nVisible;
    float fit=population.clusters[currentCluster].fitness;

    String desktopPath = System.getProperty("user.home") + "/Desktop/"+cellCount+"-"+fit+".obj";

    beginRaw("nervoussystem.obj.OBJExport", desktopPath);
    population.clusters[currentCluster].draw();
    endRaw();
    saveOBJ = false;
  } else {
    population.live();
  }
  


}

void keyPressed() {

  if (keyCode == ENTER ) {
    runOptimize=!runOptimize;
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
}


void mouseReleased() {
  int id = picker.get(mouseX, mouseY);
  if (id >= 0 && id<population.clusters.length) {
    //println(id);
    cam.lookAt(population.clusters[id].pos.x+nCells*cellR/sqrt(2)/2, population.clusters[id].pos.y+nCells*cellR/sqrt(2)/2, population.clusters[id].pos.z, 300, 500);
  }

  //highlight
  for (int i=0; i<population.clusters.length; i++) {
    if (id ==i) {
      //println(id);
      population.clusters[id].setColor(color(255, 0, 0));
      currentCluster=id;
      return;
    } else {
      population.clusters[i].setColor(color(255));
      currentCluster=-1;
    }
  }
}

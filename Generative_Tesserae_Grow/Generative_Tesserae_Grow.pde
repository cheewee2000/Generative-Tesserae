import peasy.*;
PeasyCam cam;

import picking.*;
Picker picker;

//generate space packing
//each fish in population is a space packing with 2D arraylist of remaining cells
//cells are truncated octahedrons ( numbered i,j)

//GA 
//remove cells with n-exposed faces randomly
//analyze  
//calculate explosed faces (not sharing)
//breed

//truncated octa
//constrain to 10, 20 cells
//save to STL, UI
//ray trace exposed surface area

//sliders for fitness criteria

//branch length fitness

//filled out ports, all hex ports

//tunnels


//3D array arranged in fitness level
//user selection of winners




Population population;  // Population
float mutationRate = 0.00005;
int margin=75;

int xCount=3; //clusters per row in population
int populationSize=xCount*xCount;//make square rootable

float cellR=30; //cell radius
int nCells=8; //nunmber of cells in cluster row and column
boolean runOptimize=false;

void setup() {
  size(900, 900, P3D);

  picker = new Picker(this);

  cam = new PeasyCam(this, 900);
  cam.setWheelScale(.1); // 1.0 by default

  population = new Population(mutationRate, populationSize);
}

void draw() {
  cam.getState().apply(picker.getBuffer());

  colorMode(RGB, 255);

  background(200);
  lights();
  //population.testFitness();
  
  //lighting messes up picker
  //directionalLight(126, 126, 126, 1.5, 1, -1);
  //ambientLight(150, 150, 150);



  if (runOptimize) {

    population.selection();
    population.reproduction();
    population.cullIslands();
  }

  population.testFitness();

  population.live();
}

void keyPressed() {

  if (keyCode == ENTER ) {
    runOptimize=!runOptimize;
  }

  if (key == 'm' ) { //force drastic mutation
    population.mutate(.2);
  }

  if (key == 'g' ) {
    population.grow();
  }

  if (key == 'f' ) {
    population.testFitness();
  }

  if (key == 'c' ) {
    population.cullIslands();
  }

  if (key == 'r' ) {
    setup();
    runOptimize=false;
  }
}


void mouseReleased() {
  int id = picker.get(mouseX, mouseY);
  if (id >= 0 && id<population.clusters.length) {
    println(id);
    cam.lookAt(population.clusters[id].pos.x+nCells*cellR/sqrt(2)/2, population.clusters[id].pos.y+nCells*cellR/sqrt(2)/2, population.clusters[id].pos.z, 300, 500);
  }
}


void mouseMoved() {

  int id = picker.get(mouseX, mouseY);
  for (int i=0; i<population.clusters.length; i++) {
    if (id ==i) {
      //println(id);
      population.clusters[id].setColor(color(255, 0, 0));
    } else {
      population.clusters[i].setColor(color(255));
      //println("setcolor white");
    }
  }
}

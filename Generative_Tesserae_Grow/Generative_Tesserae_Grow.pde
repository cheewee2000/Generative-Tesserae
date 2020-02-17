import peasy.*;
PeasyCam cam;

//generate space packing
//each fish in population is a space packing with 2D arraylist of remaining cells
//cells are truncated octahedrons ( numbered i,j)

//GA 
//remove cells with n-exposed faces randomly
//analyze  
//calculate explosed faces (not sharing)
//breed

//truncated octa
//branch length fitness
//filled out ports, all hex ports

//3D arrat arranged in fitness level
//user selection of winners



Population population;  // Population
float mutationRate = 0.00005;
int margin=25;

int xCount=6; //clusters per row in population
int populationSize=xCount*xCount;//make square rootable

float cellR=8; //cell radius
int nCells=12; //nunmber of cells in cluster row and column
boolean runOptimize=false;

void setup() {
  size(900, 900, P3D);
  cam = new PeasyCam(this, 900);
  cam.setWheelScale(.1); // 1.0 by default

  population = new Population(mutationRate, populationSize);
}

void draw() {
  colorMode(RGB, 255);

  background(200);
  lights();
  //population.testFitness();

  if (runOptimize) {

    population.selection();
    population.reproduction();
    population.cullIslands();
  }

  population.testFitness();

  population.live();


  //population.testFitness();
  //population.selection();
  //population.reproduction();
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
  }
}

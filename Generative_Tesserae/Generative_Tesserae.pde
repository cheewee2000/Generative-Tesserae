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


int populationSize=25;//make square rootable
Population population;  // Population
float mutationRate = 0.005;
int margin=40;

int xCount=5; //clusters per row in population
float cellR=10; //cell radius
int nCells=8; //nunmber of cells in cluster row and column

void setup() {
  size(900, 900, P3D);
  cam = new PeasyCam(this, 900);
  population = new Population(mutationRate, populationSize);
}

void draw() {
  colorMode(RGB, 255);

  background(200);
  lights();
  population.live();


  population.testFitness();
  population.selection();
  population.reproduction();
}

void keyPressed() {

  if (keyCode == ENTER ) {
    population.testFitness();
    population.selection();
    population.reproduction();
  }

  if (key == 'c' ) {
    population.cullIslands();
  }
}

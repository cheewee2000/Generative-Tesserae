
class Population {

  float mutationRate;          // Mutation rate
  Cluster[] clusters;         // Array to hold the current population
  ArrayList<Cluster> matingPool;    // ArrayList which we will use for our "mating pool"
  int generations;             // Number of generations
  //int xCount=int((width)/(cellR*nCells));

  // Initialize the population
  Population(float m, int num) {
    mutationRate = m;
    clusters = new Cluster[num];
    matingPool = new ArrayList<Cluster>();
    generations = 0;
    //make a new set of creatures


    for (int i = 0; i < clusters.length; i++) {
      int y=(i/xCount);
      PVector pos=new PVector(i%xCount*(width/xCount)-width/2+margin, y*height/xCount - height/2+margin, 0 );

      //PVector pos=new PVector(i*50-width/2, 100, 0 );


      clusters[i] = new Cluster(pos, new DNA());
    }
  }

  void live () {
    // Run every Cluster

    for (int i = 0; i < clusters.length; i++) {
      clusters[i].drawBoundingBox();


      picker.start(i);
      clusters[i].draw();
    }
    picker.stop();


    for (int i = 0; i < clusters.length; i++) {
    }
  }

  void cullIslands() {
    for (int i = 0; i < clusters.length; i++) {
      clusters[i].cullIslands();
    }
  }

  void testFitness() {
    for (int i = 0; i < clusters.length; i++) {
      clusters[i].testFitness();
    }
  }

  // Generate a mating pool
  void selection() {
    // Clear the ArrayList
    matingPool.clear();

    // Calculate total fitness of whole population
    float maxFitness = getMaxFitness();

    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < clusters.length; i++) {
      float fitnessNormal = map(clusters[i].getFitness(), 0, maxFitness, 0, 1);
      int n = (int) (fitnessNormal * 10);  // Arbitrary multiplier
      for (int j = 0; j < n; j++) {
        matingPool.add(clusters[i]);
      }
    }
  }

  // Making the next generation
  void reproduction() {
    if (matingPool.size()>0) 
    {
      // Refill the population with children from the mating pool
      for (int i = 0; i < clusters.length; i++) {
        // Sping the wheel of fortune to pick two parents
        int m = int(random(matingPool.size()));
        int d = int(random(matingPool.size()));
        // Pick two parents
        Cluster mom = matingPool.get(m);
        Cluster dad = matingPool.get(d);
        //Cluster dad = matingPool.get(m);

        // Get their genesgggg
        DNA momgenes = mom.getDNA();
        DNA dadgenes = dad.getDNA();
        // Mate their genes
        DNA child = momgenes.crossover(dadgenes);
        // Mutate their genes
        child.mutate(mutationRate);
        // Fill the new population with the new child
        int y=(i/xCount);
        //PVector pos=new PVector(margin/(xCount)/2+(i*cellR*scale) % (width-margin)+i%xCount*(margin/(xCount)), margin/(xCount)/2+y*cellR*scale + y*(margin/xCount));
        clusters[i] = new Cluster(clusters[i].pos, child);
      }
      generations++;
    }
  }


  void mutate(float _mutationRate) {
    for (int i = 0; i < clusters.length; i++) {
      DNA dna=clusters[i].getDNA();
      dna.mutate(_mutationRate);
    }
  }


  void grow() {
    for (int i = 0; i < clusters.length; i++) {
      DNA dna=clusters[i].getDNA();
      dna.grow();
    }
  }


  // Find highest fintess for the population
  float getMinFitness() {
    float record = 0;
    for (int i = 0; i < clusters.length; i++) {
      if (clusters[i].getFitness() < record) {
        record = clusters[i].getFitness();
      }
    }
    return record;
  }
  // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < clusters.length; i++) {
      if (clusters[i].getFitness() > record) {
        record = clusters[i].getFitness();
      }
    }
    return record;
  }
}


class DNA {
  // The genetic sequence
  Cell[] cells;

  // The maximum strength of the forces
  // Constructor (makes a DNA of random PVectors)
  DNA() {
    int count=0;
    cells = new Cell[nCells*nCells*nCells];
    //setup array of cells
    for (int i=0; i<nCells; i++ ) {
      for (int j=0; j<nCells; j++ ) {
        for (int k=0; k<nCells; k++ ) {
          cells[count] = new Cell( i*cellR, j*cellR, k*cellR) ;
          count++;
        }
      }
    }
    //turn one cell on
    cells[int(nCells/2+nCells*nCells/2+nCells*nCells*nCells/2)].isVisible=true;
  }

  // Constructor #2, creates the instance based on an existing array
  DNA(Cell[] newcells) {
    cells = newcells;
  }

  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  DNA crossover(DNA partner) {
    Cell[] child = new Cell[cells.length];
    // Pick a midpoint
    int crossover = int(random(cells.length));
    //int crossover=cells.length;

    // Take "half" from one and "half" from the other
    for (int i = 0; i < cells.length; i++) {
      if (i > crossover) child[i] = cells[i];
      else               child[i] = partner.cells[i];
    }    
    DNA newcells = new DNA(child);
    return newcells;
  }

  // Based on a mutation probability, picks a new random Vector
  void mutate(float m) {
    for (int i = 0; i < cells.length; i++) {
      if (random(1.0) < m) {
        if (cells[i].hasBeenVisible) {
          cells[i].isVisible=!cells[i].isVisible;
        }
      }
    }
  }



  void grow() {
    //copy cells
    Cell[] tempCells = new Cell[cells.length];
    for (int i = 0; i < cells.length; i++) {
      tempCells[i]=cells[i].clone();
    }

    for (int i = 0; i < cells.length; i++) {
      //grow
      int neighbors [] =new int[90];
      if (cells[i].isVisible) {
        int count=0;
        for (int j = 0; j < cells.length; j++)             
          if (i!=j && dist(cells[i].x, cells[i].y, cells[i].z, cells[j].x, cells[j].y, cells[j].z)<=cellR)
          {
            neighbors[count]=j;
            count++;
          }
        //pick random neighbor
        tempCells[neighbors[int(random(count))]].isVisible=true;
      }
    }

    cells=tempCells;
  }



  float getSurfaceVolumeRatio() {
    float neighborTotal=1;
    for (int i = 0; i < cells.length; i++) {
      //add up neighbor score
      neighborTotal+=cells[i].neighbors;
    }
    println(neighborTotal);

    return cells.length/neighborTotal;
  }




  int countNeighbors(int c) {
    //boolean visible=false;
    cells[c].neighbors=0;

    if (c+1<cells.length) if ( cells[c+1].isVisible) cells[c].neighbors++;
    if (c-1>=0) if ( cells[c-1].isVisible ) cells[c].neighbors++;

    if (c+nCells<cells.length) if ( cells[c+nCells].isVisible  ) cells[c].neighbors++;
    if (c-nCells>=0) if ( cells[c-nCells].isVisible  ) cells[c].neighbors++;

    if (c+nCells*nCells<cells.length)if ( cells[c+nCells*nCells].isVisible  ) cells[c].neighbors++;
    if (c-nCells*nCells>=0)if ( cells[c-nCells*nCells].isVisible  ) cells[c].neighbors++;

    return cells[c].neighbors;

    //println(dna.cells[c].exposedFaces);
  }
}

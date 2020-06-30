
float [] u = {0, 0, sqrt(2)};
float [] v = {sqrt(2), 0, 0};
float [] w = {-sqrt(2)/2, sqrt(2)/2, sqrt(2)/2};


class DNA {
  // The genetic sequence
  Cell[] cells;

  // The maximum strength of the forces
  // Constructor (makes a DNA of random PVectors)
  DNA() {
    int count=0;
    int center=0;

    cells = new Cell[nCells*nCells*nCells*2];
    //setup array of cells
    for (int i=0; i<nCells; i++ ) {
      for (int j=0; j<nCells; j++ ) {
        for (int k=0; k<nCells*2; k++ ) {

          float alt=(1+k%2*-1);
          float sc=cellR/2;

          cells[count] = new Cell(i*u[0]*sc+j*v[0]*sc+w[0]*sc*alt, i*u[1]*sc+j*v[1]*sc+w[1]*sc*k, i*u[2]*sc+j*v[2]*sc+w[2]*sc*alt);

          if (i==int(nCells/2) && j==int(nCells/2) && k==nCells)center=count;

          count++;
        }
      }
    }

    //turn one cell on
    cells[center].isVisible=true;
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

    //visible cells
    ArrayList<Cell> visibleCells = new ArrayList<Cell>();

    //Cell[] visibleCells = new Cell[];
    int count=0;
    for (int i = 0; i < cells.length; i++) {
      if (cells[i].isVisible) {
        visibleCells.add(cells[i].clone());

        //visibleCells=(Cell[]) expand(visibleCells, count+1);
        //visibleCells[count]=cells[i].clone();
        count++;
      }
    }
    //println(cells.length);

    //println(visibleCells.length);


    if (count>0) {
      //for (int i = 0; i < visibleCells.length; i++) {
      int i=int(random(0, count));
      //int i=0;

      Cell visibleCell = visibleCells.get(i);


      //grow
      int neighbors [] =new int[90];
      if (visibleCell.isVisible) {
        count=0;
        for (int j = 0; j < cells.length; j++)    
        {
          float cellDist=dist(visibleCell.x, visibleCell.y, visibleCell.z, cells[j].x, cells[j].y, cells[j].z);

          if (cellDist<=cellR/sqrt(2) && cellDist>cellR/4)
          {
            neighbors[count]=j;
            count++;
          }
        }
        //pick random neighbor
        tempCells[neighbors[int(random(count))]].isVisible=true;
      }
      //}

      cells=tempCells;
    }
  }



  float getSurfaceVolumeRatio() {
    float neighborTotal=0;
    for (int i = 0; i < cells.length; i++) {
      //add up neighbor score
      neighborTotal+=cells[i].neighbors;
    }
    //println(neighborTotal);

    return (neighborTotal/cells.length)*100000;
    //    return neighborTotal*10000;

  }

  float getBranchScore() {
    float branchScore=1;
    for (int i = 0; i < cells.length; i++) {
      //if cell has 2-3  neighbors.

      if (cells[i].neighbors>2) {
        branchScore+=10000/cells[i].neighbors;
      }
      if (cells[i].neighbors==2) {
        branchScore+=100000;
      }
    }
    //println(neighborTotal);

    return branchScore;
  }



  int countNeighbors(int c) {
    //boolean visible=false;
    cells[c].neighbors=0;

    //if (c+1<cells.length) if ( cells[c+1].isVisible) cells[c].neighbors++;
    //if (c-1>=0) if ( cells[c-1].isVisible ) cells[c].neighbors++;

    //if (c+nCells<cells.length) if ( cells[c+nCells].isVisible  ) cells[c].neighbors++;
    //if (c-nCells>=0) if ( cells[c-nCells].isVisible  ) cells[c].neighbors++;

    //if (c+nCells*nCells<cells.length)if ( cells[c+nCells*nCells].isVisible  ) cells[c].neighbors++;
    //if (c-nCells*nCells>=0)if ( cells[c-nCells*nCells].isVisible  ) cells[c].neighbors++;
    for (int i=0; i<cells.length; i++) {
      if ( c!=i && cells[i].isVisible && dist(cells[i].x, cells[i].y, cells[i].z, cells[c].x, cells[c].y, cells[c].z)<=cellR/sqrt(2)+1) {
        cells[c].neighbors++;
      }
    }

    return cells[c].neighbors;

    //println(dna.cells[c].exposedFaces);
  }

  void spreadNeighborhood(int c, int level) {
    //println(visibleCells.length);
    if (level>0) {
      for (int i=0; i<cells.length; i++) {
        // println(i);
        if ( c!=i && cells[i].isVisible && cells[i].neighborhood==-1) {
        //if ( c!=i && cells[i].isVisible ) {

          if (dist(cells[i].x, cells[i].y, cells[i].z, cells[c].x, cells[c].y, cells[c].z)<=cellR/sqrt(2)+1) {
            cells[i].neighborhood=cells[c].neighborhood;
            level--;
            spreadNeighborhood(i, level);
          }
        }
      }
    }
  }
}

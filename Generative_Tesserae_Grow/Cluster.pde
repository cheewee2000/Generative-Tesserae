
class Cluster {
  // Fitness and DNA
  float fitness;
  DNA dna;
  PVector pos;
  boolean selected=false;
  boolean hover=false;
  color c=color(255, 255, 255);
  int nVisible=0;
  //constructor
  Cluster( PVector pos_, DNA dna_) {
    dna = dna_;
    pos=pos_;
    fitness=0;
  }

  void draw() {
    for (int i = 0; i < dna.cells.length; i++) {
      pushMatrix();
      translate(pos.x, pos.y);
      if (dna.cells[i].isVisible) {
        dna.cells[i].draw();
      }
      popMatrix();
    }
  }

  void drawBoundingBox() {
    //cluster bounding box
    noFill();
    //fill(c,1);
    stroke(c);
    strokeWeight(.5);
    colorMode(RGB, 255);

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    translate((nCells-1)*cellR/4*sqrt(2), (nCells-1)*cellR/4*sqrt(2), (nCells-1)*cellR/4*sqrt(2));

    box(nCells*cellR/sqrt(2));


    //text messes up lighting
    //textSize(16);
    //fill(255);
    //text(nf(fitness, 1, 1), nCells*cellR/2+10, nCells*cellR/2);
    popMatrix();
  }

  void testFitness() {
    //int neighbors=0;
    //for (int i = 0; i < dna.cells.length; i++) {
    //  neighbors+=dna.cells[i].neighbors;
    //}
    //if(neighbors>300)fitness=10;
    //else fitness=1;
    //fitness=01;
    //fitness+=random(100);

    nVisible=0;
    for (int i = 0; i < dna.cells.length; i++) {
      if (dna.cells[i].isVisible) {
        nVisible++;
      }
      dna.countNeighbors(i);
    }

    fitness=dna.getSurfaceVolumeRatio()*s1f;
    fitness+=dna.getBranchScore()*s2f;
  }


  void setColor(color _c) {
    c=_c;
    for (int i = 0; i < dna.cells.length; i++) {
      dna.cells[i].c=_c;
    }
    draw();

    drawBoundingBox() ;
  }


  void findIslands() {
    //visible cells
    Cell[] visibleCells = new Cell[1];
    int count=0;
    for (int i = 0; i < dna.cells.length; i++) {
      if (dna.cells[i].isVisible) {
        visibleCells=(Cell[]) expand(visibleCells, count+1);

        visibleCells[count]=dna.cells[i].clone();
        count++;
      }
    }


    int neighborhood=0;
    for (int i = 0; i <dna.cells.length; i++) {
      if (dna.cells[i].neighborhood==-1 && dna.cells[i].isVisible) {
        dna.cells[i].neighborhood=neighborhood;
        
        dna.spreadNeighborhood(i, nVisible);
        neighborhood++;
      }
    }

//count neighborhood size

//delete all but biggest island

  }



  //loop through and count neighborhoods
  //count island size
  //delete smaller island


  void cullIslands() {
    Cell[] tempCells = new Cell[dna.cells.length];
    for (int i = 0; i < dna.cells.length; i++) {
      tempCells[i]=dna.cells[i].clone();
    }

    for (int i = 0; i < dna.cells.length; i++) {
      if (dna.cells[i].isVisible) {
        //check if there's a neighbor
        if ( dna.countNeighbors(i)==0) {
          //tempDNA.cells[i].isVisible=false;
          tempCells[i].isVisible=false;
        } else {
          //tempCells[i].isVisible=true;
        }
      }
    }
    dna.cells=tempCells;
  }



  float getFitness() {
    return fitness;
  }

  DNA getDNA() {
    return dna;
  }
}

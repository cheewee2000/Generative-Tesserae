
class Cluster {
  // Fitness and DNA
  volatile float fitness;
  DNA dna;
  PVector pos;
  boolean selected=false;
  boolean hover=false;
  color c=color(255, 255, 255);
  int nVisible=0;
  boolean hasIslands=false;
  boolean showFitness=false;

  float boxWidth;
  int adjustClusterSizeMax;

  float areaVolume=0;
  float branchiness=0;
  float connectionFitness=0;

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
    float boxPos=(nCells-1)*cellR/4*sqrt(2);
    translate(boxPos, boxPos, boxPos);
    boxWidth=nCells*cellR/sqrt(2);

    box(boxWidth);

    //box(nCells*cellR/sqrt(2)*2);

    //text messes up lighting
    textSize(10);
    fill(255);
    //text(nf(fitness, 1, 1), nCells*cellR/2+10, nCells*cellR/2);

    //rect(10, 10, 20, 20);
    //if (showFitness) {
    pushMatrix();
    translate(-boxWidth/2+3, boxWidth/2-3, boxWidth/2);
    int yPos=0;
    text("FIT: "+nf(fitness, 1, 1), 0, yPos);
    yPos-=10;
    text("AREA/VOLUME: "+nf(areaVolume, 1, 1), 0, yPos);
    yPos-=10;
    text("BRANCHINESS: "+nf(branchiness, 1, 1), 0, yPos);
    yPos-=10;
    text("# CELLS: "+nf(nVisible, 1, 1), 0, yPos);

    popMatrix();

    //}
    popMatrix();
  }

  void drawClickPlate() {

    //draw rect for picker
    pushMatrix();
    translate(pos.x, pos.y, boxWidth);
    fill(50);
    rect(0, 0, boxWidth*.1, boxWidth*.1);
    popMatrix();
  }

  void testFitness() {
    //int neighbors=0;
    //for (int i = 0; i < dna.cells.length; i++) {
    //  neighbors+=dna.cells[i].neighbors;
    //}
    //if(neighbors>300)fitness=10;
    //else fitness=1;


    areaVolume=dna.getSurfaceVolumeRatio()*s1f;
    branchiness=dna.getBranchScore()*s2f;
    connectionFitness=dna.getConectionFitness()*s4f;

    fitness=areaVolume+branchiness+connectionFitness;


    //if (hasIslands) fitness-=100000;
  }


  void setColor(color _c) {
    c=_c;
    for (int i = 0; i < dna.cells.length; i++) {
      dna.cells[i].c=_c;
    }
    draw();

    drawBoundingBox() ;
  }

  void countVisible() {
    nVisible=0;
    for (int i = 0; i < dna.cells.length; i++) {
      if (dna.cells[i].isVisible) {
        dna.cells[i].neighborhood=-1;
        nVisible++;
      }
      dna.countNeighbors(i);
    }
  }


  void cullIslands() {

    countVisible();
    //spread neighborhood number
    int neighborhood=0;
    for (int i = 0; i <dna.cells.length; i++) {
      if (dna.cells[i].neighborhood==-1 && dna.cells[i].isVisible) {
        dna.cells[i].neighborhood=neighborhood;

        dna.spreadNeighborhood(i, nVisible*10);
        neighborhood++;
      }
    }

    //count neighborhood size
    int[] islands = new int[6];

    for (int i = 0; i <islands.length; i++) {
      int cellCount=0;
      for (int j = 0; j <dna.cells.length; j++) {
        if (dna.cells[j].neighborhood==i) {
          islands[i]=cellCount;
          cellCount++;
        }
      }
    }

    int largestIslandIndex=getIndexOfLargest(islands);


    if (largestIslandIndex>0) {
      hasIslands=true;
    }
    //delete all but biggest island

    int nGrow=0;

    for (int i = 0; i <dna.cells.length; i++) {
      if (dna.cells[i].neighborhood!=largestIslandIndex && dna.cells[i].isVisible) {
        dna.cells[i].isVisible=false;
        nGrow++;
      }
    }

    //replace deleted islands
    for (int i = 0; i < nGrow; i++) {
      dna.grow();
    }

    adjustClusterSizeMax=10;
    adjustClusterSize(clusterSize);
  }


  void adjustClusterSize(int size) {
    if (nVisible<size && adjustClusterSizeMax>0) {
      dna.grow();
      //countVisible();


      //count visible cells
      nVisible=0;
      for (int i = 0; i < dna.cells.length; i++) {
        if (dna.cells[i].isVisible) {
          nVisible++;
        }
      }
      adjustClusterSizeMax--;
      adjustClusterSize(size);
    }
  }

  int getIndexOfLargest( int[] array )
  {
    if ( array == null || array.length == 0 ) return -1; // null or empty

    int largest = 0;
    for ( int i = 1; i < array.length; i++ )
    {
      if ( array[i] > array[largest] ) largest = i;
    }
    return largest; // position of the first largest found
  }




  //loop through and count neighborhoods
  //count island size
  //delete smaller island


  void cullSmallIslands() {
    Cell[] tempCells = new Cell[dna.cells.length];
    for (int i = 0; i < dna.cells.length; i++) {
      tempCells[i]=dna.cells[i].clone();
    }

    for (int i = 0; i < dna.cells.length; i++) {
      if (dna.cells[i].isVisible) {
        //check if there's a neighbor
        if ( dna.countNeighbors(i)==0) 
        {
          //tempDNA.cells[i].isVisible=false;
          tempCells[i].isVisible=false;
        }
        //else {
        //  //tempCells[i].isVisible=true;
        //}
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

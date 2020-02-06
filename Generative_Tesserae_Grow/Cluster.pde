
class Cluster {
  // Fitness and DNA
  float fitness;
  DNA dna;
  PVector pos;
  boolean selected=false;
  boolean hover=false;

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
      dna.countNeighbors(i);
      dna.cells[i].draw();
      popMatrix();
    }


    //cluster bounding box
    pushMatrix();
    translate(pos.x, pos.y);
    translate((nCells-1)*cellR/2, (nCells-1)*cellR/2, (nCells-1)*cellR/2);
    noFill();
    colorMode(RGB, 255);
    stroke(255);
    strokeWeight(1);
    box(nCells*cellR);
    textSize(16);
    fill(255);
    //println(fitness);

    text(nf(fitness, 1, 1), nCells*cellR/2+10, nCells*cellR/2);
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
    
    fitness=dna.getSurfaceVolumeRatio();
  }







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



class Cell {
  float x, y, z;
  boolean isVisible=false;
  int neighbors=0;
  boolean hasBeenVisible=false;
  
  Cell(float _x, float _y, float _z) {
    x=_x;
    y=_y;
    z=_z;
  }

  Cell clone() {
    Cell cell=new Cell(this.x, this.y, this.z);
    cell.isVisible=this.isVisible;
    return cell;
  }


  void draw() {
    if (isVisible) {
      hasBeenVisible=true;
      colorMode(HSB, 100);
      noStroke();
      fill(70+(6.0-neighbors)/6.0*30.0, 255, 100);
      pushMatrix();
      translate(x, y, z);
      box( cellR);
      popMatrix();
    }
  }
}

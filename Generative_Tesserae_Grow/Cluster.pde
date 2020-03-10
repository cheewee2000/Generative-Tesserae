
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
    nVisible=0;
    for (int i = 0; i < dna.cells.length; i++) {
      pushMatrix();
      translate(pos.x, pos.y);
      if (dna.cells[i].isVisible) {
        dna.cells[i].draw();
        nVisible++;
      }
      popMatrix();
      dna.countNeighbors(i);
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

    fitness=dna.getSurfaceVolumeRatio();
  }


  void setColor(color _c) {
    c=_c;
    for (int i = 0; i < dna.cells.length; i++) {
      dna.cells[i].c=_c;
    }
    draw();

    drawBoundingBox() ;
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
  tOcta to;
  color c;

  Cell(float _x, float _y, float _z) {
    x=_x;
    y=_y;
    z=_z;
    to=new tOcta();
    c=color(255);
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
      //strokeWeight(.01);
      //stroke(c);
      //fill(20+(neighbors)*30.0, 255, 100);
      fill(80, 20+(neighbors)*5.0, 100);

      pushMatrix();
      translate(x, y, z);
      //box( cellR);
      to.draw();
      popMatrix();
    }
  }
}

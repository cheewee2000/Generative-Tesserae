class Cell {
  float x, y, z;
  boolean isVisible=false;
  int neighbors=0;
  boolean hasBeenVisible=false;
  tOcta to;
  color c;
  int neighborhood;
  int address;

  Cell(float _x, float _y, float _z) {
    x=_x;
    y=_y;
    z=_z;
    to=new tOcta();
    c=color(255);
    neighborhood=-1;
    address=int(x+y*nCells+z*nCells*nCells);
    
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

      if (neighborhood>-1) {
        fill(255, neighborhood*5, 100);
      }

      pushMatrix();
      translate(x, y, z);
      //box( cellR);
      to.draw();
      popMatrix();
    }
  }
}

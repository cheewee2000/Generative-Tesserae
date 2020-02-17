
import peasy.PeasyCam;
PeasyCam cam;

tOcta to;

void setup() {
  size(1000, 1000, P3D);
  cam = new PeasyCam(this, 400);
  to=new tOcta();
}

void draw() {
  background(200);
  //lights();
  scale(100);
  to.draw();
}




class tOcta {
  PShape s;
  PVector points []=new PVector[24];

  //http://dmccooey.com/polyhedra/TruncatedOctahedron.txt

  int [][]faces={
    {  0, 14, 10, 21, 5, 16 }, 
    {  1, 13, 9, 20, 4, 17 }, 
    {  2, 12, 8, 22, 6, 18 }, 
    {  3, 15, 11, 23, 7, 19 }, 
    {  4, 20, 8, 12, 0, 16 }, 
    {  5, 21, 11, 15, 1, 17 }, 
    {  7, 23, 10, 14, 2, 18 }, 
    {  6, 22, 9, 13, 3, 19 }, 
    {  0, 12, 2, 14 }, 
    {  1, 15, 3, 13 }, 
    {  4, 16, 5, 17 }, 
    {  6, 19, 7, 18 }, 
    {  8, 20, 9, 22 }, 
    { 10, 23, 11, 21 }, 
  };


  tOcta() {
    float C0 = sqrt(2) / 2;
    float C1 =  sqrt(2);
    points[0]= new PVector(C0, 0.0, C1);
    points[1]= new PVector(C0, 0.0, -C1);
    points[2]= new PVector(-C0, 0.0, C1);
    points[3]= new PVector(-C0, 0.0, -C1);
    points[4]= new PVector(C1, C0, 0.0);
    points[5]= new PVector(C1, -C0, 0.0);
    points[6]= new PVector(-C1, C0, 0.0);
    points[7]= new PVector(-C1, -C0, 0.0);
    points[8]= new PVector(0.0, C1, C0);
    points[9]= new PVector(0.0, C1, -C0);
    points[10]= new PVector(0.0, -C1, C0);
    points[11]= new PVector(0.0, -C1, -C0);
    points[12]= new PVector(0.0, C0, C1);
    points[13]= new PVector(0.0, C0, -C1);
    points[14]= new PVector(0.0, -C0, C1);
    points[15]= new PVector(0.0, -C0, -C1);
    points[16]= new PVector( C1, 0.0, C0);
    points[17]= new PVector( C1, 0.0, -C0);
    points[18]= new PVector(-C1, 0.0, C0);
    points[19]= new PVector(-C1, 0.0, -C0);
    points[20]= new PVector( C0, C1, 0.0);
    points[21]= new PVector( C0, -C1, 0.0);
    points[22]= new PVector(-C0, C1, 0.0);
    points[23]= new PVector(-C0, -C1, 0.0);
  }


  void draw() {
    for (int i=0; i<faces.length; i++) {
      s = createShape();
      s.beginShape();
      for (int j=0; j<faces[i].length; j++) {
        s.vertex((float)points[faces[i][j]].x, (float)points[faces[i][j]].y, (float)points[faces[i][j]].z);
      }
      s.endShape();
      shape(s, 0, 0);
    }
  }
}

class ChildApplet extends PApplet {
  //JFrame frame;
  float s1 = .5;
  float s2 = .5;
  float m1 = .5;

  boolean _generate = false;

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(400, 400, P2D);
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    //arcball2 = new Arcball(this, 300);
    int row=70;



    cp5 = new ControlP5(this);

    cp5.addSlider("m1")
      .setPosition(25, row)
      .setRange(0, 1)
      .setValue(m1)
      .setSize(200, 20)
      .setCaptionLabel("mutation rate")
      ;
    row+=25;

    cp5.addSlider("s1")
      .setPosition(25, row)
      .setRange(0, 1)
      .setValue(s1)
      .setSize(200, 20)
      .setCaptionLabel("surface/volume ratio")
      ;
    row+=25;

    cp5.addSlider("s2")
      .setPosition(25, row)
      .setRange(0, 1)
      .setValue(s2)
      .setSize(200, 20)
      .setCaptionLabel("branchiness")
      ;

    row+=25;

    cp5.addButton("shrink")
      .setPosition(25, row)
      .setSize(100, 20)
      ;
    row+=25;

    cp5.addButton("grow")
      .setPosition(25, row)
      .setSize(100, 20)
      ;
    row+=25;

    cp5.addButton("saveSTL")
      .setPosition(25, row)
      .setSize(100, 20)
      ;
    row+=25;

    // create a toggle
    cp5.addToggle("generate")
      .setPosition(25, row)
      .setSize(100, 20)
      ;
  }


  void grow() {
    population.grow();
  }
  void shrink() {
    population.mutate(.2);
  }
  void saveSTL(boolean theValue) {
    saveOBJ=theValue;
  }
  void generate(boolean theFlag) {
    runOptimize=theFlag;
  }

  public void draw() {
    background(150);
    mutationRate = 0.00015+m1*.2;
    s1f = s1;
    s2f = s2;


    float cellCount= 0;
    for (int i=0; i<population.clusters.length; i++) {
      cellCount+= population.clusters[i].nVisible;
    }
    cellCount=cellCount/population.clusters.length;
    cellCount= population.clusters[0].nVisible;


    int row=25;
    text("Average # of Cells: "+nf(cellCount, 1, 1), 25, row);
    row+=20;
    text("Mutation Rate: "+mutationRate, 25, row);
    //row+=10;
    //text("Fitness Rate: "+mutationRate, 25, row);
  }
}

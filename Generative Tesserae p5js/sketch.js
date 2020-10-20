let nCellsX = 5; //nunmber of cells in cluster row and column
let nCellsY = 5; //nunmber of cells in cluster row and column
let nCellsZ = 5; //nunmber of cells in cluster row and column
let saveOBJ = false;
let cellR = 40; //cell radius

let xCount = 2; //clusters per row in population

let margin;


let clusterSize = 2;

let population; // Populations

let visiblePopulationSize = 4; //
let populationSize = 100; //

let mutationRate = 0.00000025;

let myFont;

let runOptimize = false;
let didCullIslands = true;
let csSlider;
//for speed
p5.disableFriendlyErrors = true; // disables FES



let maxGenerations = 80;
let nGenerations = 0;

let generationsDiv;


  let shrink ;
  let grow;
  let generate;

function preload() {
  myFont = loadFont('assets/SpaceMono-Regular.ttf');
}


function setup() {
  createCanvas(800, 800, WEBGL);
  print("hello");
  margin = width / (xCount+2);
  //spacing = width / (xCount + 1) / 2;

  population = new Population(mutationRate, populationSize);

  //population.clusters[0].draw();


  let y = height + 10;
  let lineHeight = 30;
  let c=color(155);
  csSlider = new SliderBar(5, y, 0, 50, 10, "Cluster Size",c);

  y += lineHeight;
  mrSlider = new SliderBar(5, y, 0, 100, 1, "Mutation Rate",c);

  y += lineHeight;
  svSlider = new SliderBar(5, y, 0, 100, 1, "Surface/Volume Ratio",c);

  y += lineHeight;
  bSlider = new SliderBar(5, y, -100, 100, 1, "Branchiness",c);

  y += lineHeight;
  cnSlider = new SliderBar(5, y, 1, 14, 3, "# of Connections",c);

  y += lineHeight;
  cnsSlider = new SliderBar(5, y, 0, 100, 1, "Connection Strength",c);



  y += lineHeight;

   shrink = createButton('Shrink');
  shrink.position(5, y);
  shrink.mousePressed(shrinkBtn);
  y += lineHeight;

   grow = createButton('Grow');
  grow.position(5, y);
  grow.mousePressed(growBtn);

  y += lineHeight;

   generate = createButton('Generate');
  generate.position(5, y);
  generate.mousePressed(generateBtn);
  y += lineHeight;

  generationsDiv = createDiv('nGen').size(200, 20);
  generationsDiv.style('position', 'absolute');
  generationsDiv.style('left', '220px');
  generationsDiv.style('top', y+'px');
  generationsDiv.style('color', c);
  
    y += lineHeight;

  mutationRateDiv = createDiv('mut').size(200, 20);
  mutationRateDiv.style('position', 'absolute');
  mutationRateDiv.style('left', '220px');
  mutationRateDiv.style('top', y+'px');
  mutationRateDiv.style('color', c);
  
      y += lineHeight;

  populationDiv = createDiv('pop').size(200, 20);
  populationDiv.style('position', 'absolute');
  populationDiv.style('left', '220px');
  populationDiv.style('top', y+'px');
  populationDiv.style('color', c);


}

function shrinkBtn() {
  population.mutate(.2);

}

function growBtn() {
  population.grow();

}

function generateBtn() {
  runOptimize = !runOptimize;
  if(runOptimize)generate.html("Stop");
  else generate.html("Generate");

}




class SliderBar {

  constructor(x, y, min, max, start, label,c) {

    this.slider = createSlider(min, max, start);
    this.slider.position(x, y);
    this.slider.style('width', '200px');

    this.label = createDiv(label).size(150, 20);
    this.label.style('position', 'absolute');
    this.label.style('left', '220px');
    this.label.style('top', y + 'px');
    this.label.style('color', c);

    this.div = createDiv('').size(100, 20);
    this.div.style('position', 'absolute');
    this.div.style('left', '400px');
    this.div.style('top', y + 'px');
    this.div.style('color', c);


  }


  update() {
    let v = this.slider.value();
    this.div.html(v);

    return v;
    //print(v);
  }

}





function draw() {
  background(220);
  ambientLight(255, 255, 255); //even red light across our objects
  ambientMaterial(250);

  //orbitControl([sensitivityX], [sensitivityY], [sensitivityZ])
  orbitControl(2, 2, 0.01);



  if (runOptimize) {

    population.selection();
    population.reproduction();
    //if (frameCount%100==0) population.cullSmallIslands();
    //if (frameCount%100==0) population.adjustClusterSize();
    population.cullIslands();
    population.testFitness(); //end with test fitness to display current fitness

    nGenerations++;

    //population.testFitness();
  } else if (didCullIslands == false) {
    population.cullIslands();
    population.testFitness();
    didCullIslands = true;
  }
  //else 
  {

    population.live();
  }

  updateUI();

}


function updateUI() {

  clusterSize=csSlider.update();
  mutationRate=0.00015+ mrSlider.update()/100.0*.2;
  svSlider.update();
  bSlider.update();
  cnSlider.update();
  cnsSlider.update();



  generationsDiv.html('Generations: ' + nGenerations);

  mutationRateDiv.html('Mutation Rate: ' + mutationRate.toFixed(5));
  populationDiv.html('Population Size: ' + populationSize);



}



function reset() {

  population = new Population(mutationRate, populationSize);
}

function keyPressed() {

  if (keyCode == ENTER) {

    runOptimize = !runOptimize;
    didCullIslands = false;
  } else if (key == 'm') { //force drastic mutation
    population.mutate(.2);
  } else if (key == 'g') {
    population.grow();
  } else if (key == 'f') {
    population.testFitness();
  } else if (key == 'c') {
    population.cullIslands();
  } else if (key == 'r') {
    setup();
    runOptimize = false;
  } else if (key == 's') {
    saveOBJ = true;
  } else if (key == 'x') {
    saveMatrix = true;
  }
  //else if (key == 'i' ) {
  //  population.cullIslands();
  //}
}


class Population {



  // Initialize the population
  constructor(m, num) {



    this.mutationRate = m;
    this.clusters = []
    this.matingPool = [];
    this.generations = 0; // Number of generations
    //make a new set of creatures


    for (let i = 0; i < num; i++) {
      let y = floor(i / xCount);
      //let pos = createVector(i % xCount * (width / xCount) - width / 2 + margin, y * height / xCount - height / 2 + margin, 0);
      let pos = createVector(-width/2+margin+(i %xCount )* margin*1.5 , - height / 2 + margin +y * margin*1.5, 0);

      this.clusters[i] = new Cluster(pos, new DNA());
    }

    //print(this.clusters);

    //initial cluster of 20
    //for (int j=0; j<clusterSize; j++) 
    for (let j = 0; j < clusterSize; j++) {
      this.grow();
    }
  }

  // Find highest fintess for the population
  getMaxFitness() {
    let record = 0;
    for (let i = 0; i < this.clusters.length; i++) {
      if (this.clusters[i].getFitness() > record) {
        record = this.clusters[i].getFitness();
      }
    }
    return record;
  }

  live() {
    // Run every Cluster

    //for (int i = 0; i < clusters.length; i++) {
    //display 9 culsters
    for (let i = 0; i < visiblePopulationSize; i++) {
      this.clusters[i].draw();
      this.clusters[i].drawBoundingBox();
      //picker.start(i);

      //clusters[i].drawClickPlate();
    }
    //picker.stop();
  }


  testFitness() {
    for (let i = 0; i < this.clusters.length; i++) {
      this.clusters[i].testFitness();
    }
  }

  // Generate a mating pool
  selection() {
    // Clear the ArrayList
    this.matingPool = [];

    // Calculate total fitness of whole population
    let maxFitness = this.getMaxFitness();
    //let maxFitness = 1;

    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (let i = 0; i < this.clusters.length; i++) {
      let fitnessNormal = map(this.clusters[i].getFitness(), 0, maxFitness, 0, 1);
      let n = round(fitnessNormal * 10000); // Arbitrary multiplier
      for (let j = 0; j < n; j++) {
        this.matingPool.push(this.clusters[i]);
      }
    }
  }

  // Making the next generation
  reproduction() {
    if (this.matingPool.length > 0) {
      // Refill the population with children from the mating pool
      for (let i = 0; i < this.clusters.length; i++) {
        // Sping the wheel of fortune to pick two parents
        let m = floor(random(this.matingPool.length));
        let d = floor(random(this.matingPool.length));
        // Pick two parents
        let mom = this.matingPool[m];
        let dad = this.matingPool[d];
        //Cluster dad = matingPool.get(m);

        // Get their genesgggg
        let momgenes = mom.getDNA();
        let dadgenes = dad.getDNA();
        // Mate their genes
        let child = momgenes.crossover(dadgenes);
        // Mutate their genes
        child.mutate(this.mutationRate);
        // Fill the new population with the new child
        let y = (i / xCount);
        //PVector pos=new PVector(margin/(xCount)/2+(i*cellR*scale) % (width-margin)+i%xCount*(margin/(xCount)), margin/(xCount)/2+y*cellR*scale + y*(margin/xCount));
        this.clusters[i] = new Cluster(this.clusters[i].pos, child);
      }
      this.generations++;
    }
  }


  mutate(_mutationRate) {
    for (let i = 0; i < this.clusters.length; i++) {
      this.clusters[i].dna.mutate(_mutationRate);
    }
  }


  grow() {
    for (let i = 0; i < this.clusters.length; i++) {
      this.clusters[i].dna.grow();
    }
  }

  cullIslands() {
    for (let i = 0; i < this.clusters.length; i++) {
      this.clusters[i].cullIslands();
    }
  }

  adjustClusterSize() {
    for (let i = 0; i < this.clusters.length; i++) {
      this.clusters[i].adjustClusterSize(clusterSize);
    }
  }


  cullSmallIslands() {
    for (let i = 0; i < this.clusters.length; i++) {
      clusters[i].cullSmallIslands();
    }
  }


  // Find highest fintess for the population
  getMinFitness() {
    let record = 0;
    for (let i = 0; i < this.clusters.length; i++) {
      if (this.clusters[i].getFitness() < record) {
        record = this.clusters[i].getFitness();
      }
    }
    return record;
  }

}












class DNA {
  // The genetic sequence

  // The maximum strength of the forces
  // Constructor (makes a DNA of random PVectors)
  constructor() {


    let u = [0, 0, sqrt(2)];
    let v = [sqrt(2), 0, 0];
    let w = [-sqrt(2) / 2, sqrt(2) / 2, sqrt(2) / 2];

    this.center = 0;
    //this.cells = [nCellsX * nCellsY * nCellsZ * 2];
    this.cells = [];


    //setup array of cells
    let count = 0;

    for (let i = 0; i < nCellsX; i++) {
      for (let j = 0; j < nCellsY; j++) {
        for (let k = -nCellsZ; k < nCellsZ; k++) {

          let alt = (1 + k % 2 * -1);
          let sc = cellR / 2;

          //cells[count] = new Cell(i*u[0]*sc+j*v[0]*sc+w[0]*sc*alt, i*u[1]*sc+j*v[1]*sc+w[1]*sc*k, i*u[2]*sc+j*v[2]*sc+w[2]*sc*alt);
          //this.cells[count] = new Cell(i * u[0] * sc + j * v[0] * sc + w[0] * sc * alt, i * u[2] * sc + j * v[2] * sc + w[2] * sc * alt, i * u[1] * sc + j * v[1] * sc + w[1] * sc * k);


          this.cells.push(new Cell(i * u[0] * sc + j * v[0] * sc + w[0] * sc * alt, i * u[2] * sc + j * v[2] * sc + w[2] * sc * alt, i * u[1] * sc + j * v[1] * sc + w[1] * sc * k));





          if (i == round(nCellsX / 2.0) && j == round(nCellsY / 2.0) && k == round(nCellsZ / 2)) this.center = count;
          //if (i == (nCellsX / 2.0) ) this.center = count;
          //this.cells[count].isVisible=true;
          count++;
        }
      }
    }

    //turn one cell on
    this.cells[this.center].isVisible = true;
  }

  // Constructor #2, creates the instance based on an existing array
  DNA(newcells) {
    this.cells = newcells;
  }

  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  crossover(partner) {
    //Cell[] child = new Cell[cells.length];
    let child = [this.cells.length];
    // Pick a midpoint
    let crossover = (random(this.cells.length));
    //int crossover=cells.length;

    // Take "half" from one and "half" from the other
    for (let i = 0; i < this.cells.length; i++) {
      if (i > crossover) child[i] = this.cells[i];
      else child[i] = partner.cells[i];
    }
    let newcells = new DNA(child);
    return newcells;
  }

  // Based on a mutation probability, picks a new random Vector
  mutate(m) {
    for (let i = 0; i < this.cells.length; i++) {
      if (random(1.0) < m) {
        if (this.cells[i].hasBeenVisible) {
          this.cells[i].isVisible = !this.cells[i].isVisible;
        }
      }
    }
  }



  grow() {
    //copy cells
    //Cell[] tempCells = new Cell[cells.length];
    let tempCells = [];


    for (let i = 0; i < this.cells.length; i++) {
      tempCells[i] = this.cells[i].clone();
    }

    //visible cells
    //ArrayList<Cell> visibleCells = new ArrayList<Cell>();
    let visibleCells = [];

    //this.visibleCells=this.cells[0].clone();
    //this.visibleCells.push(new Cell(0,0,0));
    this.visibleCells = this.cells;
    //let b = Object.assign({}, his.cells);

    //Cell[] visibleCells = new Cell[];
    let count = 0;

    let visibleCellIndex = [];

    for (let i = 0; i < this.cells.length; i++) {
      if (this.cells[i].isVisible) {
        visibleCellIndex[count] = i;

        //visibleCells.push(this.cells[i].clone());

        //visibleCells=(Cell[]) expand(visibleCells, count+1);
        //visibleCells[count]=this.cells[i];
        //visibleCells[count]=Object.assign({}, this.cells[i]);

        count++;
      }
    }
    //print(this.visibleCells[0]);


    //println(cells.length);

    //println(visibleCells.length);


    if (count > 0) {
      //for (int i = 0; i < visibleCells.length; i++) {
      let r = floor(random(0, count));
      let i = visibleCellIndex[r];

      //grow
      let neighbors = [];

      //if (this.cells[i].isVisible) {
      count = 0;
      for (let j = 0; j < this.cells.length; j++) {
        let cellDist = dist(this.cells[i].x, this.cells[i].y, this.cells[i].z, this.cells[j].x, this.cells[j].y, this.cells[j].z);
        //     let cellDist = dist(1, 10,0, this.cells[j].x, this.cells[j].y, this.cells[j].z);

        //let cellDist =9;
        if (cellDist <= cellR / sqrt(2) && cellDist > cellR / 4) {
          neighbors[count] = j;
          count++;
        }
      }
      //pick random neighbor
      tempCells[neighbors[int(random(count))]].isVisible = true;
    }
    //}

    this.cells = tempCells;
    //}
  }



  getConectionFitness() {
    let fitness = 0;
    let nConnections = 2;

    for (let i = 0; i < this.cells.length; i++) {
      //println(cells[i].neighbors);
      if (nConnections == this.cells[i].neighbors) {
        fitness += 1000;
        //println(fitness);
      }
      //else connectionFitness-=1000;
    }
    return fitness;
  }




  getSurfaceVolumeRatio() {
    let neighborTotal = 0;
    let visibleTotal = 0;
    for (let i = 0; i < this.cells.length; i++) {
      //add up neighbor score
      if (this.cells[i].isVisible) {
        neighborTotal += this.cells[i].neighbors;
        visibleTotal++;
      }
    }
    //println(neighborTotal);

    return (visibleTotal / neighborTotal) * 100000;
    //    return neighborTotal*10000;
  }

  getBranchScore() {
    let branchScore = 0;
    for (let i = 0; i < this.cells.length; i++) {
      //if cell has 2-3  neighbors.
      if (this.cells[i].isVisible) {
        if (this.cells[i].neighbors > 2) {
          branchScore -= 1000 * this.cells[i].neighbors;
        }
        if (this.cells[i].neighbors <= 2 && this.cells[i].neighbors > 0) {
          branchScore += 100000;
        }
        //println(cells[i].neighbors);
      }
    }
    //println(neighborTotal);

    return branchScore / 3.0; //adjust range to fit other fitness criteria
  }



  countNeighbors(c) {
    //boolean visible=false;
    this.cells[c].neighbors = 0;

    //if (c+1<cells.length) if ( cells[c+1].isVisible) cells[c].neighbors++;
    //if (c-1>=0) if ( cells[c-1].isVisible ) cells[c].neighbors++;

    //if (c+nCells<cells.length) if ( cells[c+nCells].isVisible  ) cells[c].neighbors++;
    //if (c-nCells>=0) if ( cells[c-nCells].isVisible  ) cells[c].neighbors++;

    //if (c+nCells*nCells<cells.length)if ( cells[c+nCells*nCells].isVisible  ) cells[c].neighbors++;
    //if (c-nCells*nCells>=0)if ( cells[c-nCells*nCells].isVisible  ) cells[c].neighbors++;
    for (let i = 0; i < this.cells.length; i++) {
      if (c != i && this.cells[i].isVisible && dist(this.cells[i].x, this.cells[i].y, this.cells[i].z, this.cells[c].x, this.cells[c].y, this.cells[c].z) <= cellR / sqrt(2) + 1) {
        this.cells[c].neighbors++;
      }
    }

    return this.cells[c].neighbors;

    //println(dna.cells[c].exposedFaces);
  }

  spreadNeighborhood(c, level) {
    //println(visibleCells.length);
    if (level > 0) {
      for (let i = 0; i < this.cells.length; i++) {
        // println(i);
        if (c != i && this.cells[i].isVisible && this.cells[i].neighborhood == -1) {
          //if ( c!=i && cells[i].isVisible ) {

          if (dist(this.cells[i].x, this.cells[i].y, this.cells[i].z, this.cells[c].x, this.cells[c].y, this.cells[c].z) <= cellR / sqrt(2) + 1) {
            this.cells[i].neighborhood = this.cells[c].neighborhood;
            level--;
            this.spreadNeighborhood(i, level);
          }
        }
      }
    }
  }
}












class Cluster {


  //constructor
  constructor(pos_, dna_) {
    this.dna = new DNA();


    if (dna_ != null) this.dna = dna_;



    this.pos = pos_;
    this.fitness = 0;


    // Fitness and DNA
    // volatile float fitness;
    // DNA dna;
    // PVector pos;
    this.selected = false;
    this.hover = false;
    this.c = color(205);
    this.nVisible = 0;
    this.hasIslands = false;
    this.showFitness = false;

    // float boxWidth;
    // float boxHeight;
    // float boxDepth;
    // int adjustClusterSizeMax;

    this.areaVolume = 0;
    this.branchiness = 0;
    this.connectionFitness = 0;



  }

  draw() {
    for (let i = 0; i < this.dna.cells.length; i++) {
      push();

      if (!saveOBJ) translate(this.pos.x, this.pos.y);
      if (this.dna.cells[i].isVisible) {

        this.dna.cells[i].draw();
      }
      pop();
    }
  }




  drawBoundingBox() {

    //cluster bounding box
    noFill();
    //fill(c,1);
    stroke(this.c);
    strokeWeight(0.5);
    colorMode(RGB, 255);

    push();
    translate(this.pos.x, this.pos.y, this.pos.z);
    this.boxPos = (nCellsX - 1) * cellR / 4 * sqrt(2);

    translate(this.boxPos, this.boxPos, (nCellsX - 1));
    this.boxWidth = nCellsX * cellR / sqrt(2);
    this.boxHeight = nCellsY * cellR / sqrt(2);
    this.boxDepth = nCellsZ * cellR / sqrt(2);

    //sphere(10);
    box(this.boxWidth, this.boxHeight, this.boxDepth);

    //box(nCells*cellR/sqrt(2)*2);

    //text messes up lighting
    noStroke();
      if (!runOptimize) {

    textSize(12);
    textFont(myFont);

    fill(90);
    //text(nf(fitness, 1, 1), nCells*cellR/2+10, nCells*cellR/2);
    let lh = 15;
    //rect(10, 10, 20, 20);
    //if (showFitness) {
    push();
    translate(-this.boxWidth / 2 + 3, this.boxHeight / 2 - 3, this.boxDepth / 2);
    let yPos = 0;
    text("FIT: " + nf(this.fitness, 1, 1), 0, yPos);
    yPos -= lh;
    text("AREA/VOLUME: " + nf(this.areaVolume, 1, 1), 0, yPos);
    yPos -= lh;
    text("BRANCHINESS: " + nf(this.branchiness, 1, 1), 0, yPos);
    yPos -= lh;
    text("# CELLS: " + nf(this.nVisible, 1, 1), 0, yPos);

    pop();
}
    //}
    pop();
      
  }

  drawClickPlate() {

    //draw rect for picker
    push();
    translate(this.pos.x, this.pos.y, this.boxWidth);
    fill(50);
    rect(0, 0, this.boxWidth * 0.1, this.boxWidth * 0.1);
    pop();
  }

  testFitness() {
    //int neighbors=0;
    //for (int i = 0; i < dna.cells.length; i++) {
    //  neighbors+=dna.cells[i].neighbors;
    //}
    //if(neighbors>300)fitness=10;
    //else fitness=1;
    //fitness+=random(100);

    this.areaVolume=this.dna.getSurfaceVolumeRatio()* svSlider.update();
    this.branchiness = this.dna.getBranchScore() * bSlider.update();
    this.connectionFitness=this.dna.getConectionFitness()*cnsSlider.update();

    this.fitness = this.areaVolume + this.branchiness + this.connectionFitness;

    //println(fitness);

    //if (hasIslands) fitness-=100000;
  }


  setColor(_c) {
    this.c = _c;
    for (let i = 0; i < this.dna.cells.length; i++) {
      this.dna.cells[i].c = _c;
    }
    draw();

    drawBoundingBox();
  }

  countVisible() {
    this.nVisible = 0;
    for (let i = 0; i < this.dna.cells.length; i++) {
      if (this.dna.cells[i].isVisible) {
        this.dna.cells[i].neighborhood = -1;
        this.nVisible++;
      }
      this.dna.countNeighbors(i);
    }
  }


  cullIslands() {

    this.countVisible();
    //spread neighborhood number
    let neighborhood = 0;
    for (let i = 0; i < this.dna.cells.length; i++) {
      if (this.dna.cells[i].neighborhood == -1 && this.dna.cells[i].isVisible) {
        this.dna.cells[i].neighborhood = neighborhood;

        this.dna.spreadNeighborhood(i, this.nVisible * 10);
        neighborhood++;
      }
    }

    //count neighborhood size
    //int[] islands = new int[6];
    let islands = [6];

    for (let i = 0; i < islands.length; i++) {
      let cellCount = 0;
      for (let j = 0; j < this.dna.cells.length; j++) {
        if (this.dna.cells[j].neighborhood == i) {
          islands[i] = cellCount;
          cellCount++;
        }
      }
    }

    let largestIslandIndex = this.getIndexOfLargest(islands);


    if (largestIslandIndex > 0) {
      hasIslands = true;
    }
    //delete all but biggest island

    let nGrow = 0;

    for (let i = 0; i < this.dna.cells.length; i++) {
      if (this.dna.cells[i].neighborhood != largestIslandIndex && this.dna.cells[i].isVisible) {
        this.dna.cells[i].isVisible = false;
        nGrow++;
      }
    }

    //replace deleted islands
    for (let i = 0; i < nGrow; i++) {
      this.dna.grow();
    }

    this.adjustClusterSizeMax = clusterSize;
    this.adjustClusterSize(clusterSize);
  }


  adjustClusterSize(size) {
    if (this.nVisible < size && this.adjustClusterSizeMax > 0) {
      this.dna.grow();
      //countVisible();


      //count visible cells
      this.nVisible = 0;
      for (let i = 0; i < this.dna.cells.length; i++) {
        if (this.dna.cells[i].isVisible) {
          this.nVisible++;
        }
      }
      this.adjustClusterSizeMax--;
      this.adjustClusterSize(size);
    }
  }

  getIndexOfLargest(array) {
    if (array == null || array.length == 0) return -1; // null or empty

    let largest = 0;
    for (let i = 1; i < array.length; i++) {
      if (array[i] > array[largest]) largest = i;
    }
    return largest; // position of the first largest found
  }




  //loop through and count neighborhoods
  //count island size
  //delete smaller island


  cullSmallIslands() {
    //Cell[] tempCells = new Cell[dna.cells.length];

    let tempCells = [this.dna.cells.length];

    for (let i = 0; i < this.dna.cells.length; i++) {
      tempCells[i] = dna.cells[i].clone();
    }

    for (let i = 0; i < this.dna.cells.length; i++) {
      if (this.dna.cells[i].isVisible) {
        //check if there's a neighbor
        if (this.dna.countNeighbors(i) == 0) {
          //tempDNA.cells[i].isVisible=false;
          tempCells[i].isVisible = false;
        }
        //else {
        //  //tempCells[i].isVisible=true;
        //}
      }
    }
    this.dna.cells = tempCells;
  }



  getFitness() {
    return this.fitness;
  }

  getDNA() {
    return this.dna;
  }
}











class Cell {

  constructor(_x, _y, _z) {
    this.x = _x;
    this.y = _y;
    this.z = _z;
    this.to = new tOcta();
    this.c = color(255, 120, 150);
    this.neighborhood = -1;
    this.address = (this.x + this.y * nCellsX + this.z * nCellsY * nCellsZ);
    this.isVisible = false;
    this.neighbors = -1;
    this.hasBeenVisible = false;

  }

  clone() {
    let cell = new Cell(this.x, this.y, this.z);
    cell.isVisible = this.isVisible;
    return cell;
  }


  draw() {
    if (this.isVisible) {
      this.hasBeenVisible = true;
      colorMode(HSB, 100);


      push();
      strokeWeight(.01);
      stroke(25, 50, 50);

      translate(this.x, this.y, this.z);
      fill(255);
      //noFill();

      this.to.draw();
      pop();
    }
  }
}




class tOcta {


  constructor() {

    this.points = [];

    //http://dmccooey.com/polyhedra/TruncatedOctahedron.txt
    this.faces = [
      [0, 14, 10, 21, 5, 16],
      [1, 13, 9, 20, 4, 17],
      [2, 12, 8, 22, 6, 18],
      [3, 15, 11, 23, 7, 19],
      [4, 20, 8, 12, 0, 16],
      [5, 21, 11, 15, 1, 17],
      [7, 23, 10, 14, 2, 18],
      [6, 22, 9, 13, 3, 19],
      [0, 12, 2, 14],
      [1, 15, 3, 13],
      [4, 16, 5, 17],
      [6, 19, 7, 18],
      [8, 20, 9, 22],
      [10, 23, 11, 21],
    ];



    let C0 = sqrt(2) / 2;
    let C1 = sqrt(2);
    this.points[0] = createVector(C0, 0.0, C1);
    this.points[1] = createVector(C0, 0.0, -C1);
    this.points[2] = createVector(-C0, 0.0, C1);
    this.points[3] = createVector(-C0, 0.0, -C1);
    this.points[4] = createVector(C1, C0, 0.0);
    this.points[5] = createVector(C1, -C0, 0.0);
    this.points[6] = createVector(-C1, C0, 0.0);
    this.points[7] = createVector(-C1, -C0, 0.0);
    this.points[8] = createVector(0.0, C1, C0);
    this.points[9] = createVector(0.0, C1, -C0);
    this.points[10] = createVector(0.0, -C1, C0);
    this.points[11] = createVector(0.0, -C1, -C0);
    this.points[12] = createVector(0.0, C0, C1);
    this.points[13] = createVector(0.0, C0, -C1);
    this.points[14] = createVector(0.0, -C0, C1);
    this.points[15] = createVector(0.0, -C0, -C1);
    this.points[16] = createVector(C1, 0.0, C0);
    this.points[17] = createVector(C1, 0.0, -C0);
    this.points[18] = createVector(-C1, 0.0, C0);
    this.points[19] = createVector(-C1, 0.0, -C0);
    this.points[20] = createVector(C0, C1, 0.0);
    this.points[21] = createVector(C0, -C1, 0.0);
    this.points[22] = createVector(-C0, C1, 0.0);
    this.points[23] = createVector(-C0, -C1, 0.0);
  }


  draw() {

    strokeWeight(0.2);
    push();
    scale(cellR / 4);
    //scale(10);
    for (let i = 0; i < this.faces.length; i++) {
      beginShape();
      for (let j = 0; j < this.faces[i].length; j++) {
        vertex(this.points[this.faces[i][j]].x, this.points[this.faces[i][j]].y, this.points[this.faces[i][j]].z);
      }

      endShape(CLOSE);
    }
    pop();
  }



}
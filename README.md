# Generative Tesserae
## Generative algorithm for generating optimized space assemblies


Current Version: Generative Tesserae p5js

## Live Demo/Editor https://editor.p5js.org/cheewee2000/sketches/D1LCrLyNO

## Key Concepts:
* Cell: a single truncated octahedron
* Cluster: 3D array of cells
* DNA: data of each cluster's state (Cells on or off, fitness, etc.)
* Population: A collection of Clusters

## Key Variables:
* popluationSize: # of Clusters for the GA to consider
* clusterSize: # of Cells to each Cluster
* mutationRate: how much mutation occurs when the population goes through a reproduction cycle


## GA optimization sequence
1. Selection
* normalize the fitness values across the population
* multiply fitness values to boost clusters that are more fit
* add more copies of clusters to the mating pool based on fitness level
 
2. Reproduction
* randomly split the mating pool into two unequal halves
* crossover the DNA of the two mating pools to create children
* mutate the children based on the mutation rate

3. Cull Islands
* mating and mutation may genrated cells that are detatched from the main cluster
* detect islands within clusters
* delete all but the island with the most cells

4. Test Fitness
* calcuate fitness for all parameters

5. Repeat


## Fitness Criteria
* Surface to Volume Ratio
  * total number of cells divided by number of shared faces
* Branchiness
  * cells with more than 2 neighbors get points subtracted
  * cells with 2 or less neighbors get points added
* Number of Connections per Cell
  * cells with the desired number of connections get added points

## Fitness Criteria to be added
* Public /Private
  * Clusters that achieve public vs private Cell ratios closer to the desired ratio get points
  * Public Cells are defined as Cells that have 3 or more connections

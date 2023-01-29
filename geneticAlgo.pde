import java.util.ArrayList;
import java.lang.Math;

ArrayList<Item> itemList = new ArrayList<>();
ArrayList<Integer> genFit = new ArrayList<>();
ArrayList<Integer> genWorstFit = new ArrayList<>();
ArrayList<Bar> barBestList = new ArrayList<>();
ArrayList<Bar> barWorstList = new ArrayList<>();
DNA[] population = new DNA[100];
int totalPrice = 0;
float mutationRate = 0.01;

int genFitCount = 0;
int genWorstFitCount = 0;
int gens = 1;
int count = 0;
int activeBar = -1;
boolean msg = false;

void setup()
{
  size(1400, 800);
  String[] lines = loadStrings("items.txt");
  for (int i = 0; i < lines.length; i++) {
    String[] itemAtt = lines[i].split(",");
    itemList.add(new Item(itemAtt[0], Integer.parseInt(itemAtt[1]), Integer.parseInt(itemAtt[2])));
    //println(itemList.get(i).weight);
  }
  for (int i = 0; i < itemList.size(); i++) {
    totalPrice += itemList.get(i).price;
  }



  train();
}

void train() {
  for (int i = 0; i < population.length; i++) {
    population[i] = new DNA();
  }
  genFit = new ArrayList<>();
  genWorstFit = new ArrayList<>();
  barBestList = new ArrayList<>();
  barWorstList = new ArrayList<>();

  for (int run = 0; run < 100; run++) {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness();
    }

    ArrayList<DNA> matingPool = new ArrayList<DNA>();


    for (int i = 0; i < population.length; i++) {
      int n = int(float(population[i].fitness) / float(totalPrice) * 100);
      //int n = (int) Math.round(Math.pow((float(population[i].fitness) / float(totalPrice) * 100), 1));

      //print(n + " ");
      for (int j = 0; j < n; j++) {
        matingPool.add(population[i]);
      }
    }

    int bestFit = 0;

    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness > population[bestFit].fitness) {
        bestFit = i;
      }
    }
    int worstFit = bestFit;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness < population[worstFit].fitness && population[i].fitness > 0) {
        worstFit = i;
      }
    }


    //print(population[bestFit].fitness + " ");
    count++;
    if (count == gens) {
      count = 0;
      genFitCount += population[bestFit].fitness;
      genWorstFitCount += population[worstFit].fitness;
      println("Best last "+ gens + " avg: " + genFitCount / gens);
      genFit.add(genFitCount / gens);
      genWorstFit.add(genWorstFitCount / gens);
      genFitCount = 0;
      genWorstFitCount = 0;
    } else {
      genFitCount += population[bestFit].fitness;
      genWorstFitCount += population[worstFit].fitness;
    }

    for (int i = 0; i < population.length; i++) {

      int a = int(random(matingPool.size()));

      ArrayList<DNA> poolB = new ArrayList<DNA>();
      for (int j = 0; j < matingPool.size(); j++) {
        if (matingPool.get(i) != matingPool.get(a)) {
          poolB.add(matingPool.get(i));
        }
      }
      int b = int(random(matingPool.size()));

      DNA parentA = matingPool.get(a);
      DNA parentB = matingPool.get(b);

      DNA child = parentA.breed(parentB);
      child.mutate(mutationRate);
      population[i] = child;
    }
  }
  for (int i = 0; i < genFit.size(); i++) {
    barBestList.add(new Bar(10*i+50, genFit.get(i)*-0.45));
    barWorstList.add(new Bar(10*i+50, genWorstFit.get(i)*-0.45));
  }
}

void draw() {
  background(18, 30, 42);
  for (int i = 0; i < genFit.size(); i++) {
    fill(29, 184, 113);
    rect(barBestList.get(i).x, barBestList.get(i).y, barBestList.get(i).barWidth, barBestList.get(i).barHeight);
    fill(215, 47, 15);
    rect(barWorstList.get(i).x, barWorstList.get(i).y, barWorstList.get(i).barWidth, barWorstList.get(i).barHeight);

    //print(overRect(barBestList.get(i).x, barBestList.get(i).y, barBestList.get(i).barWidth, barBestList.get(i).barHeight));
    if (overBar(barBestList.get(i).x, barBestList.get(i).y, barBestList.get(i).barWidth, barBestList.get(i).barHeight) && activeBar == -1) {
      activeBar = i;
      textSize(24);
      fill(255);
      text("Best Value: " + genFit.get(i), width- 300, 150);
      text("Worst Value: " + genWorstFit.get(i), width- 300, 200);
    }
  }


  if (activeBar == -1) {
    textSize(18);
    fill(255);
    text("(Hover over a bar to get info)", width- 300, 150);
  }

  activeBar = -1;

  fill(255);
  textSize(42);
  text("Generation Info", width - 300, 100);
  text("Actions", width - 300, 320);
  textSize(24);
  fill(51, 169, 254);
  rect(width - 300, 350, 100, 50, 15);
  fill(0);
  text("Rerun", width - 280, 382);
  
  //Axis Titles
  textSize(20);
  fill(88, 106, 127);
  text("Generation", barBestList.get(barBestList.size()-1).x / 2 + 25, height - 8);
  pushMatrix();
  translate( 40, height/2 + 30);
  rotate(-HALF_PI);
  text("Fitness / Value",0,0);
  popMatrix();
}

public boolean overBar(float posX, float posY, float sizeX, float sizeY) {
  if (mouseX >= posX && mouseX <= posX+sizeX &&
    mouseY <= posY && mouseY >= posY+sizeY) {
    return true;
  } else {
    return false;
  }
}
public boolean overRect(float posX, float posY, float sizeX, float sizeY) {
  if (mouseX >= posX && mouseX <= posX+sizeX &&
    mouseY >= posY && mouseY <= posY+sizeY) {
    return true;
  } else {
    return false;
  }
}

void mouseClicked() {
  if (overRect(width - 300, 350, 100, 50)) {
    train();
  }
  
}

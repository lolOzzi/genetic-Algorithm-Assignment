
class DNA {
  int[] genes = new int[itemList.size() -1];
  int fitness;
  int weight;

   
   void fitness () {
    fitness = 0;
    weight = 0;
    for (int i = 0; i < genes.length; i++) {
      if (genes[i] == 1){
        fitness += itemList.get(i).price;
        weight += itemList.get(i).weight;
      }
    }
    if (weight > 5000) {
      fitness = 0;
    }
  }
  DNA breed(DNA partner) {
    DNA child = new DNA();
    
    for (int i = 0; i < genes.length; i++){
      int rand = int(random(0, 2));
      if (rand == 1) {
        child.genes[i] = partner.genes[i];
      } else{
        child.genes[i] = genes[i];
      }
    }
    
    return child;
  }
  
  void mutate(float mutationRate) {

    for (int i = 0; i < genes.length; i++) {
      if (random(1) < mutationRate) {
        genes[i] = int(random(0,2));
      }
    }
  }
  
    DNA() {
    for (int i = 0; i < genes.length; i++) {
      genes[i] = int(random(0,2));
    }
  }
}

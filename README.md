# SwiftyGA
 Version 1.0
  
 A Simple Genetic Algorithm for Swift

 Easy to Use:

 Max Value Problem Example:
 
         SwiftyGA_Parameters.singleton.geneType = .IntGene
         SwiftyGA_Parameters.singleton.crossoverMethod = .OnePointCrossoverMethod
         SwiftyGA_Parameters.singleton.crossoverRate = 0.9
         SwiftyGA_Parameters.singleton.mutationMethod = .SwapMutationMethod
         SwiftyGA_Parameters.singleton.mutationMethod_subsetLength = 1
         SwiftyGA_Parameters.singleton.mutationRate = 0.05
     
         //Fitness
         SwiftyGA_Parameters.singleton.fitnessGoal = .Maximising
         
         //Max log chromosome
         SwiftyGA_Parameters.singleton.maxLogChromosomeTotalGenerations = 50000
         
         //Chromosome Allele Set
         SwiftyGA_Parameters.singleton.chromosomeLength = 20
         SwiftyGA_Parameters.singleton.alleleSet = Array(0...10) //number 0 - 10
         SwiftyGA_Parameters.singleton.populationSize = 500
         SwiftyGA_Parameters.singleton.noOfSelectedParents = 200 //must be Even number
         SwiftyGA_Parameters.singleton.terminateGeneration = 100
         
         //Create GA Computation and Run
         self.gaComputation = SwiftyGA_GAComputation()
         self.gaComputation.delegate = self
         let defaultFitFunc = SwiftyGA_FitnessFunction()
         self.gaComputation.fitnessFunction = defaultFitFunc
         self.gaComputation.run()



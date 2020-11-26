//
//  SwiftyGA_Population.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 15/10/2020.
//


class SwiftyGA_Population{
    var gaParameters = SwiftyGA_Parameters()
    
    //core genes data
    var chromosomes:[SwiftyGA_Chromosome] = [SwiftyGA_Chromosome]()
    //Best chromosome
    var bestChromosome:SwiftyGA_Chromosome = SwiftyGA_Chromosome()
    var averageFitness:Double = 0.0
    //fitness function
    var fitnessFunction:SwiftyGA_FitnessFunction = SwiftyGA_FitnessFunction()
    
    init(){}
    init(swiftyGAParas:SwiftyGA_Parameters){
        self.gaParameters = swiftyGAParas
    }
    
    //Create population randomly
    func createPopulation(){
        self.chromosomes.removeAll()
        for index in 0..<self.gaParameters.populationSize{
            let c = SwiftyGA_Chromosome.init(length: self.gaParameters.chromosomeLength, geneType: self.gaParameters.geneType, alleleSet: self.gaParameters.alleleSet)
            c.genID = "0_\(index)"
            self.chromosomes.append(c)
        }
    }
    
    func calculateAllFitness(){
        var totFit = 0.0
        self.bestChromosome = self.chromosomes[0]
        for index in 0..<self.chromosomes.count{
            self.chromosomes[index].fitness = self.fitnessFunction.calculateFitness(chromosome: self.chromosomes[index])
            totFit = totFit + self.chromosomes[index].fitness
            //find best
            if SwiftyGA_Parameters.singleton.fitnessGoal == .Maximising{
                if self.chromosomes[index].fitness > self.bestChromosome.fitness{
                    self.bestChromosome = self.chromosomes[index]
                }
            }else{
                if self.chromosomes[index].fitness < self.bestChromosome.fitness{
                    self.bestChromosome = self.chromosomes[index]
                }
            }
        }
        self.averageFitness = totFit / Double(self.chromosomes.count)
    }
    
    //sum up all chromosome fitness
    func sumFitness()->Double{
        var sumFit = 0.0
        for index in 0..<self.chromosomes.count{
            sumFit = sumFit + self.chromosomes[index].fitness
        }
        return sumFit
    }
    
    
    
    func printPopulation(){
        for c in self.chromosomes{
            c.printDetail()
        }
    }
    
    
    func printAverageFitness(){
        print("Average fitness: \(self.averageFitness)")
    }
    
    
    func sortPopulationByFitness(isFromHighToLow:Bool){
        /*
         let array = [(2, "is"), (0, "Hello"), (1, "this"), (3, "Ben")]
         let sortedArray = array.sort { $0.0 < $1.0 }

         print(sortedArray) // [(0, "Hello"), (1, "this"), (2, "is"), (3, "Ben")]
         The .0 part represents the first object of the tuple.

         */
        if isFromHighToLow{
            self.chromosomes = self.chromosomes.sorted(by: { $0.fitness > $1.fitness })
        }else{
            self.chromosomes = self.chromosomes.sorted(by: { $0.fitness < $1.fitness })
        }
    }
    
    
    func survivorSelectionByFitnessBasedSelection(newOffsprings:[SwiftyGA_Chromosome]){
        var joinedChromosomeArray = self.chromosomes + newOffsprings
        if SwiftyGA_Parameters.singleton.fitnessGoal == .Maximising{
            joinedChromosomeArray = joinedChromosomeArray.sorted(by: { $0.fitness > $1.fitness })
        }else{
            joinedChromosomeArray = joinedChromosomeArray.sorted(by: { $0.fitness < $1.fitness })
        }
        let noOfChromo = self.chromosomes.count
        self.chromosomes = [SwiftyGA_Chromosome]()
        for index in 0..<noOfChromo{
            self.chromosomes.append(joinedChromosomeArray[index])
        }
    }
    
    
    
    
    
    
}

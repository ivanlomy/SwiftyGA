//
//  SwiftyGA_GAComputation.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 15/10/2020.
//

import UIKit

enum GAComputationState {
    case Init
    case Running
    case Pause
    case Finished
}


protocol SwiftyGA_GAComputationDelegate {
    func GAComputationInitCall(initPopulation:SwiftyGA_Population)
    func GAComputationFinishedCall(finalPopulation:SwiftyGA_Population)
    func GAComputationGenerationCall(currentPopulation:SwiftyGA_Population, allOffsprings: [SwiftyGA_Chromosome], atGeneration:Int)
}


class SwiftyGA_GAComputation{
    
     var gaLog = SwiftyGA_Log()
     var delegate: SwiftyGA_GAComputationDelegate?
     var population:SwiftyGA_Population = SwiftyGA_Population()
     var fitnessFunction:SwiftyGA_FitnessFunction = SwiftyGA_FitnessFunction()
     var isStopNow = false
     var runState:GAComputationState = .Init
     var generationCount = 1
     //system parameter
     let isPrintPopulationAtEachGeneration = false
    
    

    
    func pause(){
        self.runState = .Pause
    }
    
    //Can override to customise
    func run(){
                
        DispatchQueue.global(qos: .userInteractive).async {
            
            if self.runState == .Init{
                print("Write log file to: \(self.gaLog.logFileUrl.absoluteString)")
                self.generationCount = 1
                self.gaLog = SwiftyGA_Log()
                //calculate the max log generations
                //my target is 500000 chromosomes in total (maxLogChromosomeTotalGenerations)
                self.gaLog.maxLogLastGeneration = Int(SwiftyGA_Parameters.singleton.maxLogChromosomeTotalGenerations / SwiftyGA_Parameters.singleton.populationSize)
                self.population = SwiftyGA_Population.init(swiftyGAParas: SwiftyGA_Parameters.singleton)
                self.population.fitnessFunction = self.fitnessFunction
                self.population.createPopulation()
                self.population.calculateAllFitness()
                self.delegate?.GAComputationInitCall(initPopulation: self.population)
                self.gaLog.logPopulation(curPopulation: self.population, atGeneration: 0)

            }
            //make it start
            self.runState = .Running
            while (self.generationCount < SwiftyGA_Parameters.singleton.terminateGeneration) && (self.runState == .Running){
                //select parents
                let selectedParents = SwiftyGA_ParentSelection.singleton.RouletteWheelSelection(population: self.population, noOfSelectParent: SwiftyGA_Parameters.singleton.noOfSelectedParents)

                //Reproduction
                var index = 0
                var newOffspringsIndex = 0
                var allOffsprings = [SwiftyGA_Chromosome]()
                while index<selectedParents.count{
                    //crossover + mutation
                    // or no offsprings, crossover + mutation
                    if Double.random(in: 0..<1) < SwiftyGA_Parameters.singleton.crossoverRate{
                        var (offsprings1,offsprings2) = SwiftyGA_OperatorCrossover.singleton.doCrossover(paras: SwiftyGA_Parameters.singleton, parent1: selectedParents[index], parent2: selectedParents[index+1])
                        
                        //mutation
                        if SwiftyGA_Parameters.singleton.mutationRate > 0.0{
                            
                        if Double.random(in: 0..<1) < SwiftyGA_Parameters.singleton.mutationRate{
                            offsprings1 = SwiftyGA_OperatorMutation.singleton.doMutation(paras: SwiftyGA_Parameters.singleton, originalChromosome: offsprings1)
                        }
                        
                        if Double.random(in: 0..<1) < SwiftyGA_Parameters.singleton.mutationRate{
                            offsprings2 = SwiftyGA_OperatorMutation.singleton.doMutation(paras: SwiftyGA_Parameters.singleton, originalChromosome: offsprings2)
                        }
                        }

                        //put genID and fitness
                        offsprings1.genID = "\(self.generationCount)_\(newOffspringsIndex)"
                        offsprings1.fitness = self.population.fitnessFunction.calculateFitness(chromosome: offsprings1)
                        newOffspringsIndex = newOffspringsIndex + 1
                        allOffsprings.append(offsprings1)
                        
                        offsprings2.genID = "\(self.generationCount)_\(newOffspringsIndex)"
                        offsprings2.fitness = self.population.fitnessFunction.calculateFitness(chromosome: offsprings2)
                        newOffspringsIndex = newOffspringsIndex + 1
                        allOffsprings.append(offsprings2)
                    }
                    index = index + 2
                }

                //Survivor Selection
                self.population.survivorSelectionByFitnessBasedSelection(newOffsprings: allOffsprings)
                self.population.calculateAllFitness()
                self.delegate?.GAComputationGenerationCall(currentPopulation: self.population,allOffsprings:allOffsprings , atGeneration: self.generationCount)
                self.gaLog.logPopulation(curPopulation: self.population, atGeneration: self.generationCount)
                self.generationCount = self.generationCount + 1
            }

            if self.generationCount >= SwiftyGA_Parameters.singleton.terminateGeneration{
                self.runState = .Finished
                self.gaLog.writeToFile()
                self.delegate?.GAComputationFinishedCall(finalPopulation: self.population)
            }
        }
    }
    
    

    
}

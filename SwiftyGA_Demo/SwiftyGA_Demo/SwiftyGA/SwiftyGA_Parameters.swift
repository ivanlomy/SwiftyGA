//
//  SwiftyGA_Parameters.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 22/10/2020.
//

import Foundation


class SwiftyGA_Parameters{
    
    static let singleton = SwiftyGA_Parameters()
    init(){}
    
    //General parameter
    var populationSize = 100
    var chromosomeLength = 10
    var geneType:GeneType = .IntGene
    var alleleSet:[Any] = [0,1]   // define the gene value e.g. binary 0 and 1, or Int 1 to 100 etc
    
    //Reproduction parameter
    var noOfSelectedParents = 10 //must be even
    var crossoverRate:Double = 0.95
    var crossoverMethod:CrossoverMethod = .OnePointCrossoverMethod
    var mutationRate:Double = 0.05
    var mutationMethod:MutationMethod = .BitFlipMutationMethod
    var mutationMethod_subsetLength:Int = 5  // Use in SuffleMutation and InversionMutation
    
    //Fitness function parameter
    var fitnessGoal:FitnessGoal = .Minimising  //Must be specific, higher value equal better or lower value equal better
    
    //Termination
    var terminateGeneration = 10
    
    //Max log chromosome
    var maxLogChromosomeTotalGenerations = 1000000
}

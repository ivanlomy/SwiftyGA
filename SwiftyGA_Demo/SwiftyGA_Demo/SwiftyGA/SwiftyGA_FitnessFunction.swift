//
//  SwiftyGA_FitnessFunction.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 15/10/2020.
//

enum FitnessGoal {
    case Maximising
    case Minimising
}

class SwiftyGA_FitnessFunction{
    
    //should override this fitness function for problem specific
    func calculateFitness(chromosome:SwiftyGA_Chromosome)->Double{
        
        var fitness:Double = 0.00
        //demo fitness function
        
        // sum gene's value
        for index in 0..<chromosome.genes.count{
            //assume gene is int or double
            let geneValue = chromosome.genes[index] as! Int
            fitness = fitness + Double(geneValue)
        }
        return fitness
    }
}


//
//  SwiftyGA_ParentSelection.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 15/10/2020.
//

import Foundation

class SwiftyGA_ParentSelection{
    
    static let singleton = SwiftyGA_ParentSelection()
    init(){}
    
    /*
     Pseudocode
     For example, if you have a population with fitnesses [1, 2, 3, 4], then the sum is (1 + 2 + 3 + 4 = 10). Therefore, you would want the probabilities or chances to be [1/10, 2/10, 3/10, 4/10] or [0.1, 0.2, 0.3, 0.4]. If you were to visually normalize this between 0.0 and 1.0, it would be grouped like below with [red = 1/10, green = 2/10, blue = 3/10, black = 4/10]:


     0.1 ]

     0.2 \
     0.3 /

     0.4 \
     0.5 |
     0.6 /

     0.7 \
     0.8 |
     0.9 |
     1.0 /
     Using the above example numbers, this is how to determine the probabilities:

     sum_of_fitness = 10
     previous_probability = 0.0

     [1] = previous_probability + (fitness / sum_of_fitness) = 0.0 + (1 / 10) = 0.1
     previous_probability = 0.1

     [2] = previous_probability + (fitness / sum_of_fitness) = 0.1 + (2 / 10) = 0.3
     previous_probability = 0.3

     [3] = previous_probability + (fitness / sum_of_fitness) = 0.3 + (3 / 10) = 0.6
     previous_probability = 0.6

     [4] = previous_probability + (fitness / sum_of_fitness) = 0.6 + (4 / 10) = 1.0
     The last index should always be 1.0 or close to it. Then this is how to randomly select an individual:

     random_number # Between 0.0 and 1.0

     if random_number < 0.1
         select 1
     else if random_number < 0.3 # 0.3 − 0.1 = 0.2 probability
         select 2
     else if random_number < 0.6 # 0.6 − 0.3 = 0.3 probability
         select 3
     else if random_number < 1.0 # 1.0 − 0.6 = 0.4 probability
         select 4
     end if
     
     */
    
    
    func RouletteWheelSelection(population:SwiftyGA_Population, noOfSelectParent:Int)->([SwiftyGA_Chromosome]){
        let sumFitness = population.sumFitness()
        var previous_probability = 0.0
        
        //chromosome incremental probability
        var CIP:[Double] = [Double]()
        for index in 0..<population.chromosomes.count{
            let p = previous_probability + population.chromosomes[index].fitness / sumFitness
            previous_probability = p
            CIP.append(p)
        }
                
        var selectedParents = [SwiftyGA_Chromosome]()
        
        for _ in 0..<noOfSelectParent{
            let randP = Double.random(in: 0..<1)
            var index = 0
            while index<CIP.count{
                let chrCIP = CIP[index]
                if randP <= chrCIP{
                    selectedParents.append(population.chromosomes[index])
                    index = CIP.count
                }
                index = index + 1
            }
        }
        return selectedParents
    }

}


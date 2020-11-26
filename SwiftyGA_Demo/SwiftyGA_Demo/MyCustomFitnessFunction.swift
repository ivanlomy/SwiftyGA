//
//  MyCustomFitnessFunction.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 21/10/2020.
//

import Foundation
import UIKit

class MyCustomFitnessFunction: SwiftyGA_FitnessFunction{
     var allCities = [LocationCity]()
    
    //override this method to make custom fitness function
    override func calculateFitness(chromosome:SwiftyGA_Chromosome)->Double {
        var fitness:Double = 0.00
        
        //sum up each city distance
        //Euclidean distance Between 2 Points
        //c = sqr(sq(xA − xB) + sq(yA − yB))
        for index in 0..<chromosome.genes.count{
            
            if index + 1 < chromosome.genes.count{
             let pointA = self.allCities[chromosome.genes[index] as! Int].cityCenterPoint
             let pointB = self.allCities[chromosome.genes[index+1] as! Int].cityCenterPoint
             let xd = Double(pointA.x - pointB.x)
             let yd = Double(pointA.y - pointB.y)
             let abDist = sqrt((xd*xd) + (yd*yd))
             fitness = fitness + abDist
            }
        }
        return fitness
    }
}

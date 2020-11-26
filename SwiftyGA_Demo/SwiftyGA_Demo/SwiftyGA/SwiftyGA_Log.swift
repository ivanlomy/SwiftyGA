//
//  SwiftyGA_Log.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 21/10/2020.
//

import Foundation
class SwiftyGA_Log {
    
    var allDataLogDict = NSMutableDictionary()
    var appDocUrl = URL(fileURLWithPath: "")
    var logFileUrl = URL(fileURLWithPath: "")
    var maxLogLastGeneration = 1000
    
    init(){
        appDocUrl = SwiftyGA_Tools.singleton.getAppDocURL()!
        self.logFileUrl = appDocUrl.appendingPathComponent("GALog.plist", isDirectory: false).standardizedFileURL
        //print("logFileUrl=\(logFileUrl.absoluteString)")
        
        self.allDataLogDict = NSMutableDictionary()
        //construct the stucture of the logDict
        self.allDataLogDict.setValue(NSMutableArray(), forKey: "allGenerations")
    }
    

    func logPopulation(curPopulation:SwiftyGA_Population,atGeneration:Int){
        let dict = NSMutableDictionary()
        dict.setValue(atGeneration, forKey: "generationNo")
        dict.setValue(curPopulation.averageFitness, forKey: "averageFitness")
        
        //best chromosome
        let bestChromosome = NSMutableDictionary()
        bestChromosome.setValue(curPopulation.bestChromosome.genID, forKey: "genID")
        bestChromosome.setValue(curPopulation.bestChromosome.fitness, forKey: "fitness")
        bestChromosome.setValue(curPopulation.bestChromosome.genes.description, forKey: "genes")
        dict.setValue(bestChromosome, forKey: "bestChromosome")
        
        //population
        let allChromosomesArr = NSMutableArray()
        for c in curPopulation.chromosomes{
            let cDict = NSMutableDictionary()
            cDict.setValue(c.genID, forKey: "genID")
            cDict.setValue(c.fitness, forKey: "fitness")
            cDict.setValue(c.genes.description, forKey: "genes")
            allChromosomesArr.add(cDict)
        }
        dict.setValue(allChromosomesArr, forKey: "population")
        
        
        let allGenerations = self.allDataLogDict.value(forKey: "allGenerations") as! NSMutableArray
        
        // when hit the max log generation then pop the first element of the generation arrayy
        if allGenerations.count > self.maxLogLastGeneration{
            allGenerations.removeObject(at: 0)
        }
        
        
        allGenerations.add(dict)
        self.allDataLogDict.setValue(allGenerations, forKey: "allGenerations")
    }
    
    func writeToFile(){
        self.allDataLogDict.write(to: self.logFileUrl.standardizedFileURL, atomically: false)
    }
    
    func printFullLog(){
        print(self.allDataLogDict.description)
    }
    
    func getFullLogDescription()->String{
        return self.allDataLogDict.description
    }
    
    
    
}

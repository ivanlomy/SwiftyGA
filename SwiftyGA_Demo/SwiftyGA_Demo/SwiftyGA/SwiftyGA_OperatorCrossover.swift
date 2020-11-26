//
//  SwiftyGA_OperatorCrossover.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 15/10/2020.
//
import Foundation

enum CrossoverMethod {
    case OnePointCrossoverMethod
    case TwoPointCrossoverMethod
    case PMXCrossover
    case PMXCrossoverTSPRoundTrip
    case OrderCrossover
    case OrderCrossoverTSPRoundTrip
    
}


class SwiftyGA_OperatorCrossover{
    static let singleton = SwiftyGA_OperatorCrossover()
    init(){}
    

    func doCrossover(paras:SwiftyGA_Parameters,parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
        
        switch paras.crossoverMethod {
        
        case .OnePointCrossoverMethod:
            return self.OnePointCrossover(parent1: parent1, parent2: parent2)
            
        case .TwoPointCrossoverMethod:
            return self.TwoPointCrossover(parent1: parent1, parent2: parent2)
        
        case .PMXCrossover:
            return self.PMXCrossover(parent1: parent1, parent2: parent2)
        
        case .PMXCrossoverTSPRoundTrip:
            return self.PMXCrossoverTSPRoundTrip(parent1: parent1, parent2: parent2)
        
        case .OrderCrossover:
            return self.OrderCrossover(parent1: parent1, parent2: parent2)

        case .OrderCrossoverTSPRoundTrip:
            return self.OrderCrossoverTSPRoundTrip(parent1: parent1, parent2: parent2)
        }
        
    }
    

    //parent1 = p1X+p1Y and parent2 = p2X + p2Y = offspring1 = p1X+p2Y and offspring2 = p2X+p1Y
    
    func OnePointCrossover(parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
        
        //at least select the first index and last 2 index
        let randPos = Int.random(in: 1...(parent1.genes.count-1))
        let p1X = parent1.genes.prefix(upTo: randPos)
        let p1Y = parent1.genes.suffix(from: randPos)
        let p2X = parent2.genes.prefix(upTo: randPos)
        let p2Y = parent2.genes.suffix(from: randPos)
        
        let offspring1 = SwiftyGA_Chromosome()
        let offspring2 = SwiftyGA_Chromosome()
        offspring1.genes = Array(p1X + p2Y)
        offspring2.genes = Array(p2X + p1Y)
        return (offspring1,offspring2)
    }
    
    
    func TwoPointCrossover(parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
        
        let randPos1 = Int.random(in: 1...(parent1.genes.count-1))
        var randPos2 = 0
        
        repeat {
            randPos2 = Int.random(in: 1...(parent1.genes.count-1))
        } while randPos1 == randPos2
        
        var firstIndex = randPos1
        var secondIndex = randPos2
        
        if randPos1 > randPos2{
            firstIndex = randPos2
            secondIndex = randPos1
        }
        
        let offspring1 = SwiftyGA_Chromosome()
        let offspring2 = SwiftyGA_Chromosome()
        offspring1.genes = parent1.genes
        offspring2.genes = parent2.genes
        for index in firstIndex..<secondIndex{
            offspring1.genes[index] = parent2.genes[index]
            offspring2.genes[index] = parent1.genes[index]
        }
    return (offspring1,offspring2)
}
    
    
    
    //The partially mapped crossover (PMX) was proposed by Goldberg and Lingle
    //D. Goldberg and R. Lingle, “Alleles, Loci and the Traveling Salesman Problem,” in Proceedings of the 1st International Conference on Genetic Algorithms and Their Applications, vol. 1985, pp. 154–159, Los Angeles, USA.
    func PMXCrossover(parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
        
        let randPos1 = Int.random(in: 1...(parent1.genes.count-1))
        var randPos2 = 0
        
        repeat {
            randPos2 = Int.random(in: 1...(parent1.genes.count-1))
        } while randPos1 == randPos2
        
        var firstIndex = randPos1
        var secondIndex = randPos2
        
        if randPos1 > randPos2{
            firstIndex = randPos2
            secondIndex = randPos1
        }
        
        let offspring1 = SwiftyGA_Chromosome()
        let offspring2 = SwiftyGA_Chromosome()
        if SwiftyGA_Parameters.singleton.geneType == .IntGeneNotRepeat || SwiftyGA_Parameters.singleton.geneType == .IntGeneTSPRoundTrip{
            var og1 = Array(repeating: -99999, count: parent1.genes.count)
            var og2 = Array(repeating: -99999, count: parent1.genes.count)
            
            //swap two point
            var og1SwapedPart = [Int]()
            var og2SwapedPart = [Int]()
            for index in firstIndex..<secondIndex{
                og1[index] = parent2.genes[index] as! Int
                og1SwapedPart.append(og1[index])
                og2[index] = parent1.genes[index] as! Int
                og2SwapedPart.append(og2[index])
            }
            
            //prefix
            for index in 0..<firstIndex{
                let tmpG1 = parent1.genes[index] as! Int
                if og1.contains(tmpG1){
                    //use map
                    og1[index] = self.PMXCrossover_mapping_int(duplicateValue: tmpG1, topSwapedPart: og1SwapedPart, bottomSwapedPart: og2SwapedPart)
                }else{
                    // from parent1
                    og1[index] = parent1.genes[index] as! Int
                }
                
                let tmpG2 = parent2.genes[index] as! Int
                if og2.contains(tmpG2){
                    //use map
                    og2[index] = self.PMXCrossover_mapping_int(duplicateValue: tmpG2, topSwapedPart: og2SwapedPart, bottomSwapedPart: og1SwapedPart)
                }else{
                    // from parent2
                    og2[index] = parent2.genes[index] as! Int
                }
            }
            
            //suffex
            for index in secondIndex..<parent1.genes.count{
                let tmpG1 = parent1.genes[index] as! Int
                if og1.contains(tmpG1){
                    //use map
                    og1[index] = self.PMXCrossover_mapping_int(duplicateValue: tmpG1, topSwapedPart: og1SwapedPart, bottomSwapedPart: og2SwapedPart)
                }else{
                    // from parent1
                    og1[index] = parent1.genes[index] as! Int
                }
                
                let tmpG2 = parent2.genes[index] as! Int
                if og2.contains(tmpG2){
                    //use map
                    og2[index] = self.PMXCrossover_mapping_int(duplicateValue: tmpG2, topSwapedPart: og2SwapedPart, bottomSwapedPart: og1SwapedPart)
                }else{
                    // from parent2
                    og2[index] = parent2.genes[index] as! Int
                }
            }
            
            //put genes back to offspring object
            offspring1.genes = og1
            offspring2.genes = og2
        }
        
        return (offspring1,offspring2)
    }
    
    func PMXCrossover_mapping_int(duplicateValue:Int, topSwapedPart:[Int], bottomSwapedPart:[Int])->Int{
        var mappedValue = duplicateValue
        let length = topSwapedPart.count
        
        for _ in 0..<length{
            let foundIndex = topSwapedPart.firstIndex(of: mappedValue)
            if foundIndex != nil {
                mappedValue = bottomSwapedPart[foundIndex!]
            }else{
                return mappedValue
            }
        }
        return mappedValue
    }
    
   
    func PMXCrossoverTSPRoundTrip(parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
        
        //same as PMXCrossover, except the first and last node is the begining node index 0
        let tmpParent1 = SwiftyGA_Chromosome()
        tmpParent1.genes = parent1.genes
        tmpParent1.genes.removeFirst()
        tmpParent1.genes.removeLast()
        
        let tmpParent2 = SwiftyGA_Chromosome()
        tmpParent2.genes = parent2.genes
        tmpParent2.genes.removeFirst()
        tmpParent2.genes.removeLast()
        
        let (offspring1,offspring2) = self.PMXCrossover(parent1: tmpParent1, parent2: tmpParent2)
        //add back the first node index 0 to first and last genes
        offspring1.genes.insert(0, at: 0)
        offspring1.genes.append(0)
        
        offspring2.genes.insert(0, at: 0)
        offspring2.genes.append(0)
        return (offspring1,offspring2)
    }
    
    
    
    func OrderCrossover(parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
    
        let randPos1 = Int.random(in: 1...(parent1.genes.count-1))
        var randPos2 = 0
        
        repeat {
            randPos2 = Int.random(in: 1...(parent1.genes.count-1))
        } while randPos1 == randPos2
        
        var firstIndex = randPos1
        var secondIndex = randPos2
        
        if randPos1 > randPos2{
            firstIndex = randPos2
            secondIndex = randPos1
        }
        
        let offspring1 = SwiftyGA_Chromosome()
        let offspring2 = SwiftyGA_Chromosome()
        if SwiftyGA_Parameters.singleton.geneType == .IntGeneNotRepeat || SwiftyGA_Parameters.singleton.geneType == .IntGeneTSPRoundTrip {
            var og1 = Array(repeating: -99999, count: parent1.genes.count)
            var og2 = Array(repeating: -99999, count: parent1.genes.count)
            
            //keep the middle section
            var og1MiddlePart = [Int]()
            var og2MiddlePart = [Int]()
            for index in firstIndex..<secondIndex{
                
                og1[index] = parent1.genes[index] as! Int
                og1MiddlePart.append(og1[index])
                og2[index] = parent2.genes[index] as! Int
                og2MiddlePart.append(og2[index])
 
            }

            // get ordered genes from right part to left part
            var par1RightToLeftPart = [Int]()
            var par2RightToLeftPart = [Int]()
            
            for i in secondIndex..<parent1.genes.count{
                par1RightToLeftPart.append(parent1.genes[i] as! Int)
                par2RightToLeftPart.append(parent2.genes[i] as! Int)
            }
            for i in 0..<secondIndex{
                par1RightToLeftPart.append(parent1.genes[i] as! Int)
                par2RightToLeftPart.append(parent2.genes[i] as! Int)
            }
            
            //put the rest back to the offspring
            //right part offspring1
            var rightIndex = secondIndex
            while rightIndex < parent1.genes.count {
                let geneForOffspring1 = par2RightToLeftPart[0]
                if og1.contains(geneForOffspring1){
                    par2RightToLeftPart.remove(at: 0)
                }else{
                    og1[rightIndex] = geneForOffspring1
                    par2RightToLeftPart.remove(at: 0)
                    rightIndex = rightIndex + 1
                }
            }
            
            //offspring 2
            rightIndex = secondIndex
            while rightIndex < parent1.genes.count {
                let geneForOffspring2 = par1RightToLeftPart[0]
                if og2.contains(geneForOffspring2){
                    par1RightToLeftPart.remove(at: 0)
                }else{
                    og2[rightIndex] = geneForOffspring2
                    par1RightToLeftPart.remove(at: 0)
                    rightIndex = rightIndex + 1
                }
            }
            
            //left part offspring 1
            var leftIndex = 0
            while leftIndex < firstIndex {
                let geneForOffspring1 = par2RightToLeftPart[0]
                if og1.contains(geneForOffspring1){
                    par2RightToLeftPart.remove(at: 0)
                }else{
                    og1[leftIndex] = geneForOffspring1
                    par2RightToLeftPart.remove(at: 0)
                    leftIndex = leftIndex + 1
                }
            }
            
            //offspring 2
            leftIndex = 0
            while leftIndex < firstIndex {
                let geneForOffspring2 = par1RightToLeftPart[0]
                if og2.contains(geneForOffspring2){
                    par1RightToLeftPart.remove(at: 0)
                }else{
                    og2[leftIndex] = geneForOffspring2
                    par1RightToLeftPart.remove(at: 0)
                    leftIndex = leftIndex + 1
                }
            }
            
            //put genes back to offspring object
            offspring1.genes = og1
            offspring2.genes = og2
        }
        
            return (offspring1,offspring2)
        
    }
    
    
    
    func OrderCrossoverTSPRoundTrip(parent1:SwiftyGA_Chromosome, parent2:SwiftyGA_Chromosome)->(offspring1:SwiftyGA_Chromosome,offspring2:SwiftyGA_Chromosome){
    
        //same as PMXCrossover, except the first and last node is the begining node index 0
        let tmpParent1 = SwiftyGA_Chromosome()
        tmpParent1.genes = parent1.genes
        tmpParent1.genes.removeFirst()
        tmpParent1.genes.removeLast()
        
        let tmpParent2 = SwiftyGA_Chromosome()
        tmpParent2.genes = parent2.genes
        tmpParent2.genes.removeFirst()
        tmpParent2.genes.removeLast()

        let (offspring1,offspring2) = self.OrderCrossover(parent1: tmpParent1, parent2: tmpParent2)
        //add back the first node index 0 to first and last genes
        offspring1.genes.insert(0, at: 0)
        offspring1.genes.append(0)
        
        offspring2.genes.insert(0, at: 0)
        offspring2.genes.append(0)
        
        return (offspring1,offspring2)
    }
    
}

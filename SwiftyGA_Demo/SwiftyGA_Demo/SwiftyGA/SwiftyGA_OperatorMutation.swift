//
//  SwiftyGA_OperatorMutation.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 20/10/2020.
//

import Foundation


enum MutationMethod {
    case BitFlipMutationMethod
    case SwapMutationMethod
    case SuffleMutationMethod
    case InversionMutationMethod
    case SwapMutationTSPRoundTripMethod
}


class SwiftyGA_OperatorMutation{
    static let singleton = SwiftyGA_OperatorMutation()
    init(){}
    
    
    func doMutation(paras:SwiftyGA_Parameters,originalChromosome:SwiftyGA_Chromosome)->SwiftyGA_Chromosome{
        
        var resultChromosome = originalChromosome
        
        switch paras.mutationMethod {
        
        case .BitFlipMutationMethod:
            resultChromosome = self.BitFlipMutation(originalChromosome: originalChromosome, alleleSet: paras.alleleSet)
            break
            
        case .SwapMutationMethod:
            resultChromosome = self.SwapMutation(originalChromosome: originalChromosome)
            break
       
        case .SwapMutationTSPRoundTripMethod:
            resultChromosome = self.SwapMutationTSPRoundTrip(originalChromosome: originalChromosome)
            break
            
        case .SuffleMutationMethod:
            resultChromosome = self.SuffleMutation(originalChromosome: originalChromosome, subsetLength: paras.mutationMethod_subsetLength)
            break
        
        case .InversionMutationMethod:
            resultChromosome = self.InversionMutation(originalChromosome: originalChromosome, subsetLength: paras.mutationMethod_subsetLength)
            break
        }
        
        return resultChromosome
    }
    
    
    func BitFlipMutation(originalChromosome:SwiftyGA_Chromosome, alleleSet:[Any])->SwiftyGA_Chromosome{
        let mutatedChromosome = SwiftyGA_Chromosome()
        mutatedChromosome.genes = originalChromosome.genes
        let randNo = Int.random(in: 0...(alleleSet.count-1))
        let randSingleAllele = alleleSet[randNo]
        let randPoint = Int.random(in: 0...(mutatedChromosome.genes.count-1))
        mutatedChromosome.genes[randPoint] = randSingleAllele
        return mutatedChromosome
    }

    func SwapMutation(originalChromosome:SwiftyGA_Chromosome)->SwiftyGA_Chromosome{
        let mutatedChromosome = SwiftyGA_Chromosome()
        mutatedChromosome.genes = originalChromosome.genes
        let randPoint1 = Int.random(in: 0...(mutatedChromosome.genes.count-1))
        let randPoint2 = Int.random(in: 0...(mutatedChromosome.genes.count-1))
        let gene = mutatedChromosome.genes[randPoint1]
        mutatedChromosome.genes[randPoint1] =  mutatedChromosome.genes[randPoint2]
        mutatedChromosome.genes[randPoint2] = gene
        return mutatedChromosome
    }
    
    func SwapMutationTSPRoundTrip(originalChromosome:SwiftyGA_Chromosome)->SwiftyGA_Chromosome{
        let tmpChromosome = SwiftyGA_Chromosome()
        tmpChromosome.genes = originalChromosome.genes
        tmpChromosome.genes.removeFirst()
        tmpChromosome.genes.removeLast()
        let mutatedChromosome = self.SwapMutation(originalChromosome: tmpChromosome)
        mutatedChromosome.genes.insert(0, at: 0)
        mutatedChromosome.genes.append(0)
        return mutatedChromosome
    }
    
    
    func SuffleMutation(originalChromosome:SwiftyGA_Chromosome, subsetLength:Int)->SwiftyGA_Chromosome{
        let mutatedChromosome = SwiftyGA_Chromosome()
        mutatedChromosome.genes = originalChromosome.genes
        let randPoint = Int.random(in: 0...(mutatedChromosome.genes.count-subsetLength))
        let suffledSub = mutatedChromosome.genes[randPoint..<(randPoint+subsetLength)].shuffled()
        var count = 0
        for index in randPoint..<(randPoint+subsetLength){
            mutatedChromosome.genes[index] = suffledSub[count]
            count = count + 1
        }
        return mutatedChromosome
    }
    
    func InversionMutation(originalChromosome:SwiftyGA_Chromosome, subsetLength:Int)->SwiftyGA_Chromosome{
        let mutatedChromosome = SwiftyGA_Chromosome()
        mutatedChromosome.genes = originalChromosome.genes
        let randPoint = Int.random(in: 0...(mutatedChromosome.genes.count-subsetLength))
        let sub = mutatedChromosome.genes[randPoint..<(randPoint+subsetLength)]
        var count = 0
        var inverCount = (randPoint + subsetLength) - 1
        for _ in randPoint..<(randPoint+subsetLength){
            mutatedChromosome.genes[count] = sub[inverCount]
            count = count + 1
            inverCount = inverCount - 1
        }
        return mutatedChromosome
    }
    
    
    
}

//
//  SwiftyGA_Chromosome.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 14/10/2020.
//

enum GeneType {
    case IntGene
    case IntGeneNotRepeat
    case StringGene
    case DoubleGene
    case IntGeneTSPRoundTrip // e.g. [0,1,2,3,4,5,0], start and end at the begining point
}

class SwiftyGA_Chromosome{
    var genID:String = "0_0" // 0_0 means 0 generation and id 0, 3_4 means generation 3 and id 4
    var genes:[Any] = [Any]()
    var fitness:Double = -99999999999
    
    init(){}
    
    //init as random
    init(length:Int, geneType:GeneType, alleleSet:[Any]){
        //Binary Gene
        if geneType == .IntGene{
            self.genes = [Int]()
            for _ in 0..<length{
                let randNo = Int.random(in: 0...(alleleSet.count-1))
                self.genes.append(alleleSet[randNo])
            }
        }
        
        if geneType == .IntGeneNotRepeat{
            if length>alleleSet.count{
                //this is incorrect setting, length must be shorter than alleleset length
                for _ in 0..<length{
                    self.genes.append(-99999999)
                }
            }else{
                //assign random value from set
                var copyAlleleSet = alleleSet
                for _ in 0..<length{
                    let randNo = Int.random(in: 0...(copyAlleleSet.count-1))
                    self.genes.append(copyAlleleSet.remove(at: randNo))
                }
            }
        }
        
        
        
        if geneType == .IntGeneTSPRoundTrip{
            //alleleSet must be less than length + 1 (extra last node back to the begining node)
            if length>alleleSet.count+1{
                //this is incorrect setting, length must be shorter than alleleset length
                for _ in 0..<length{
                    self.genes.append(-99999999)
                }
            }else{
                //assign random value from set
                var copyAlleleSet = alleleSet
                
                //first gene
                let firstCity = copyAlleleSet.remove(at: 0)
                self.genes.append(firstCity)
                
                for _ in 1..<length-1{
                    let randNo = Int.random(in: 0...(copyAlleleSet.count-1))
                    self.genes.append(copyAlleleSet.remove(at: randNo))
                }
                self.genes.append(firstCity)
                print("")
            }
        }
        
    }

    
    
    
    
    
    func printDetail(){
        print("genID=\(self.genID), fitness=\(self.fitness), genes=\(self.genes)")
    }
    
    func detailStr(isPrintGenes:Bool)->String{
        if isPrintGenes{
            return "genID=\(self.genID), fitness=\(self.fitness), genes=\(self.genes)"
        }else{
            return "genID=\(self.genID), fitness=\(self.fitness)"
        }
       

    }
    
}

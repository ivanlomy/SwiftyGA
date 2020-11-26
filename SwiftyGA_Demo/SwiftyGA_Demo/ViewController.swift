//
//  ViewController.swift
//  SwiftyGA_Demo
//
//  Created by Lo Man Yat on 26/11/2020.
//

import UIKit

class ViewController: UIViewController, SwiftyGA_GAComputationDelegate {
    func GAComputationInitCall(initPopulation: SwiftyGA_Population) {
        self.tvStr = "\(self.tvStr)\n*** Init ***"
        DispatchQueue.main.async {
            self.tv.text = self.tvStr
        }
        
    }
    
    func GAComputationFinishedCall(finalPopulation: SwiftyGA_Population) {
        self.tvStr = "\(self.tvStr)\n*** Finished ***"
        DispatchQueue.main.async {
            self.tv.text = self.tvStr
            self.showSimpleAlertBox(vc: self, title: "Finished", message: "", okBtnString: "ok")
        }
    }
    
    func GAComputationGenerationCall(currentPopulation: SwiftyGA_Population, allOffsprings: [SwiftyGA_Chromosome], atGeneration: Int) {
        self.tvStr = "\(self.tvStr)\n*** Generation \(atGeneration) ***"
        self.tvStr = "\(self.tvStr)\nBest fitness = \(currentPopulation.bestChromosome.fitness)"
        self.tvStr = "\(self.tvStr)\nBest chromosome = \(currentPopulation.bestChromosome.genes)\n"
        DispatchQueue.main.async {
            self.tv.text = self.tvStr
        }
    }
    

    
    @IBOutlet weak var tv: UITextView!
    var gaComputation = SwiftyGA_GAComputation()
    var tvStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func maxProblemPressed(_ sender: UIButton) {
        self.tvStr = "--- Max Value Problem ---\n"
        self.tv.text = self.tvStr
        //Parameters
        SwiftyGA_Parameters.singleton.geneType = .IntGene
        SwiftyGA_Parameters.singleton.crossoverMethod = .OnePointCrossoverMethod
        SwiftyGA_Parameters.singleton.crossoverRate = 0.9
        SwiftyGA_Parameters.singleton.mutationMethod = .SwapMutationMethod
        SwiftyGA_Parameters.singleton.mutationMethod_subsetLength = 1
        SwiftyGA_Parameters.singleton.mutationRate = 0.05
    
        //Fitness
        SwiftyGA_Parameters.singleton.fitnessGoal = .Maximising
        //Max log chromosome
        SwiftyGA_Parameters.singleton.maxLogChromosomeTotalGenerations = 50000
        
        //Chromosome Allele Set
        SwiftyGA_Parameters.singleton.chromosomeLength = 20
        SwiftyGA_Parameters.singleton.alleleSet = Array(0...10) //number 0 - 10
        
        SwiftyGA_Parameters.singleton.populationSize = 500
        SwiftyGA_Parameters.singleton.noOfSelectedParents = 200 //must be Even number
        SwiftyGA_Parameters.singleton.terminateGeneration = 100
        
        
        //Create GA Computation and Run
        self.gaComputation = SwiftyGA_GAComputation()
        self.gaComputation.delegate = self
        let defaultFitFunc = SwiftyGA_FitnessFunction()
        self.gaComputation.fitnessFunction = defaultFitFunc
        self.gaComputation.run()
    }
    
    @IBAction func toyTSPPressed(_ sender: UIButton) {
        self.tvStr = "--- Toy Travel Salesman Problem ---\n"
        self.tv.text = self.tvStr
        
        //General parameter
        SwiftyGA_Parameters.singleton.geneType = .IntGeneTSPRoundTrip
        SwiftyGA_Parameters.singleton.crossoverMethod = .PMXCrossoverTSPRoundTrip
        SwiftyGA_Parameters.singleton.crossoverRate = 0.9
        SwiftyGA_Parameters.singleton.mutationMethod = .SwapMutationTSPRoundTripMethod
        SwiftyGA_Parameters.singleton.mutationMethod_subsetLength = 1
        SwiftyGA_Parameters.singleton.mutationRate = 0.05
        
        //Fitness
        SwiftyGA_Parameters.singleton.fitnessGoal = .Minimising
        
        //Max log chromosome
        SwiftyGA_Parameters.singleton.maxLogChromosomeTotalGenerations = 5000
        
        SwiftyGA_Parameters.singleton.populationSize = 60
        SwiftyGA_Parameters.singleton.noOfSelectedParents = 30 //must be Even number
        SwiftyGA_Parameters.singleton.terminateGeneration = 100
        
        
        //Test data
        var cities:[LocationCity] = [LocationCity]()
        cities.append(LocationCity(centerPoint: CGPoint(x: 0, y: 0), cityIndex: 0))
        cities.append(LocationCity(centerPoint: CGPoint(x: 100, y: 0), cityIndex: 1))
        cities.append(LocationCity(centerPoint: CGPoint(x: 0, y: 50), cityIndex: 2))
        cities.append(LocationCity(centerPoint: CGPoint(x: 100, y: 50), cityIndex: 3))
        cities.append(LocationCity(centerPoint: CGPoint(x: 0, y: 100), cityIndex: 4))
        cities.append(LocationCity(centerPoint: CGPoint(x: 100, y: 100), cityIndex: 5))
        cities.append(LocationCity(centerPoint: CGPoint(x: 0, y: 150), cityIndex: 6))
        cities.append(LocationCity(centerPoint: CGPoint(x: 100, y: 150), cityIndex: 7))
        cities.append(LocationCity(centerPoint: CGPoint(x: 0, y: 200), cityIndex: 8))
        cities.append(LocationCity(centerPoint: CGPoint(x: 100, y: 200), cityIndex: 9))
        
        SwiftyGA_Parameters.singleton.chromosomeLength = cities.count + 1 // becasue round trip
        SwiftyGA_Parameters.singleton.alleleSet = Array(0...cities.count-1)
        
        //Fitness function
        let myCustomFitnessFunction = MyCustomFitnessFunction()
        myCustomFitnessFunction.allCities = cities
        
        //Create GA Computation and Run
        self.gaComputation = SwiftyGA_GAComputation()
        self.gaComputation.delegate = self
        self.gaComputation.fitnessFunction = myCustomFitnessFunction
        self.gaComputation.run()
        
    }
    


    
    @IBAction func exportLogPlistPressed(_ sender: UIButton) {
        if self.checkFileExistInDoc(filePathNameUrl: self.gaComputation.gaLog.logFileUrl.standardizedFileURL){
            let fileToShare = self.gaComputation.gaLog.logFileUrl.standardizedFileURL
             let activityViewController = UIActivityViewController(activityItems: [fileToShare], applicationActivities: nil)
             
             
             if UIDevice.current.userInterfaceIdiom == .pad{
                        if let popoverController = activityViewController.popoverPresentationController {
                            popoverController.sourceView = self.view //to set the source of your alert
                            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
                        }
                    }
             
             
             activityViewController.completionWithItemsHandler = { activity, success, items, error in
                 
                 if success{
                     self.showSimpleAlertBox(vc: self, title: "Done", message: "", okBtnString: "Ok")
                 }else{
                     if error != nil{
                         self.showSimpleAlertBox(vc: self, title: "Error", message: "", okBtnString: "Ok")
                     }
                 }
                 
             }
             
           self.present(activityViewController, animated: true, completion: nil)
        }else{
            self.showSimpleAlertBox(vc: self, title: "No result yet.", message: "", okBtnString: "ok")
        }
        
    }
    
    
    //Extra Tools
    func showSimpleAlertBox(vc:UIViewController, title:String, message:String, okBtnString:String){
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: okBtnString, style: .default, handler: { [weak alert] (_) in
               }))
               vc.present(alert, animated: true, completion: nil)
    }
    
    //Check file (with ext), folder, e.g filename can be /newFolder/xxx.jpg
    func checkFileExistInDoc(filePathNameUrl:URL)->Bool{
       if FileManager.default.fileExists(atPath: filePathNameUrl.path) {
            return true
        } else {
            return false
        }
    }
}


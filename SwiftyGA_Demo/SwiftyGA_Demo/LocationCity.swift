//
//  LocationCity.swift
//
//  Created by Lo Man Yat on 28/10/2020.
//

import UIKit

class LocationCity {

    var cityIndex = 0 //name and index on array
    var cityCenterPoint = CGPoint(x: 0.00, y: 0.00)
    
    init(centerPoint:CGPoint,cityIndex:Int){
        self.cityCenterPoint = centerPoint
        self.cityIndex = cityIndex
    }
    /*
    func initCity(centerPoint:CGPoint,cityIndex:Int){
        self.cityCenterPoint = centerPoint
        self.cityIndex = cityIndex
    }
 */
    
}

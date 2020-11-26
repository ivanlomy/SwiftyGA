//
//  SwiftyGA_Tools.swift
//  SwiftGA
//
//  Created by Lo Man Yat on 14/10/2020.
//

import UIKit
import AVFoundation

class SwiftyGA_Tools {

    static let singleton = SwiftyGA_Tools()
    private init(){}
    
    //File
    func getAppDocURL() ->URL?{
        if let url=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            return url
        }else{
            return nil
        }
    }
    
    func getAppLibURL() ->URL?{
        if let url=FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first{
               return url
           }else{
               return nil
           }
       }
    
    func getAppTmpURL() ->URL?{
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
        isDirectory: true)
        return temporaryDirectoryURL.standardizedFileURL
       }

}

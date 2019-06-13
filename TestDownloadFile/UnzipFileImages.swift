//
//  UnzipFileImages.swift
//  Wht
//
//  Created by eduardo fulgencio on 10/05/2019.
//  Copyright © 2019 Setfile. All rights reserved.
//

import UIKit
import ZIPFoundation


class UnzipFileImages: NSObject {

    class func unZipFileWithImagesFromResources()
    {
        let fileName = "images"
        let fileType = "zip"
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let pathWorkingDirectory = documentsPath.appendingPathComponent("imagesiOS")
            do {
                let documentsPath = URL(fileURLWithPath: filePath)
                try FileManager.default.unzipItem(at: documentsPath, to: pathWorkingDirectory)
            } catch {
                return
            }
        }
    }
    
    class func unZipFileWithImagesFromResourcesForUpdate()
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent("imagesupdate.zip")
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let pathWorkingDirectory = documentsPath.appendingPathComponent("imagesiOSupdate")
        do {
            try FileManager.default.unzipItem(at: URL(fileURLWithPath: destinationUrl.relativePath), to: pathWorkingDirectory)
        } catch {
            return
        }
    }
}

//
//  ViewController.swift
//  TestDownloadFile
//
//  Created by Eduardo Fulgencio on 13/06/2019.
//  Copyright © 2019 Eduardo Fulgencio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Tengo que descargar un fichero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ubicacion = URL(string: "http://setfilecloud.com/mangrana/wtswrngiOS/imagesZipiOS/images.zip")
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent("imagesupdate.zip")
        // Descargo y descomprimo
        Downloader.load(url: ubicacion!, to: destinationUrl) {
            UnzipFileImages.unZipFileWithImagesFromResourcesForUpdate()
            self.copyOrReplaceImage()
        }
    }
    
    func copyOrReplaceImage() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let origen = documentsURL.appendingPathComponent("imagesiOSupdate")
        let destino = documentsURL.appendingPathComponent("imagesiOS")
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: origen, includingPropertiesForKeys: nil)
            
            for file in fileURLs {
                
                let itemDestino =  URL(string: "\(destino)\(file.lastPathComponent)")
                if (fileManager.fileExists(atPath: itemDestino!.relativePath)) {
                    _ =  try fileManager.replaceItemAt(itemDestino!, withItemAt: file)
                } else {
                    try fileManager.copyItem(at: file, to: itemDestino!)
                }
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
}


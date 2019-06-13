//
//  UnzipFileImages.swift
//  Wht
//
//  Created by eduardo fulgencio on 10/05/2019.
//  Copyright © 2019 Setfile. All rights reserved.
//

import UIKit


class UnzipFileImages: NSObject {
    
    class func unZipFileWithImagesFromResources()
    {
        let fileName = "images"
        let fileType = "zip"
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let pathWorkingDirectory = documentsPath.appendingPathComponent("imagesiOS")
            do {
                // Descomprimer el fichero zip
                let documentsPath = URL(fileURLWithPath: filePath)
                try FileManager.default.unzipItem(at: documentsPath, to: pathWorkingDirectory)
            } catch {
                print("Extraction images of Zip archive failed with error: \(error)")
                return
            }
        }
    }
    
    
    
    class func unZipFileWithImagesForUpdate() {
        
        let fileNameUpdate = "images"
        let fileTypeUpdate = "zip"
        
        if let filePathUpdate = Bundle.main.path(forResource: fileNameUpdate, ofType: fileTypeUpdate) {  // actualizo si hay imagenes
            // Si hay alguna modificación descargo y desempaqueto
            // voy a probar el descomprimir
            let documentsPathUpdate = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let pathWorkingDirectoryUpdate = documentsPathUpdate.appendingPathComponent("imagesiOS/imagesupdate.zip")
            
            let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let pathWorkingDirectory = documentsPath.appendingPathComponent("imagesiOS/update")
            let pathWorkingDirectoryDest = documentsPath.appendingPathComponent("imagesiOS/images")
            
            do {
                // Descomprimer el fichero zip
             //let documentsPath = URL(fileURLWithPath: pathWorkingDirectoryUpdate)
           //  try FileManager.default.unzipItem(at: pathWorkingDirectoryUpdate, to: pathWorkingDirectory)
                
                do {
                    // Donde estan la imagenes nuevas
                    //
                    
                    let fileManager = FileManager.default
                    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let origen = documentsURL.appendingPathComponent("imagesiOS").appendingPathComponent("update")
                    do {
                        let fileURLs = try fileManager.contentsOfDirectory(at: origen, includingPropertiesForKeys: nil)
                        let destino = pathWorkingDirectoryDest.absoluteString
                        
                        for file in fileURLs {
                            let itemDestino =  "\(destino)\(file.lastPathComponent)"
                            copyItem(at: file,to: URL(fileURLWithPath: itemDestino))
                        }
                        // process files
                        
                    } catch {
                        print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
                    }
//
//                    var destino = pathWorkingDirectory.absoluteString
//                    var item = ""
//
//                    let filelist = try fileManager.contentsOfDirectory(atPath: pathWorkingDirectory.absoluteString)
//                    for filename in filelist {
//                        destino = "\(pathWorkingDirectoryDest)/\(filename)"
//                        item = "\(pathWorkingDirectory.absoluteString)/\(filename)"
//                        try? FileManager.default.replaceItemAt(URL(fileURLWithPath: destino ),
//                                    withItemAt: URL(fileURLWithPath: item))
//                    }
                } catch {
                    print("\nError\n")
                }
                
              //  FileManager.copyItem(atPath: String, toPath: <#T##String#>)
            } catch {
                print("Extraction images of Zip archive failed with error: \(error)")
                return
            }
            
            
            
            // No ejecutar todavia
            if (RequestServices.shared.iOSNameImatgesZip == "" && false) {
                let url = NSURL(string: "http://www.mywebsite.com/myfile.pdf")
                loadFileAsync(url: url! as URL) { (path, error) in
                    // codigo.
                    // Si no da error puedo descomprimir
                }
            }
        }
        
    }
    
    
    class func copyItem(at srcURL: URL, to dstURL: URL) {
        do {
            let fileManager = FileManager.default
            if (fileManager.isWritableFile(atPath: dstURL.absoluteString)){
                print("yes")
            }
            try fileManager.copyItem(at: srcURL, to: dstURL)
        } catch let error as NSError {
            if error.code == NSFileWriteFileExistsError {
                print("File exists. Trying to replace")
                replaceItem(at: dstURL, with: srcURL)
            }
            replaceItem(at: dstURL, with: srcURL)
        }
    }
    
    class func replaceItem(at dstURL: URL, with srcURL: URL) {
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: dstURL)
            copyItem(at: srcURL, to: dstURL)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
                request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
    
    

}


/*
 do {
 let fileURLs = try fileManager.contentsOfDirectory(at: origen, includingPropertiesForKeys: nil)
 let destino = pathWorkingDirectoryDest.absoluteString
 
 for file in fileURLs {
 let itemDestino =  "\(destino)\(file.lastPathComponent)"
 let fileExists = fileManager.fileExists(atPath: itemDestino)
 print(fileExists)
 do {
 
 
 if fileManager.fileExists(atPath: itemDestino) {
 _ = try fileManager.replaceItemAt(URL(fileURLWithPath:itemDestino), withItemAt: file)
 }
 
 _ = try fileManager.replaceItemAt(URL(fileURLWithPath: itemDestino ), withItemAt: file)
 
 try fileManager.replaceItem(at: URL(fileURLWithPath: itemDestino), withItemAt: file, backupItemName: nil, options: FileManager.ItemReplacementOptions.init(), resultingItemURL: nil)
 } catch {
 print(error.localizedDescription)
 }
 
 }
 // process files
 
 } catch {
 print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
 }
 
 */

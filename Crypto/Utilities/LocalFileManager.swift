//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Lokesh on 31/01/22.
//

import Foundation
import UIKit
class LocalFileManager{
    static let instance = LocalFileManager()
    
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        createFolderIfNeede(folderName: folderName)
        guard
            let data = image.pngData(),
            let url = getURLforImage(imageName: imageName, folderName: folderName)
        else{return}
        do{
            try data.write(to: url)
        }catch let error{
            print("Error saving image Name:\(imageName) : \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage?{
        guard
            let url = getURLforImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {return nil}
        return UIImage.init(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeede(folderName: String){
        guard let folderUrl = getURLforFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: folderUrl.path){
            do{
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            }catch let error{
                print("Failed to create directory FolderName: \(folderName) : \(error)")
            }
        }
    }
    
    private func getURLforFolder(folderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLforImage(imageName: String, folderName: String) -> URL?{
        guard let folderUrl = getURLforFolder(folderName: folderName) else {return nil}
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
    
}

//
//  DashboardViewController.swift
//  MetaData
//
//  Created by Pawan  on 25/11/2020.
//

import UIKit
import Photos
import PhotosUI
import Foundation
import ImageIO// CGImage functions
import MobileCoreServices

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tbView: UITableView!
    
    var myArray = [String]()
    var valueArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.delegate = self
        tbView.dataSource = self
        
        tbView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "tbcell")
        
    }
    @IBAction func uploadImageButton(_ sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        present(myPickerController, animated: true)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
}
extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let imgselect = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = imgselect
            
            //Image File Size
            let imgData: NSData = NSData(data: (imgselect).jpegData(compressionQuality: 1)!)
            let imageSize: Int = imgData.length
            print("size of image in KB: %f ", Double(imageSize) / 1024.0)
            
            //Image get file extension
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            print(fileUrl.pathExtension)     // get file extension
            
            //Image Name
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                print(assetResources.first!.originalFilename)
            }
            
            //Image all MeteData
            let assetURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
            guard let result = asset.firstObject else { return }
            let imageManager = PHImageManager.default()
            imageManager.requestImageData(for: result , options: nil, resultHandler:{
                (data, responseString, imageOriet, info) -> Void in
                let imageData: NSData = data! as NSData
                if let imageSource = CGImageSourceCreateWithData(imageData, nil) {
                    let imageProperties2 = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                    var EXIFDictionary = (imageProperties2[(kCGImagePropertyExifDictionary)]) as? [String: Any]
                    //   print("Before EXIFDictionary" , EXIFDictionary)
                   // EXIFDictionary![(kCGImagePropertyExifLensModel as String)] = "Hello Image"
                   // var name = EXIFDictionary![(kCGImagePropertyExifLensModel as String)] = "Umer Khan Mobile"
                 //   EXIFDictionary![(kCGImagePropertyExifFocalLength as String)] = "No Idea"
                    //  print("After EXIFDictionary" , EXIFDictionary!)
                    //  print("imageProperties2: ", imageProperties2)
                    for (key, value) in EXIFDictionary! as [String : Any] {
                        //     print("Hello")
                        print("\(key) : \(value)")
                        //     print("End")
                        DispatchQueue.main.async {
                            guard let key = key as? String else { return }
                            guard let value = value as? String else { return }
                            self.myArray.append(key)
                            self.valueArray.append(value)
                //          print("Values :- ", value)
                            self.tbView.reloadData()
                        }
                    }
                }
            })
            dismiss(animated: true, completion: nil)
        }
    }
}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
        return valueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "tbcell", for: indexPath) as! DashboardTableViewCell
        
        cell.lblName.text = myArray[indexPath.row] as? String
        cell.value.text   = valueArray[indexPath.row] as? String
        
        return cell
    }
}



//                    let TEST_IMAGE: String = "1"
//                    let beach: UIImage = UIImage(named: TEST_IMAGE)!
//                    let imageData: Data = beach.jpegData(compressionQuality: 1)!
//
//                    let cgImgSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
//                    let uti: CFString = CGImageSourceGetType(cgImgSource)!
//                    let dataWithEXIF: NSMutableData = NSMutableData(data: imageData)
//                    let destination: CGImageDestination = CGImageDestinationCreateWithData((dataWithEXIF as CFMutableData), uti, 1, nil)!
//
//
//                    let imageProperties = CGImageSourceCopyPropertiesAtIndex(cgImgSource, 0, nil)! as NSDictionary
//                    let mutable: NSMutableDictionary = imageProperties.mutableCopy() as! NSMutableDictionary
//
//                    var _: NSMutableDictionary = (mutable[kCGImagePropertyExifDictionary as String] as? NSMutableDictionary)!
//
//                    print("before modification \(EXIFDictionary)")
//
//                    EXIFDictionary![kCGImagePropertyExifUserComment as String] = "type:video"
//
//                    mutable[kCGImagePropertyExifDictionary as String] = EXIFDictionary
//
//                    CGImageDestinationAddImageFromSource(destination, cgImgSource, 0, (mutable as CFDictionary))
//                    CGImageDestinationFinalize(destination)
//
//                    let testImage: CIImage = CIImage(data: dataWithEXIF as Data, options: nil)!
//                    let newproperties: NSDictionary = testImage.properties as NSDictionary
//
//                    print("after modification newproperties \(newproperties)")

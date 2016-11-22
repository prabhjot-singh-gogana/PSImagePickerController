//
//  ViewController.swift
//  PSImagePicker
//
//  Created by prabhjot singh on 7/13/16.
//  Copyright © 2016 Prabhjot Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imager: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toOpenImagePicker(_ sender: AnyObject) {
        let picker = PSImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.openImagePicker({ (image, imageController, success) in
            if success == true {
                self.imager.image = image
            }
            
            }, controller: self)
    }

    @IBAction func toOpenActionSheetImagePicker(_ sender: AnyObject) {
        
        PSImagePickerController().openImagePickerThroughActionSheet({ (image, imageController, success) in
            
            if success == true {
                self.imager.image = image
            }
            
            }, controller: self)
    }
}


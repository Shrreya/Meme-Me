//
//  ViewController.swift
//  MemeMe
//
//  Created by Shrreya Bhatachaarya on 04/11/16.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK : Properties
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var mySelectedImage: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func shareMeMe(_ sender: AnyObject) {
        //Create the MeMe and store it in the global Array of MeMe's
        let memeImage = generateMemedImage()
        let meme = MeMe(
            topText: topText.text!,
            bottomText: bottomText.text!,
            originalImage: mySelectedImage.image!,
            memeImage: memeImage
        )
        
        //pass the generated image to the ActivityView
        let myActivityView = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.present(myActivityView, animated: true, completion: nil)
        myActivityView.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success == true) {
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0
    ] as [String : Any]
    
    let defaultText = "TYPE HERE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        topText.backgroundColor = UIColor.clear
        bottomText.backgroundColor = UIColor.clear
        topText.borderStyle = UITextBorderStyle.none
        bottomText.borderStyle = UITextBorderStyle.none
        topText.isHidden = true
        bottomText.isHidden = true
        
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.isHidden = false
        
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let myImagePicker = UIImagePickerController()
            myImagePicker.delegate = self
            myImagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(myImagePicker, animated: true, completion: nil)
        }
        else {
            print("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        mySelectedImage.image = myImage
        self.showDefaultText()
        messageLabel.isHidden = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == defaultText) {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text == "") {
            textField.text = defaultText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showDefaultText() {
        topText.isHidden = false
        bottomText.isHidden = false
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow)    , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide)    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        /*if bottomText.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }*/
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //self.view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    /*func save() {
        //Create the meme
        var meme = Meme( text: textField.text!, image:
            imageView.image, memedImage: memedImage)
    }*/
    
    func generateMemedImage() -> UIImage {
        //hide the navigationitems before taking a "snapshot"
        bottomToolbar.isHidden = true
        navigationBar.isHidden = true
    
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        //"snapshot" taken, time to bring back the navigationitems
        bottomToolbar.isHidden = false
        navigationBar.isHidden = false
            
        return memedImage
    }

}


//
//  Meme.swift
//  MemeMe
//
//  Created by Shrreya Bhatachaarya on 08/11/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit

struct MeMe {
    
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memeImage : UIImage
    
    init (topText : String, bottomText : String, originalImage : UIImage, memeImage : UIImage){
        self.bottomText = bottomText
        self.topText = topText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }

}

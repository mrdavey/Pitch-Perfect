//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by David Truong on 12/04/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathURL: NSURL!
    var title: String!

    init(filePath: NSURL, titleOfFile: String) {
        filePathURL = filePath
        title = titleOfFile
    }

}
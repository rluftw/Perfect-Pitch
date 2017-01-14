//
//  RecordedAudio.swift
//  Perfect Pitch
//
//  Created by Xing Hui Lu on 2/3/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var fileURL: URL!
    var title: String!
    
    init(fileURL: URL, title: String) {
        self.fileURL = fileURL
        self.title = title
    }
}

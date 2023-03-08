//
//  TitlePreviewViewModel.swift
//  Netflix
//
//  Created by Aykut ATABAY on 1.02.2023.
//

import Foundation


class TitlePreviewViewModel {
    let title: String
    let youtubeView: VideoElement
    let titleOverview: String
    
    init(title: String, youtubeView: VideoElement, titleOverview: String) {
        self.title = title
        self.youtubeView = youtubeView
        self.titleOverview = titleOverview
    } 
}

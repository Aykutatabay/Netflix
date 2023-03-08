//
//  TitleViewModel.swift
//  Netflix
//
//  Created by Aykut ATABAY on 31.01.2023.
//

import Foundation


class TitleViewModel {
    let titleName: String
    let posterUrl: String
    init(titleName: String, posterUrl: String) {
        self.titleName = titleName
        self.posterUrl = posterUrl
    }
}

//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by 강민성 on 2021/06/14.
//

import Foundation

enum ProfileVIewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileVIewModelType
    let title: String
    let handler: (() -> Void)?
}

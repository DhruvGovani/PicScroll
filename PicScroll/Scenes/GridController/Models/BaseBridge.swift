//
//  BaseBridge.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import Foundation

protocol BaseBridge: NSObject{
    func didLoadData(_ bridge: BaseBridge?)
    func didFailedToLoadData(_ bridge: BaseBridge?, errorMessage: String)
}

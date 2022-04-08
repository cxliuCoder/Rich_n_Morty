//
//  ViewController+RM.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

extension UIViewController {
    
    /// Make sure the task is run on main thread
    func performTaskOnMainThread(_ task: @escaping () -> ()) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }
}

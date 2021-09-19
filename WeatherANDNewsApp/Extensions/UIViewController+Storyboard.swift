//
//  UIViewController+Storyboard.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 26.07.21.
//

import UIKit

extension UIViewController {
    
    func getViewController (from storyBoard: String, and storyBoardID: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyBoard, bundle: nil)
        let currentViewController = storyBoard.instantiateViewController(withIdentifier: storyBoardID)
        return currentViewController
    }
    
}


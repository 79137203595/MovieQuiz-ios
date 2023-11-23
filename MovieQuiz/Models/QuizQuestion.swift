//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 20.11.2023.
//

import Foundation
import UIKit
//struct QuizQuestion {
//    let imageData: Data
//    let image: UIImage?
//    let text: String
//    let correctAnswer: Bool
//    
//    init(imageURL: URL, text: String, correctAnswer: Bool) {
//        self.text = text
//        self.correctAnswer = correctAnswer
//        
//        do {
//            self.imageData = try Data(contentsOf: imageURL)
//            self.image = UIImage(data: self.imageData)
//        } catch {
//            // Handle the error or set a default value for imageData and image
//            print("Error: Unable to load image data from the URL")
//            self.imageData = Data()
//            self.image = nil
//        }
//    }
//}


struct QuizQuestion {
    //let imageData = try Data(contentsOf: someImageURL) // try, потому что загрузка данных по URL может быть и не успешной
    let image: Data
    let text: String
    let correctAnswer: Bool
    
}


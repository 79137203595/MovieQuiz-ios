//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 20.11.2023.
//

import Foundation
import UIKit

struct QuizQuestion {
    //let imageData = try Data(contentsOf: someImageURL) // try, потому что загрузка данных по URL может быть и не успешной
    let image: Data
    let text: String
    let correctAnswer: Bool
}


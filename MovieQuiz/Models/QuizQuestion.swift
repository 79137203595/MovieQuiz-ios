//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 06.11.2023.
//

import Foundation
import UIKit 
// структура для преобразования моков во вью модель
struct QuizQuestion {
    // постер фильма
    let image: String
    // вопрос о рейтинге фильма
    let text: String
    // правильный ответ
    let correctAnswer: Bool
}

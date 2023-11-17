//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 06.11.2023.
//

import UIKit 
protocol QuestionFactoryProtocol {
     func requestNextQuestion() -> QuizQuestion?
 }

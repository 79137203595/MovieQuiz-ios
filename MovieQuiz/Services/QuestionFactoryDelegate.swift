//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 07.11.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    var delegate: QuestionFactoryDelegate? {get set}
}

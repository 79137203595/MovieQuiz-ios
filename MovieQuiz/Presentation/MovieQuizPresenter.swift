//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 26.11.2023.
//

import Foundation
import UIKit
final class MovieQuizPresenter {
    var questionsCount = 10
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsCount - 1
        }
        
        func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
        
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
    }
    
    
    func yesButtonClicked() {
            didAnswer(isYes: true)
        }

        func noButtonClicked() {
            didAnswer(isYes: false)
        }

        private func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }

            let givenAnswer = isYes

            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
    
    
}

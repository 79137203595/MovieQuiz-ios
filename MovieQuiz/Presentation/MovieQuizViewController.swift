import UIKit
import SwiftUI

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet private var activityIndicator:UIActivityIndicatorView!
    // MARK: - Private Properties
    
    private let presenter = MovieQuizPresenter()
    
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryImpl?
   
   
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
            questionFactory = QuestionFactoryImpl (moviesLoader: MoviesLoader(), delegate: self)
            showLoadingIndicator()
        presenter.viewController = self
        questionFactory?.loadData()
        
        //questionFactory = QuestionFactoryImpl(delegate: self)
        
        alertPresenter = AlertPresenterImpl(viewController: self)
        statisticService = StatisticServiceImpl()
        
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23.0)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        questionFactory?.requestNextQuestion()
        
    }
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - View Life Cycles
    private  struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    // MARK: - Private Methods
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
//    }
    //        let questionStep = QuizStepViewModel(
    //            image: UIImage(named: model.image) ?? UIImage(),
    //            question: model.text,
    //            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
    //        return questionStep
    //    }
    
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            presenter.correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            guard let self = self else {
                return
            }
            self.presenter.showNextQuestionOrResults()
            self.presenter.questionFactory = self.questionFactory
        }
    }
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//        } else {
//            presenter.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//            imageView.layer.borderWidth = 0
//            imageView.layer.borderColor = UIColor.clear.cgColor
//        }
//    }
    
    private func makeResultMessage() -> String {
        
        guard let statisticService  = statisticService,
              let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return (" ")
        }
        let totalPlaysCountLine = " Количество сыгранных квизов: \(String(describing: statisticService.gamesCount))"
        let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \( String(format: "%.2f", statisticService.totalAccuracy))%"
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        return resultMessage
    }
    private func showFinalResults(){
        statisticService?.store(correct: presenter.correctAnswers, tital: presenter.questionsCount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен! ",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз",
            buttonAction: { [ weak self] in
                self?.presenter.resetQuestionIndex()
                self?.presenter.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
    }
    private func showNetworkError(message:String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: " Попробовать еще раз")
        { [ weak self] in
            self?.presenter.resetQuestionIndex()
//            self?.currentQuestionIndex = 0
            self?.presenter.correctAnswers = 0
            self?.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    
}
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveQuestion(_ question: QuizQuestion) {
        presenter.didRecieveNextQuestion(question: question)
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

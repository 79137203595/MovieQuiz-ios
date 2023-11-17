//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 07.11.2023.
//

import Foundation
import UIKit
protocol AlertPresenter {
     func show(AlertModel: AlertModel)
 }

 final class AlertPresenterImpl {
     private weak var viewController: UIViewController?

     init(viewController: UIViewController? = nil) {
         self.viewController = viewController
     }
 }

 extension AlertPresenterImpl: AlertPresenter {
     func show(AlertModel: AlertModel) {
         let alert = UIAlertController(
             title: AlertModel.title,
             message: AlertModel.text,
             preferredStyle: .alert)

         let action = UIAlertAction(title: AlertModel.buttonText, style: .default) { _ in
             AlertModel.buttonAction()
         }
         alert.addAction(action)

         viewController?.present(alert, animated: true)
     }}

//
//  ChapterViewController.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import UIKit

final class LessonViewController: InjectableViewController {

    // IBOutlet properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var questionLanguage: UILabel!
    @IBOutlet weak var questionWord: UILabel!
    @IBOutlet weak var anwerLanguage: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!

    // Stored properties
    var viewModel: LessonViewModel?
    var observation: NSKeyValueObservation?
    var actionButtonType = ActionButtonType.validateAnswer {
        didSet {
            actionButton.setTitle(actionButtonType.buttonTitle, for: .normal)
        }
    }
    
    deinit {
        self.stopKeyboardObserver()
    }
}

// MARK: - View life cycle
extension LessonViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.resetData()
        
        observeLessonsData()
        viewModel?.parseLesson()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.answerTextField.drawLine(.bottom, color: AppTheme.buttonColor)
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        observation?.invalidate()
    }
}

// MARK: - Private - Setup

extension LessonViewController {
    
    private func setup() {
        self.observingKeyboard()

        setupView()
    }
    
    private func setupView() {
        self.actionButton.roundCorners()
    }
    
    private func observeLessonsData() {
        observation = viewModel?.observe(\.currentQuestion, options: [.old, .new]) { [weak self] viewModel, change in
            DispatchQueue.main.async {
                self?.displayData()
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nil, queue: nil) { [weak self] notification in
            DispatchQueue.main.async {
                guard let textField = notification.object as? UITextField, let text = textField.text else { return }
                self?.actionButton.isEnabled = !text.isEmpty
            }
        }
    }
    
    // Display quetions and answer data parsed from file
    private func displayData() {
        guard let viewModel = self.viewModel else { return }
        guard let currentQuestion =  viewModel.currentQuestion else {
            // Go to summary view
            self.presentSummaryViewController()
            return
        }

        questionLanguage.text = viewModel.questionWordLanguageString
        questionWord.text = currentQuestion.questionWord
        anwerLanguage.text = viewModel.answerWordLanguageString
        
        actionButton.setTitle(actionButtonType.buttonTitle, for: .normal)
    }
    
    // Go to summary view
    private func presentSummaryViewController() {
        let summaryVC = self.container.initiateViewController(storyboardName: StoryBoardName.main.name,
                                                              type: SummaryViewController.self)
        summaryVC.viewModel?.lesson = self.viewModel?.lesson
        self.present(summaryVC, animated: true, completion: nil)
    }
    
    private func validateAnswer() {
        guard let userAnswer = answerTextField.text?.lowercased(), !userAnswer.isEmpty else { return }
        guard let currentQuestion = self.viewModel?.currentQuestion else { return }
        
        let questionAnswer = currentQuestion.answerWord.lowercased()
        
        answerTextField.rightViewMode = .always
        
        var rightViewImage: UIImage!
        var themeColor: UIColor!

        if questionAnswer == userAnswer {
            rightViewImage = Asset.correctAnswer.image
            themeColor = AppTheme.greenColor
            currentQuestion.result.correctAnswer()
        } else {
            rightViewImage = Asset.wrongAnswer.image
            themeColor = AppTheme.redColor
            currentQuestion.result.wrongAnswer()
            answerTextField.shake()
            UIDevice.vibrate()
        }
        
        answerTextField.rightView = UIImageView(image: rightViewImage)
        answerTextField.drawLine(.bottom, color: themeColor)
        answerTextField.textColor = themeColor
        UIView.performWithoutAnimation {
            answerTextField.isEnabled = false
        }
    }
    
    private func moveToNextQuestion() {
        self.viewModel?.changeToNextQuestion()
        resetUI()
    }
    
    private func resetUI() {
        // Reset answer text-field
        answerTextField.isEnabled = true
        answerTextField.text = nil
        answerTextField.becomeFirstResponder()
        answerTextField.drawLine(.bottom, color: AppTheme.buttonColor)
        answerTextField.textColor = .black
        answerTextField.rightView = nil
        
        // Reset action button
        actionButton.isEnabled = false
    }
}


// MARK: - IBActions

extension LessonViewController {
    @IBAction func actionButtonTapped(_ button: UIButton) {
        switch actionButtonType {
        case .validateAnswer:
            validateAnswer()
        case .nextQuestion:
            moveToNextQuestion()
        }
        
        self.actionButtonType.toggle()
    }
}

// MARK: - TextField delegate
extension LessonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard handling
extension LessonViewController {
    
    func observingKeyboard() {
        
        let hideBlock: KeyboardDispatcher = {  [weak self] keyboardSize in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                guard let strongSelf = self else { return }
                let contentInset = UIEdgeInsets.zero
                strongSelf.scrollView.contentInset = contentInset
                strongSelf.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }, completion: nil)
        }
        
        let showBlock: KeyboardDispatcher = { [weak self] keyboardSize in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.3, animations: {
                var contentInset = strongSelf.scrollView.contentInset
                contentInset.bottom = keyboardSize.height
                strongSelf.scrollView.contentInset = contentInset
                
                // Scroll the view upwards to display Action Button
                let acutonButtonAbsPoint = strongSelf.actionButton.convert(strongSelf.actionButton.frame.origin, to: strongSelf.view)
                let newOffsetY = keyboardSize.height - (strongSelf.view.frame.height - acutonButtonAbsPoint.y - strongSelf.actionButton.frame.height)
                strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: false)
            })
        }
        
        self.startObservingKeyboard(viewShow: showBlock, viewHide: hideBlock)
    }
}


extension LessonViewController {
    enum ActionButtonType {
        case validateAnswer
        case nextQuestion
        
        var buttonTitle: String {
            switch self {
            case .validateAnswer: return "lesson.check.action.button.title".localized
            case .nextQuestion: return "lesson.next.action.button.title".localized
            }
        }
        
        mutating func toggle() {
            switch self {
            case .validateAnswer: self = .nextQuestion
            case .nextQuestion: self = .validateAnswer
            }
        }
    }
}

// MARK: - Constants
extension LessonViewController {
    private struct Constant {
        static let actionButtonRadius: CGFloat = 5.0
    }
}

//
//  SummaryViewController.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    // IBOutlet properties
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var correctAnswersCountLabel: UILabel!
    @IBOutlet weak var incorrectAnswersCountLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var answerResultStackView: UIStackView!

    // Computed property
    var actionType = ActionType.restart {
        didSet {
            self.actionButton.setTitle(actionType.buttonTitle, for: .normal)
        }
    }
    
    // Stored properties
    var viewModel: SummaryViewModel?
    var observation: NSKeyValueObservation?
}

// MARK: - View life cycle
extension SummaryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observeLesson()
        viewModel?.parseLesson()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        observation?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Set-up and private methods
extension SummaryViewController {
    
    private func setup() {
        setupView()
    }
    
    private func setupView() {
        self.actionButton.roundCorners()
    }
    
    private func observeLesson() {
        observation = viewModel?.observe(\.shouldUpdateView, options: [.old, .new]) { [weak self] viewModel, change in
            DispatchQueue.main.async {
                self?.displayLessonResultData()
                self?.viewModel?.writeLessonDataToFile()
            }
        }
    }
    
    private func displayLessonResultData() {
        self.headerLabel.text = viewModel?.headerLabelString
        
        if viewModel?.isLessonCompleted == true {
            answerResultStackView.isHidden = true
            self.actionType = .share
        } else {
            correctAnswersCountLabel.attributedText = viewModel?.correctAnswerLabelString
            incorrectAnswersCountLabel.attributedText = viewModel?.wrongAnswerLabelString
            self.actionType = .restart
        }
    }
    
    private func handleAction() {
        switch self.actionType {
        case .restart:
            self.dismiss(animated: true, completion: nil)
        case .share:
            self.handleShareActivity()
        }
    }
    
    private func handleShareActivity() {
        let path = (self.viewModel?.dataProvider as! FileSystemDataProvider).filePath
        let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: [])
        activityVC.excludedActivityTypes = [
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo,
            UIActivityType.postToTwitter,
            UIActivityType.postToFacebook,
            UIActivityType.openInIBooks
        ]
        self.present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - IBActions
extension SummaryViewController {
    
    @IBAction func actionButtonTapped(_ button: UIButton) {
        self.handleAction()
    }
    
    enum ActionType {
        case restart
        case share
        
        var buttonTitle: String {
            switch self {
            case .restart: return "summary.restart.action-button.title".localized
            case .share: return "summary.share.action-button.title".localized
            }
        }
    }
}

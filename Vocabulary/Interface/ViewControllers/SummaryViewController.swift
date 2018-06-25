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
            actionButton.isHidden = true
        } else {
            correctAnswersCountLabel.attributedText = viewModel?.correctAnswerLabelString
            incorrectAnswersCountLabel.attributedText = viewModel?.wrongAnswerLabelString
        }
    }
}

// MARK: - IBActions
extension SummaryViewController {
    
    @IBAction func actionButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

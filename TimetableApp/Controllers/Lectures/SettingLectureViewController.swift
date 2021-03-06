//
//  SettingLectureViewController.swift
//  TimetableApp
//
//  Created by 大西玲音 on 2021/04/24.
//

import UIKit

final class SettingLectureViewController: UIViewController {
    
    @IBOutlet private weak var lectureView: NeumorphismView!
    @IBOutlet private weak var addOrEditButton: NeumorphismView!
    @IBOutlet private weak var attendanceButton: NeumorphismView!
    @IBOutlet private weak var memoButton: NeumorphismView!
    @IBOutlet private weak var colorButton: NeumorphismView!
    @IBOutlet private weak var backButton: NeumorphismView!
    
    private var backButtonEvent: (() -> Void)?
    private var week: ManageableWeek?
    private var period: ManageablePeriod?
    private let lectureUseCase = LectureUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
    }
    
    static func instantiate(week: ManageableWeek, period: ManageablePeriod, backButtonEvent: @escaping () -> Void) -> SettingLectureViewController {
        let settingLectureVC = UIStoryboard.settingLecture.instantiateViewController(
            identifier: Self.identifier
        ) as! SettingLectureViewController
        settingLectureVC.week = week
        settingLectureVC.period = period
        settingLectureVC.backButtonEvent = backButtonEvent
        return settingLectureVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupViews()
        
    }
    
}

// MARK: - setup views
private extension SettingLectureViewController {
    
    func setupViews() {
        let index = Convert(week: week, period: period).number
        let lecture = lectureUseCase.read(index: index)
        lectureView.setupLectureLabels(lecture: lecture)
        if lecture.name.isEmpty {
            addOrEditButton.setup("追加")
            addOrEditButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
            lectureView.isHidden = true
        } else {
            addOrEditButton.setup("編集")
            addOrEditButton.addTarget(self, action: #selector(editButtonDidTapped), for: .touchUpInside)
            lectureView.isHidden = false
        }
        attendanceButton.setup("出欠")
        attendanceButton.addTarget(self, action: #selector(attendanceButtonDidTapped), for: .touchUpInside)
        memoButton.setup("メモ")
        memoButton.addTarget(self, action: #selector(memoButtonDidTapped), for: .touchUpInside)
        colorButton.setup("カラー")
        colorButton.addTarget(self, action: #selector(colorButtonDidTapped), for: .touchUpInside)
        backButton.setup("戻る")
        backButton.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
    }
    
}

// MARK: - setup NeumorphismView
private extension NeumorphismView {
    
    func setupLectureLabels(lecture: Lecture?) {
        self.type = .normal
        
        let lectureNameLabel = UILabel()
        lectureNameLabel.text = lecture?.name
        lectureNameLabel.textColor = .black
        lectureNameLabel.textAlignment = .center
        lectureNameLabel.font = .boldSystemFont(ofSize: 25)
        self.addSubview(lectureNameLabel)
        lectureNameLabel.anchor(centerY: self.centerYAnchor, centerX: self.centerXAnchor)
        
        let lectureTimeLabel = UILabel()
        lectureTimeLabel.text = "時間を入れる"
        lectureTimeLabel.textColor = .black
        lectureTimeLabel.textAlignment = .center
        lectureTimeLabel.font = .boldSystemFont(ofSize: 15)
        self.addSubview(lectureTimeLabel)
        lectureTimeLabel.anchor(bottom: lectureNameLabel.bottomAnchor, centerX: self.centerXAnchor, bottomPadding: -50)
        
        let roomLabel = UILabel()
        roomLabel.text = lecture?.room
        roomLabel.textColor = .black
        roomLabel.textAlignment = .center
        roomLabel.font = .boldSystemFont(ofSize: 15)
        self.addSubview(roomLabel)
        lectureTimeLabel.anchor(top: lectureNameLabel.topAnchor, centerX: self.centerXAnchor, bottomPadding: 50)
    }
    
    func setup(_ text: String) {
        self.type = .pushButton
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        self.addSubview(label)
        label.anchor(centerY: self.centerYAnchor, centerX: self.centerXAnchor)
    }
    
}

// MARK: - @objc func
@objc private extension SettingLectureViewController {
    
    func addButtonDidTapped() {
        let additionalLectureVC = AdditionalLectureViewController.instantiate(
            week: week,
            period: period) { [weak self] in
            self?.backButtonEvent?()
            self?.dismiss(animated: true, completion: nil)
        }
        present(additionalLectureVC, animated: true, completion: nil)
    }
    
    func editButtonDidTapped() {
        let editLectureVC = EditLectureViewController.instantiate()
        editLectureVC.modalPresentationStyle = .fullScreen
        present(editLectureVC, animated: true, completion: nil)
    }
    
    func attendanceButtonDidTapped() {
        let lectureAttendanceVC = LectureAttendanceViewController.instantiate()
        lectureAttendanceVC.modalPresentationStyle = .fullScreen
        present(lectureAttendanceVC, animated: true, completion: nil)
    }
    
    func memoButtonDidTapped() {
        let lectureMemoVC = LectureMemoViewController.instantiate()
        lectureMemoVC.modalPresentationStyle = .fullScreen
        present(lectureMemoVC, animated: true, completion: nil)
    }
    
    func colorButtonDidTapped() {
        let lectureColorVC = LectureColorViewController.instantiate()
        lectureColorVC.modalPresentationStyle = .fullScreen
        present(lectureColorVC, animated: true, completion: nil)
    }
    
    func backButtonDidTapped() {
        backButtonEvent?()
        dismiss(animated: true, completion: nil)
    }
    
}

private extension UIStoryboard {
    
    static var settingLecture: UIStoryboard {
        UIStoryboard(name: "SettingLecture", bundle: nil)
    }
    
}

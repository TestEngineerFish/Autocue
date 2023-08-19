//
//  EditViewController.swift
//  pip_swift
//
//  Created by 老沙 on 2023/7/4.
//

import Foundation
import UIKit

class EditViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var rightBar: UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var model = BPCueModel()
    
    
    enum Status {
        case review, edit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initData()
    }
    
    // MARK: ==== init ====
    private func initUI() {
        playButton.layer.cornerRadius   = playButton.frame.height/2
        textField.layer.borderWidth     = 1
        textField.layer.borderColor     = UIColor.gray.withAlphaComponent(0.3).cgColor
        textField.layer.cornerRadius    = 5
        textView.layer.borderWidth      = 1
        textView.layer.borderColor      = UIColor.gray.withAlphaComponent(0.3).cgColor
        textView.layer.cornerRadius     = 5
        textView.textContainerInset     = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    private func initData() {
        textField.text = model.title
        textView.text = model.content
        if textView.text.isEmpty {
            textView.text       = "请输入提示词"
            textView.textColor  = UIColor.lightGray
        }
    }
    
    // MARK: ==== Event ====
    
    @IBAction func clickRight(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
        textField.resignFirstResponder()
        BPIMDBOperator.default.insertCue(model: model)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func play(_ sender: UIButton) {
        PlayManager.share.play(model: model)
    }
    
    // MARK: ==== UITextViewDelegate ====
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "请输入提示词"
            textView.textColor = UIColor.lightGray
        }
        model.content = textView.text
    }
    
    // MARK: ==== UITextField ====
    func textFieldDidEndEditing(_ textField: UITextField) {
        model.title = textField.text ?? ""
    }
}

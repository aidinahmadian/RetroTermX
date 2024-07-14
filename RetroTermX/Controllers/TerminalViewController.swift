//
//  TerminalViewController.swift
//  RetroTermX
//
//  Created by Aidin Ahmadian on 7/14/24.
//

import UIKit
import AVFoundation

class TerminalViewController: UIViewController, UITextFieldDelegate {
    private var terminalModel = TerminalModel()
    private var terminalView: TerminalView {
        return view as! TerminalView
    }
    private var displayLink: CADisplayLink?
    private var characterIndex = 0
    private var cursorTimer: Timer?
    private var cursorVisible = true
    private let cursorCharacter: Character = "_"
    private var currentColorIndex = 0
    private let colors: [UIColor] = [#colorLiteral(red: 0.3240896761, green: 0.9508374333, blue: 0.1933343709, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)]
    private var audioPlayer: AVAudioPlayer?

    override func loadView() {
        view = TerminalView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        terminalView.terminalTextField.delegate = self
        terminalView.changeColorButton.addTarget(self, action: #selector(changeColorButtonTapped), for: .touchUpInside)
        terminalView.navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)

        playTypingSound()
        startTypingAnimation()

        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Start the cursor blinking
        startCursorBlinking()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        cursorTimer?.invalidate()
    }
    
    private func playTypingSound() {
        guard let soundURL = Bundle.main.url(forResource: "TypingSound", withExtension: "mp3") else {
            print("Failed to find sound file.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            terminalView.terminalTextFieldBottomConstraint?.constant = -keyboardHeight
            view.layoutIfNeeded()
            updateScrollView()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        terminalView.terminalTextFieldBottomConstraint?.constant = -10
        view.layoutIfNeeded()
        updateScrollView()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func changeColorButtonTapped() {
        currentColorIndex = (currentColorIndex + 1) % colors.count
        let newColor = colors[currentColorIndex]

        terminalView.terminalLabel.textColor = newColor
        terminalView.changeColorButton.tintColor = newColor
        terminalView.navigateButton.tintColor = newColor
        terminalView.terminalTextField.textColor = newColor

        let placeholderText = terminalView.terminalTextField.placeholder ?? "Enter command here..."
        terminalView.terminalTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: newColor.withAlphaComponent(0.5),
                .font: UIFont(name: "Menlo", size: 14)!
            ]
        )
    }

    @objc private func navigateButtonTapped() {
        let secondVC = AboutViewController()
        present(secondVC, animated: true, completion: nil)
    }

    private func startTypingAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateText))
        displayLink?.add(to: .current, forMode: .default)
    }

    @objc private func updateText() {
        if characterIndex < terminalModel.initialText.count {
            let index = terminalModel.initialText.index(terminalModel.initialText.startIndex, offsetBy: characterIndex)
            terminalView.terminalLabel.text?.append(terminalModel.initialText[index])
            characterIndex += 1
            updateScrollView()
        } else {
            displayLink?.invalidate()
            displayLink = nil
            terminalView.terminalTextField.becomeFirstResponder()
            terminalView.terminalLabel.text?.append(terminalModel.availableCommands)
            updateScrollView()
        }
    }

    private func updateScrollView() {
        DispatchQueue.main.async {
            self.terminalView.scrollView.setNeedsLayout()
            self.terminalView.scrollView.layoutIfNeeded()
            self.terminalView.scrollView.scrollToBottom(animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userInput = textField.text else { return false }

        let newCommand = "\nUser@Machine:~$ \(userInput)"
        terminalView.terminalLabel.text?.append(newCommand)

        let response = terminalModel.processCommand(userInput)
        if userInput.lowercased() == "clear" {
            terminalView.terminalLabel.text = ""
            terminalView.terminalLabel.text?.append(terminalModel.availableCommands)
        } else {
            terminalView.terminalLabel.text?.append("\n\(response)")
        }

        terminalModel.addCommandToHistory(userInput)

        textField.text = ""
        updateScrollView()
        return true
    }

    private func startCursorBlinking() {
        cursorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(toggleCursor), userInfo: nil, repeats: true)
    }

    @objc private func toggleCursor() {
        cursorVisible.toggle()
        if cursorVisible {
            terminalView.terminalLabel.text?.append(String(cursorCharacter))
        } else {
            terminalView.terminalLabel.text = terminalView.terminalLabel.text?.trimmingCharacters(in: CharacterSet(charactersIn: String(cursorCharacter)))
        }
    }
}

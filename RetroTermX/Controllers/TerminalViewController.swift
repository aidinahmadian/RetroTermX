//
//  TerminalViewController.swift
//  RetroTermX
//
//  Created by Aidin Ahmadian on 7/14/24.
//

import UIKit

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
    private let colors: [UIColor] = [.green, .cyan, .yellow]

    override func loadView() {
        view = TerminalView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        terminalView.terminalTextField.delegate = self
        terminalView.changeColorButton.addTarget(self, action: #selector(changeColorButtonTapped), for: .touchUpInside)
        terminalView.navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)

        // Start the typing animation
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
        let secondVC = SecondViewController()
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

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}

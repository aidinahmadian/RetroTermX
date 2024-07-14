//
//  TerminalView.swift
//  RetroTermX
//
//  Created by Aidin Ahmadian on 7/14/24.
//

import UIKit

class TerminalView: UIView {
    let terminalLabel = UILabel()
    let terminalTextField = UITextField()
    let changeColorButton = UIButton()
    let navigateButton = UIButton()
    let scrollView = UIScrollView()
    var terminalTextFieldBottomConstraint: NSLayoutConstraint?
    var scrollViewBottomConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black

        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.black
        addSubview(scrollView)

        // Configure label
        terminalLabel.translatesAutoresizingMaskIntoConstraints = false
        terminalLabel.textColor = .green
        terminalLabel.font = UIFont(name: "Menlo", size: 14)
        terminalLabel.numberOfLines = 0
        terminalLabel.text = ""
        scrollView.addSubview(terminalLabel)

        // Configure text field
        terminalTextField.translatesAutoresizingMaskIntoConstraints = false
        terminalTextField.textColor = .green
        terminalTextField.font = UIFont(name: "Menlo", size: 14)
        terminalTextField.backgroundColor = UIColor(white: 0.0567, alpha: 1)
        terminalTextField.borderStyle = .none
        terminalTextField.autocorrectionType = .no
        terminalTextField.spellCheckingType = .no
        terminalTextField.autocapitalizationType = .none
        terminalTextField.keyboardType = .asciiCapable
        terminalTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter command here...",
            attributes: [
                .foregroundColor: UIColor.green.withAlphaComponent(0.5),
                .font: UIFont(name: "Menlo", size: 14)!
            ]
        )
        addSubview(terminalTextField)

        // Configure change color button
        changeColorButton.translatesAutoresizingMaskIntoConstraints = false
        let changeColorIcon = UIImage(systemName: "paintbrush")
        changeColorButton.setImage(changeColorIcon, for: .normal)
        changeColorButton.tintColor = .green
        addSubview(changeColorButton)

        // Configure navigate button
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        let navigateIcon = UIImage(systemName: "arrow.right.circle")
        navigateButton.setImage(navigateIcon, for: .normal)
        navigateButton.tintColor = .green
        addSubview(navigateButton)

        // Set up Auto Layout constraints
        setupConstraints()
    }

    private func setupConstraints() {
        terminalTextFieldBottomConstraint = terminalTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: terminalTextField.topAnchor, constant: -10)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollViewBottomConstraint!,

            terminalLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            terminalLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            terminalLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            terminalLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            terminalLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            terminalTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            terminalTextField.trailingAnchor.constraint(equalTo: changeColorButton.leadingAnchor, constant: -10),
            terminalTextField.heightAnchor.constraint(equalToConstant: 35),
            terminalTextFieldBottomConstraint!,

            changeColorButton.trailingAnchor.constraint(equalTo: navigateButton.leadingAnchor, constant: -10),
            changeColorButton.centerYAnchor.constraint(equalTo: terminalTextField.centerYAnchor),
            changeColorButton.widthAnchor.constraint(equalToConstant: 35),
            changeColorButton.heightAnchor.constraint(equalToConstant: 35),

            navigateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            navigateButton.centerYAnchor.constraint(equalTo: terminalTextField.centerYAnchor),
            navigateButton.widthAnchor.constraint(equalToConstant: 35),
            navigateButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

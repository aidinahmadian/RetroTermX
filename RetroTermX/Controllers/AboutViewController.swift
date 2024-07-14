//
//  AboutViewController.swift
//  RetroTermX
//
//  Created by Aidin Ahmadian on 7/14/24.
//

import UIKit

class AboutViewController: UIViewController {
    
    let containerView = UIView()
    let swipeDownLabel = UILabel()
    let profileImageView = UIImageView()
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let githubButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupViews()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBlinkingAnimation()
    }
    
    func setupBackground() {
        view.backgroundColor = .black
    }
    
    func setupViews() {
        // Swipe Down Label
        swipeDownLabel.translatesAutoresizingMaskIntoConstraints = false
        swipeDownLabel.text = "Swipe down to \ndismiss"
        swipeDownLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        swipeDownLabel.textAlignment = .center
        swipeDownLabel.numberOfLines = 0
        swipeDownLabel.textColor = .green
        view.addSubview(swipeDownLabel)
        
        // Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        
        // Profile Image View
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .green
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.green.cgColor
        containerView.addSubview(profileImageView)
        
        // Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "About"
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .green
        containerView.addSubview(titleLabel)
        
        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Created by: Aidin"
        nameLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .green
        containerView.addSubview(nameLabel)
        
        // Description Label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "RetroTermX is a simple iOS project that brings the nostalgic feel of classic command-line interfaces to your modern device. This app allows users to interact with a simulated terminal environment, execute various commands, and experience the charm of vintage computing."
        descriptionLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .green
        descriptionLabel.clipsToBounds = true
        containerView.addSubview(descriptionLabel)
        
        // GitHub Button
        githubButton.translatesAutoresizingMaskIntoConstraints = false
        githubButton.setTitle("Visit my GitHub", for: .normal)
        githubButton.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        githubButton.setTitleColor(.green, for: .normal)
        githubButton.backgroundColor = .clear
        githubButton.layer.cornerRadius = 10
        githubButton.layer.borderWidth = 2
        githubButton.layer.borderColor = UIColor.green.cgColor
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        containerView.addSubview(githubButton)
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            swipeDownLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            swipeDownLabel.heightAnchor.constraint(equalToConstant: 50),
            swipeDownLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            swipeDownLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: swipeDownLabel.bottomAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            githubButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            githubButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            githubButton.widthAnchor.constraint(equalToConstant: 200),
            githubButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func startBlinkingAnimation() {
        swipeDownLabel.startBlink()
    }
    
    @objc func githubButtonTapped() {
        if let url = URL(string: "https://github.com/aidinahmadian") {
            UIApplication.shared.open(url)
        }
    }
}

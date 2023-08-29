//
//  DetailsViewController.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import UIKit

class DetailsViewController: UIViewController {

    private let id: Int

    let scrollView = UIScrollView()
    private let contentView = UIView()
    private var isButtonAnimating = false

    let screenWidth = UIScreen.main.bounds.width

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var geoLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private lazy var geoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расположение"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitle("Купить", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var contactsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        loadDetails()
        view.backgroundColor = .white
        startButton.addTarget(self, action: #selector(startButtonOnTapHandler), for: .touchUpInside)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onPressed(_:)))

        startButton.addGestureRecognizer(longPressRecognizer)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.addSubview(contentView)

        setupConstraints()
    }

    private func loadDetails() {
        let service = ItemLoaderService(networkService: NetworkService())
        service.loadItemDetails(id: id) {
            [weak self] result in
            switch (result) {
            case .success(let details):
                DispatchQueue.main.async {
                    self?.titleLabel.text = details.title
                    self?.priceLabel.text = details.price
                    self?.geoLabel.text = "\(details.location), \(details.address)"
                    self?.createdDateLabel.text = details.createdDate
                    self?.descriptionLabel.text = details.description
                    self?.emailLabel.text = details.email
                    self?.phoneNumberLabel.text = details.phoneNumber
                }
                service.loadItemImage(url: details.imageUrl, handler: {
                    [weak self] result in
                    switch(result) {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupConstraints() {

        let stackView = UIStackView(arrangedSubviews: [
            priceLabel, titleLabel, startButton, geoTitleLabel, geoLabel, descriptionTitleLabel, descriptionLabel, createdDateLabel, contactsTitleLabel, emailLabel, phoneNumberLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.setCustomSpacing(2, after: geoTitleLabel)
        stackView.setCustomSpacing(2, after: descriptionTitleLabel)
        stackView.setCustomSpacing(2, after: contactsTitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])


        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: screenWidth),
            imageView.widthAnchor.constraint(equalToConstant: screenWidth)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 50.0),
            startButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20)
        ])
    }

    @objc func onPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            if !isButtonAnimating {
                isButtonAnimating = true
                animateButton(with: 0.3)
            } else {
                isButtonAnimating = false
                if let presentationLayer = startButton.layer.presentation() {
                    startButton.layer.transform = presentationLayer.transform
                    startButton.layer.removeAnimation(forKey: "shake")
                }
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.startButton.transform = .identity
                }, completion: { [weak self] _ in
                    self?.startButton.layer.removeAllAnimations()
                })
            }
        }
    }

    func animateButton(with duration: Double) {
        let translationAnimation = CABasicAnimation(keyPath: "position")

        let yPosition = startButton.frame.maxY - startButton.frame.height / 2.0
        translationAnimation.autoreverses = true
        translationAnimation.fromValue = CGPoint(x: view.frame.width / 2.0 - 5, y: yPosition - 5)
        translationAnimation.toValue = CGPoint(x: view.frame.width / 2.0, y: yPosition)
        translationAnimation.duration = duration / 2
        translationAnimation.repeatCount = .infinity

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.autoreverses = true
        rotationAnimation.fromValue = -.pi / 30.0
        rotationAnimation.toValue = .pi / 30.0
        rotationAnimation.duration = duration / 2
        rotationAnimation.repeatCount = .infinity

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotationAnimation, translationAnimation]
        animationGroup.autoreverses = true
        animationGroup.duration = 0.3
        animationGroup.repeatCount = .infinity
        startButton.layer.add(animationGroup, forKey: "shake")
    }

    @objc func startButtonOnTapHandler() {
    }

}

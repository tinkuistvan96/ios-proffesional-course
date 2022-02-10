//
//  ShakeyBellView.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 09..
//

import UIKit

class ShakeyBellView: UIView {
    
    let imageView = UIImageView()
    let buttonView = UIButton()
    
    let buttonHeight : CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 48, height: 48)
    }
    
}

extension ShakeyBellView {
    
    func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bellTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "bell.fill")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.image = image
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.setTitleColor(.white, for: .normal)
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        buttonView.backgroundColor = .systemRed
        buttonView.layer.cornerRadius = buttonHeight / 2
        buttonView.setTitle("9", for: .normal)
    }
    
    func layout() {
        addSubview(imageView)
        addSubview(buttonView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonView.widthAnchor.constraint(equalToConstant: buttonHeight),
            buttonView.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -9),
            buttonView.topAnchor.constraint(equalTo: imageView.topAnchor)
        ])
    }
}

//MARK: - Actions
extension ShakeyBellView {
    @objc func bellTapped(_ recognizer: UITapGestureRecognizer) {
        shakeWith(duration: 1.0, angle: .pi/8)
    }
    
    private func shakeWith(duration: Double, angle: CGFloat) {
        
        let numberOfFrames : Double = 6
        let frameDuration = 1 / numberOfFrames
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: frameDuration) {
                self.imageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration, relativeDuration: frameDuration) {
                self.imageView.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration * 2, relativeDuration: frameDuration) {
                self.imageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration * 3, relativeDuration: frameDuration) {
                self.imageView.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration * 4, relativeDuration: frameDuration) {
                self.imageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration * 5, relativeDuration: frameDuration) {
                self.imageView.transform = CGAffineTransform.identity //original position
            }
        }, completion: nil)

    }
}

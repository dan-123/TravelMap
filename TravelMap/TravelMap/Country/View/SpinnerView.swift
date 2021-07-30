//
//  SpinnerView.swift
//  TravelMap
//
//  Created by Даниил Петров on 30.07.2021.
//

import UIKit

final class SpinnerView: UIView {
    
    // MARK: - Properties
    
    lazy var spinnerImageView: UIImageView = {
        let spinner = UIImageView(image: UIImage(named: "spinner"))
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isHidden = true
        return spinner
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElement() {
        addSubview(spinnerImageView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            spinnerImageView.heightAnchor.constraint(equalToConstant: 32),
            spinnerImageView.widthAnchor.constraint(equalToConstant: 32),
            spinnerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func startSpinner() {
        spinnerImageView.isHidden = false
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        spinnerImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    func stopSpinner() {
        spinnerImageView.layer.removeAllAnimations()
        spinnerImageView.isHidden = true
    }
}

//
//  ViewController.swift
//  ScaningDemo
//
//  Created by Дмитрий Никоноров on 10.02.2023.
//

import UIKit
import VisionKit
import PDFKit

class ViewController: UIViewController {
    private lazy var startButton: UIButton = {
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start scaning", for: .normal)
        startButton.addTarget(self, action: #selector(startScan), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()

    private func setupUI() {
        view.addSubview(startButton)
    }

    private func setutConstraints() {
        [
            startButton.widthAnchor.constraint(equalToConstant: 150.0),
            startButton.heightAnchor.constraint(equalToConstant: 40.0),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ].forEach { $0.isActive = true }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setutConstraints()
    }

    @objc private func startScan(_ sender: Any) {
        let scanViewController = ScanViewController()
        let navController = UINavigationController(rootViewController: scanViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: false)
    }








}

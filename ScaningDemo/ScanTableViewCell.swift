//
//  ScanTableViewCell.swift
//  ScaningDemo
//
//  Created by Дмитрий Никоноров on 10.02.2023.
//

import UIKit

class ScanTableViewCell: UITableViewCell {

    private var scanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private func setupUI() {
        contentView.addSubview(scanImageView)
    }

    private func setupConstraints() {
        [
            scanImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            scanImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            scanImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scanImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ].forEach { $0.isActive = true }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupImage(image: UIImage) {
        scanImageView.image = image
    }
}

//
//  ScanViewController.swift
//  ScaningDemo
//
//  Created by Дмитрий Никоноров on 10.02.2023.
//

import UIKit
import VisionKit
import PDFKit

class ScanViewController: UIViewController {
    private var images: [UIImage] = []

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func swapAt(_ fromIndex: IndexPath, to toIndex: IndexPath) {
        let image = images[fromIndex.row]
        images.removeAll(where: { $0 == image})
        images.insert(image, at: toIndex.row)
    }

    private func setupConstraints() {
        [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -116.0)
        ].forEach { $0.isActive = true }
    }

    private func setupTableView() {
        tableView.register(
            ScanTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.rowHeight = 300
    }

    private func openScanner() {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        present(scanner, animated: true)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(createDocument)
        )
    }

    //MARK: - Create document
    @objc private func createDocument() {
        let newDocument = PDFDocument()
        for (number, image) in images.enumerated() {
            guard let page = PDFPage(image: image) else { continue }
            newDocument.insert(page, at: number)
        }

        var documentUrl = URL(string: "")
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: [.userDomainMask], appropriateFor: nil, create: false)
            documentUrl = url
        } catch let error {
            print(error)
        }

        guard let destinationURL = documentUrl?.appendingPathComponent("Newdocument.pdf") else { return }
        FileManager.default.createFile(atPath: destinationURL.path, contents: newDocument.dataRepresentation())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        openScanner()
        setupNavigationBar()
        setupView()
        setupConstraints()
        setupTableView()
    }

    private var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
}


// MARK: - VNDocumentCameraViewControllerDelegate
extension ScanViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            images.append(img)
        }

        tableView.reloadData()
        controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
        self.dismiss(animated: false)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        self.dismiss(animated: false)
        print(error)
    }
}

extension ScanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScanTableViewCell
        cell.setupImage(image: images[indexPath.row])
        return cell
    }
}


extension ScanViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        swapAt(sourceIndexPath, to: destinationIndexPath)
    }


    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider.init(object: images[indexPath.row])
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
}

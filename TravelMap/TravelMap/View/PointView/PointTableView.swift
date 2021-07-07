//
//  PointTableView.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

//import Foundation
import UIKit

protocol PointTableViewDelegate: AnyObject {
    func selectRow(viewController: UIViewController)
}

class PointTableView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PointTableViewDelegate?
    
    lazy var pointTable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(PointCell.self, forCellReuseIdentifier: PointCell.indentifirer)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
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
        addSubview(pointTable)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            pointTable.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            pointTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pointTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            pointTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
}

// MARK: - UITableViewDataSource

extension PointTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PointCell.indentifirer, for: indexPath)
        // передать значения
        (cell as? PointCell)?.configure()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PointTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pointViewController = PlaceViewController(placeLabelText: "тест \(indexPath.row)")
//        navigationController?.pushViewController(viewController, animated: true)
        delegate?.selectRow(viewController: pointViewController)
    }
}

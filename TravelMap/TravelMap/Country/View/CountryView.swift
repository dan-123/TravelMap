//
//  CountryView.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

import UIKit

final class CountryView: UIView {
    
    // MARK: - Properties
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return flowLayout
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(CountryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CountryCollectionViewCell.reusableIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var citiesLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.text = "Мои города"
        cityLabel.font = cityLabel.font.withSize(20)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        return cityLabel
    }()
    
    lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var spinnerView: SpinnerView = {
        let spinnerView = SpinnerView()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        return spinnerView
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
        addSubview(photoCollectionView)
        addSubview(citiesLabel)
        addSubview(citiesTableView)
        addSubview(spinnerView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            
            citiesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            citiesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            citiesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            citiesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            citiesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            citiesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            citiesTableView.topAnchor.constraint(equalTo: citiesLabel.bottomAnchor, constant: 24),
            citiesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: photoCollectionView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: photoCollectionView.centerYAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func reloadCountryImage() {
        photoCollectionView.reloadData()
    }
    
    func reloadCityTable() {
        citiesTableView.reloadData()
    }
    
    func update(dataProvider: UITableViewDataSource & UITableViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout) {
        citiesTableView.dataSource = dataProvider
        citiesTableView.delegate = dataProvider
        photoCollectionView.dataSource = dataProvider
        photoCollectionView.delegate = dataProvider
    }
}

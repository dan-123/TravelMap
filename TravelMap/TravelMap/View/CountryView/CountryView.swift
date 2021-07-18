//
//  CountryView.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

//import Foundation
import UIKit

protocol CountryCollectionViewDelegate: AnyObject {
    //data sourse
    func getImageCountry(index: Int) -> UIImage
}

protocol CountryTableViewDelegate: AnyObject {
    //data source
    func getNumberOfSection(_ section: Int) -> Int
    func getData(at indexPath: IndexPath) -> City
}

class CountryView: UIView {
    
    // MARK: - Properties

    weak var delegateCollection: CountryCollectionViewDelegate?
    weak var delegateTable: CountryTableViewDelegate?
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: 300, height: 300)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return flowLayout
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
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
        addSubview(photoCollectionView)
        addSubview(citiesLabel)
        addSubview(citiesTableView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            photoCollectionView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            
            citiesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            citiesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            citiesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            citiesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            citiesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            citiesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            citiesTableView.topAnchor.constraint(equalTo: citiesLabel.bottomAnchor, constant: 24),
            citiesTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
    func reloadCountryImage() {
        photoCollectionView.reloadData()
    }
    
    func reloadCityTable() {
        citiesTableView.reloadData()
    }
}

// MARK: - Extensions (UICollectionViewDataSource)

extension CountryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.Image.perPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reusableIdentifier,
                                                            for: indexPath) as? CountryCollectionViewCell
        else { preconditionFailure("Failed to load filter collection view cell") }
        
        if let image = delegateCollection?.getImageCountry(index: indexPath.row) {
            cell.setImage(image)
        } else {
            cell.setImage(UIImage(named: "testPhoto"))
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
//    }
}

// MARK: - Extensions (UICollectionViewDelegate)

extension CountryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Extensions (UITableViewDataSource)

extension CountryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = delegateTable?.getNumberOfSection(section) else { return 0 }
        return section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let city = delegateTable?.getData(at: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        cell.textLabel?.text = city.city
        return cell
    }
}




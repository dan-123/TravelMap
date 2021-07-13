//
//  CountryView.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

import Foundation
import UIKit

protocol CountryViewDelegate: AnyObject {
    func getImageCountry(index: Int) -> UIImage
}

class CountryView: UIView {
    
    // MARK: - Properties

    weak var delegate: CountryViewDelegate?
    
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
        collectionView.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: "countryCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.tintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPageIndicatorTintColor = UIColor.green
        return pageControl
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
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(CitiesTableViewCell.self, forCellReuseIdentifier: "citiesTableViewCell")
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
//        addSubview(pageControl)
        addSubview(citiesLabel)
        addSubview(citiesTableView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            photoCollectionView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            
//            pageControl.heightAnchor.constraint(equalToConstant: 20),
//            pageControl.widthAnchor.constraint(equalToConstant: 50),
//            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
//            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
            
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
}

// MARK: - Extensions (UICollectionView)

extension CountryView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCollectionViewCell", for: indexPath) as? CountryCollectionViewCell
        else { preconditionFailure("Failed to load filter collection view cell") }
        
        if let image = delegate?.getImageCountry(index: indexPath.row) {
            cell.setImage(image)
        } else {
            cell.setImage(UIImage(named: "testPhoto"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: frame.width, height: frame.height)
//    }
}

// MARK: - Extensions (UITableView)

extension CountryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesTableViewCell", for: indexPath)
        // передать значения
        (cell as? CitiesTableViewCell)?.configure()
        return cell
    }
    
    
}




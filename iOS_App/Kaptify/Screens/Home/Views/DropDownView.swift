//
//  DropDownView.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-20.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit



final class DropDownView: UIView {

    private let dropDownOptions = ["🔥  Albums", "📅  Albums"]
    private let tableView = UITableView()
    private let dataFetcher = DataFetcher()
    var dropDelegate: NetworkRequestDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        backgroundColor = UIColor(r: 28, b: 27, g: 27)
        setupTableView()

    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(r: 28, b: 27, g: 27)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.tableFooterView = nil
        tableView.isScrollEnabled = false
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        bringSubviewToFront(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DropDownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        cell.selectionStyle = .none
        
        cell.backgroundColor = UIColor(r: 28, b: 27, g: 27)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // download default data (TOP)
            dropDelegate.requestDataAndPopulateView(jsonString: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json")
        } else {
            // download diff data (NEW)
            dropDelegate.requestDataAndPopulateView(jsonString: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-releases/all/25/explicit.json")
        }
    }
}

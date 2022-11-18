//
//  AnimalsListViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 11/11/22.
//

import UIKit

class AnimalsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let animalsListTableView = UITableView()
    var animalsData: [AllData]!
    let tableCellIdentifier = "animalsListTableViewCell"
    
    lazy var backButton: UIButton = {
        let button = BackButton()
        button.addTarget(self, action: #selector(self.backButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var modalLabel: UILabel = {
        let label = BasicModalLabel()
        label.text = "Yuk! Bertemu Satwa di \(animalsData[0].cage)"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(modalLabel)
        view.addSubview(animalsListTableView)
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            width: view.bounds.height * (30 / 787),
            height: view.bounds.height * (30 / 787)
        )
        
        modalLabel.anchor(
            top: backButton.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 26,
            paddingLeft: 24,
            height: view.bounds.height * (22 / 787)
        )
        
        animalsListTableView.anchor(
            top: modalLabel.bottomAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
    }
    
    func setupTableView() {
        animalsListTableView.register(BasicTableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        animalsListTableView.delegate = self
        animalsListTableView.dataSource = self
        animalsListTableView.separatorStyle = .none
        animalsListTableView.backgroundColor = .white
    }
    
    @objc func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! BasicTableViewCell
        cell.cellName = animalsData[indexPath.row].idName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * (112/844)
    }
}

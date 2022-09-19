//
//  ContactListView.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit

protocol ContactListViewDelegate: AnyObject {
    func didPressContact()
}

final class ContactListView: UIView {

    let cellSize = CGFloat(82)

    private let cellIdentifier = "ContactCellIdentifier"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactCellView.self, forCellReuseIdentifier: self.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var contacts: [ContactModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ContactListViewDelegate?

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

// MARK: ViewCodeProtocol
extension ContactListView: ViewCodeProtocol {
    
    func buildViewHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
        tableView.reloadData()
    }
    
}

// MARK: UITableViewDataSource
extension ContactListView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactCellView
        cell.setupCell(contacts[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ContactListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didPressContact()
    }
}

// MARK: Setup view
extension ContactListView {
    
    enum RenderType {
        case buildContactList(_ list: [ContactModel])
    }

    func render(_ type: ContactListView.RenderType) {
        switch type {
        case let .buildContactList(dto): contacts = dto
        }
    }
}

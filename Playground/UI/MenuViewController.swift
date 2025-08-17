//
//  MenuViewControllerDelegate.swift
//  Playground
//
//  Created by Aditya Patole on 16/08/25.
//


import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func menu(didSelect screen: Screen)
    func menuDidRequestClose()
}

final class MenuViewController: UITableViewController {
    weak var delegate: MenuViewControllerDelegate?
    private let items: [Screen]

    init(items: [Screen]) {
        self.items = items
        super.init(style: .insetGrouped)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        tableView.backgroundColor = .systemBackground
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let s = items[indexPath.row]
        var cfg = cell.defaultContentConfiguration()
        cfg.text = s.title
        cfg.secondaryText = s.id
        cell.contentConfiguration = cfg
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menu(didSelect: items[indexPath.row])
    }
}
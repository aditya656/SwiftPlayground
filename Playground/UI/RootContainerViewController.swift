//
//  RootContainerDelegate.swift
//  Playground
//
//  Created by Aditya Patole on 09/08/25.
//


// UI/RootContainerViewController.swift

import UIKit

protocol RootContainerDelegate: AnyObject {
    func didTapHamburger()
}

final class RootContainerViewController: UIViewController {

    weak var delegate: RootContainerDelegate?

    private let navBar = UINavigationBar()
    private let contentContainer = UIView()
    private var currentChild: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        configureNav(title: "Playground")
    }

    func setContent(_ vc: UIViewController, title: String) {
        // remove old
        if let child = currentChild {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        // add new
        addChild(vc)
        vc.view.frame = contentContainer.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentContainer.addSubview(vc.view)
        vc.didMove(toParent: self)

        currentChild = vc
        setNavTitle(title)
    }

    private func layout() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        view.addSubview(contentContainer)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentContainer.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNav(title: String) {
        let navItem = UINavigationItem(title: title)
        let menu = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(onHamburger)
        )
        navItem.leftBarButtonItem = menu
        navBar.setItems([navItem], animated: false)
    }

    private func setNavTitle(_ title: String) {
        navBar.topItem?.title = title
    }

    @objc private func onHamburger() {
        delegate?.didTapHamburger()
    }
}

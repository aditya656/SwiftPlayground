//
//  AppCoordinator.swift
//  Playground
//
//  Created by Aditya Patole on 16/08/25.
//

import UIKit

final class AppCoordinator: NSObject {
    private let window: UIWindow
    private let root = RootContainerViewController()
    private var registry: ScreenRegistry { .shared }

    private let defaultsKey = "lastScreenID"

    init(window: UIWindow) {
        self.window = window
        super.init()
        root.delegate = self
    }

    func start() {
        seedScreens()
        window.rootViewController = root
        window.makeKeyAndVisible()

        // open last or first
        let initial = (UserDefaults.standard.string(forKey: defaultsKey))
            .flatMap { registry.screen(with: $0) } ?? registry.screens.first

        if let s = initial {
            show(screen: s)
        }
    }

    private func seedScreens() {
        registry.register(SwiftUIScreen(id: "WaterNotification", title: "Water Notification") { WaterNotificationView() })
        registry.register(SwiftUIScreen(id: "buttons", title: "Buttons Lab") { ButtonsLabView() })
        registry.register(SwiftUIScreen(id: "NameSpaceAnimation", title: "NameSpaceAnimation") { NameSpaceAnimation() })
        registry.register(SwiftUIScreen(id: "TimeLineViewBootcamp", title: "TimeLineViewBootcamp") { TimeLineViewBootcamp() })
        registry.register(UIKitScreen(id: "uikit-webview-debug", title: "WebView Debug") { WebDebugViewController() })
        registry.register(UIKitScreen(id: "uikit-ar-preview", title: "AR Preview") { ARProductShowcaseViewController.getPlantController() })
        registry.register(SwiftUIScreen(id: "TimeLineViewBootcamp", title: "TimeLineViewBootcamp") { TimeLineViewBootcamp() })
        registry.register(SwiftUIScreen(id: "ParallaxEffectView", title: "ParallaxEffectView") { ParallaxEffectView() })
        registry.register(UIKitScreen(id: "ParallaxEffectViewUIKit", title: "ParallaxEffectViewUIKit", builder: {
            ParallaxEffectViewUIKit()
        }))
        registry.register(SwiftUIScreen(id: "MathQuizGame", title: "Math Quiz Game", builder: { MathQuizGame() }))
        registry.register(SwiftUIScreen(id: "ThemeAwareView", title: "Theme Aware View", builder: { ThemeAwareView() }))
//        registry.register(SwiftUIScreen(id: "cards", title: "Cards Lab") { CardsLabView() })
//        registry.register(UIKitScreen(id: "uikit-demo", title: "UIKit Demo") { UIKitDemoViewController() })
//        registry.register(SwiftUIScreen(id: "OpacityTransitionTest", title: "Opacity Transition Test") { OpacityTransitionTest() })
//        registry.register(SwiftUIScreen(id: "ZeptoDeliveryPage", title: "ZeptoDeliveryPage") { ZeptoDeliveryPage() })
//        registry.register(SwiftUIScreen(id: "DropDownInScrollView", title: "DropDownInScrollView") { DropDownInScrollView() })
//        registry.register(SwiftUIScreen(id: "ForYouPageGeometryReader", title: "ForYouPageGeometryReader") { ForYouPageGeometryReader() })
//        registry.register(SwiftUIScreen(id: "AmbientBackgroundEffect", title: "AmbientBackgroundEffect") { AmbientBackgroundEffect() })
    }

    private func show(screen: Screen) {
        let vc = screen.makeViewController()
        root.setContent(vc, title: screen.title)
        UserDefaults.standard.set(screen.id, forKey: defaultsKey)
    }
}

extension AppCoordinator: RootContainerDelegate {
    func didTapHamburger() {
        let menu = MenuViewController(items: registry.screens)
        menu.delegate = self
        root.present(menu, animated: true)
    }
}

extension AppCoordinator: MenuViewControllerDelegate {
    func menu(didSelect screen: Screen) {
        root.dismiss(animated: true) { [weak self] in
            self?.show(screen: screen)
        }
    }
    func menuDidRequestClose() {
        root.dismiss(animated: true)
    }
}

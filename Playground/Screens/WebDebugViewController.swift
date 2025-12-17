//
//  WebDebugViewController.swift
//  Playground
//
//  Created by Aditya Patole on 02/10/25.
//


import UIKit
import WebKit

final class WebDebugViewController: UIViewController {

    private var webView: WKWebView!
    private let bridgeName = "nativeBridge"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Web Debug"
        view.backgroundColor = .systemBackground

        setupWebView()
        loadGoogle()
        addDebugBarButton()
    }

    deinit {
        // Always remove message handlers to avoid retain cycles/leaks
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: bridgeName)
        webView?.navigationDelegate = nil
        webView?.uiDelegate = nil
    }
}

// MARK: - Setup

private extension WebDebugViewController {
    func setupWebView() {
        let userContent = WKUserContentController()

        // 1) Bridge: listen for messages from JS
        userContent.add(self, name: bridgeName)

        // 2) Inject a tiny helper that:
        //    - exposes window.NativeBridge.post(msg)
        //    - forwards console.log to the native bridge (namespaced)
        let bridgeJS = """
        (function() {
          // Helper to safely post to native
          function postToNative(type, payload) {
            try {
              window.webkit.messageHandlers.\(bridgeName).postMessage({ type: type, payload: payload });
            } catch (e) {
              // Swallow to avoid breaking page scripts
            }
          }

          // Public API: window.NativeBridge.post(...)
          window.NativeBridge = {
            post: function(message) { postToNative("custom", message); }
          };

          // Mirror console.log -> native for debugging
          const originalLog = console.log;
          console.log = function() {
            try { postToNative("console", Array.from(arguments)); } catch (e) {}
            originalLog.apply(console, arguments);
          };
        })();
        """
        let script = WKUserScript(source: bridgeJS, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContent.addUserScript(script)

        let config = WKWebViewConfiguration()
        config.userContentController = userContent
        config.preferences.javaScriptEnabled = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.limitsNavigationsToAppBoundDomains = false // we want to browse Google
        config.userContentController.add(self, name: "bridge")
//        webkit.messageHandlers.bridge.postMessage({message: '{"type":"GEP"}'})
//        config.preferences.setValue(true, forKey: "developerExtrasEnabled")
        // iOS 16+: enable on-device Web Inspector targeting this WKWebView instance
//        if #available(iOS 16.4, *) {
//            config.isInspectable = true
//        }

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isInspectable = true
        self.webView = webView
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func loadGoogle() {
        guard let url = URL(string: "https://www.google.com/") else { return }
        webView.load(URLRequest(url: url))
    }

    func addDebugBarButton() {
        // Taps this to demonstrate a JS -> Native bridge call
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Ping Bridge",
            style: .plain,
            target: self,
            action: #selector(pingBridgeFromJS)
        )
    }

    @objc func pingBridgeFromJS() {
        // This triggers the injected window.NativeBridge.post(...) to message native
        let call = "window.NativeBridge && window.NativeBridge.post('Hello from JS via injected helper!')"
        webView.evaluateJavaScript(call) { _, error in
            if let error = error {
                print("⚠️ Failed to eval bridge test JS: \(error)")
            } else {
                print("✅ Executed bridge test JS")
            }
        }
    }
}

// MARK: - WKScriptMessageHandler

extension WebDebugViewController: WKScriptMessageHandler {
    // Receives messages from the page: window.webkit.messageHandlers.nativeBridge.postMessage(...)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == bridgeName else { return }

        // Expecting a dictionary payload { type: "...", payload: ... }
        if let dict = message.body as? [String: Any],
           let type = dict["type"] as? String {
            switch type {
            case "console":
                // Forward page console logs into Xcode for easy debugging
                print("🌐 [JS console.log] \(dict["payload"] ?? "")")
            case "custom":
                print("🔗 [Bridge] Received custom message from JS: \(dict["payload"] ?? "")")
            default:
                print("🔗 [Bridge] Unhandled message: \(dict)")
            }
        } else {
            // Raw / unexpected payloads
            print("🔗 [Bridge] Received: \(message.body)")
        }
    }
}

// MARK: - WKNavigationDelegate / WKUIDelegate (optional logging)

extension WebDebugViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("🌐 Navigation started: \(webView.url?.absoluteString ?? "(unknown)")")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("🌐 Navigation finished: \(webView.url?.absoluteString ?? "(unknown)")")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ Navigation failed: \(error)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("❌ Provisional navigation failed: \(error)")
    }
}

//
//  ARProductShowcaseViewController.swift
//  swiggy
//
//  Created by AI Assistant on 30/10/25.
//  Copyright © 2025 www.swiggy.com. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import Combine

// MARK: - ARProductShowcaseViewController

/// View controller for showcasing products in Augmented Reality
public final class ARProductShowcaseViewController: UIViewController {
    
    // MARK: - UI Properties
    
    /// AR scene view for rendering 3D content
    private lazy var sceneView: ARSCNView = {
        let view = ARSCNView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.session.delegate = self
        view.automaticallyUpdatesLighting = true
        view.antialiasingMode = .multisampling4X
        
        // Enable default lighting
        view.autoenablesDefaultLighting = true
        
        // Show statistics for debugging (can be disabled in production)
        #if DEBUG
        view.showsStatistics = true
        view.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        #endif
        
        return view
    }()
    
    static func getPlantController() -> UIViewController {
        let product =  ARProductModel(
            productId: "123",
            name: "indoor plant",
            localModelName: "indoorplant.usdz",
            price: "799"
        )
        let viewModel = ARProductShowcaseViewModel(product: product)
        let arVC = ARProductShowcaseViewController(viewModel: viewModel)
        return arVC
    }
    /// Instruction label for user guidance
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Point your camera at a flat surface"
        return label
    }()
    
    /// Reset button to remove placed object
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    /// Close button to dismiss the AR view
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("✕", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Product info container
    private lazy var productInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    /// Product name label
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    /// Product price label
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGreen
        return label
    }()
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: ARProductShowcaseViewModelProtocol
    
    /// AR configuration
    private let configuration = ARWorldTrackingConfiguration()
    
    /// Currently placed product node
    private var currentProductNode: ARProductNode?
    
    /// Plane visualization nodes
    private var planeNodes = [UUID: SCNNode]()
    
    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Initial pinch scale
    private var initialPinchScale: Float = 1.0
    
    // MARK: - Initialization
    
    /// Initializes the view controller with a view model
    /// - Parameter viewModel: The view model for AR showcase
    public init(viewModel: ARProductShowcaseViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        setupBindings()
        checkCameraPermissions()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseARSession()
    }
    
    // MARK: - Setup
    
    /// Sets up the user interface
    private func setupUI() {
        view.backgroundColor = .black
        
        // Add subviews
        view.addSubview(sceneView)
        view.addSubview(instructionLabel)
        view.addSubview(resetButton)
        view.addSubview(closeButton)
        view.addSubview(productInfoView)
        
        productInfoView.addSubview(productNameLabel)
        productInfoView.addSubview(productPriceLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Scene View
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Instruction Label
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Reset Button
            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 120),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Product Info View
            productInfoView.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -20),
            productInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Product Name Label
            productNameLabel.topAnchor.constraint(equalTo: productInfoView.topAnchor, constant: 12),
            productNameLabel.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: productInfoView.trailingAnchor, constant: -16),
            
            // Product Price Label
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productPriceLabel.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor, constant: 16),
            productPriceLabel.trailingAnchor.constraint(equalTo: productInfoView.trailingAnchor, constant: -16),
            productPriceLabel.bottomAnchor.constraint(equalTo: productInfoView.bottomAnchor, constant: -12)
        ])
        
        // Set product info
        productNameLabel.text = viewModel.product.name
        if let price = viewModel.product.price {
            productPriceLabel.text = price
        } else {
            productPriceLabel.isHidden = true
        }
    }
    
    /// Sets up gesture recognizers
    private func setupGestures() {
        // Tap gesture to place object
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        // Pinch gesture to scale object
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        
        // Rotation gesture
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        sceneView.addGestureRecognizer(rotationGesture)
        
        // Pan gesture to move object
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)
        
        // Allow simultaneous gestures
        tapGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGesture.delegate = self
    }
    
    /// Sets up Combine bindings
    private func setupBindings() {
        // Observe placement state changes
        viewModel.placementState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handlePlacementStateChange(state)
            }
            .store(in: &cancellables)
        
        // Observe feedback messages
        viewModel.feedbackMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.instructionLabel.text = message
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Camera Permissions
    
    /// Checks camera permissions before starting AR
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Already authorized, prepare AR
            viewModel.prepareARSession()
            
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.viewModel.prepareARSession()
                    } else {
                        self?.showCameraPermissionDeniedAlert()
                    }
                }
            }
            
        case .denied, .restricted:
            showCameraPermissionDeniedAlert()
            
        @unknown default:
            break
        }
    }
    
    /// Shows alert when camera permission is denied
    private func showCameraPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please enable camera access in Settings to use AR features.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - AR Session Management
    
    /// Starts the AR session
    private func startARSession() {
        guard viewModel.isARSupported() else {
            showARNotSupportedAlert()
            return
        }
        
        // Configure AR session for horizontal plane detection
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        
        // Run the session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    /// Pauses the AR session
    private func pauseARSession() {
        sceneView.session.pause()
    }
    
    /// Shows alert when AR is not supported
    private func showARNotSupportedAlert() {
        let alert = UIAlertController(
            title: "AR Not Supported",
            message: "This device does not support ARKit features.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - State Handling
    
    /// Handles placement state changes
    /// - Parameter state: New placement state
    private func handlePlacementStateChange(_ state: ARPlacementState) {
        switch state {
        case .objectPlaced:
            resetButton.isHidden = false
            hidePlaneNodes()
            
        case .planeDetected:
            showPlaneNodes()
            
        case .searchingForPlane:
            resetButton.isHidden = true
            
        case .error(let message):
            showErrorAlert(message: message)
            
        default:
            break
        }
    }
    
    /// Shows error alert
    /// - Parameter message: Error message
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Gesture Handlers
    
    /// Handles tap gesture to place object
    /// - Parameter gesture: Tap gesture recognizer
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        // Only place if plane is detected and no object is placed
        guard viewModel.placementState.value == .planeDetected else { return }
        
        let location = gesture.location(in: sceneView)
        
        // Perform hit test for horizontal planes
        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        guard let hitResult = hitTestResults.first else { return }
        
        // Get position from hit result
        let position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        // Place the product
        if let node = viewModel.placeProduct(at: position, in: sceneView.scene) {
            currentProductNode = node
        }
    }
    
    /// Handles pinch gesture to scale object
    /// - Parameter gesture: Pinch gesture recognizer
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let node = currentProductNode else { return }
        
        if gesture.state == .began {
            initialPinchScale = Float(gesture.scale)
        } else if gesture.state == .changed {
            let scale = Float(gesture.scale) / initialPinchScale
            viewModel.scaleObject(node: node, by: scale)
            initialPinchScale = Float(gesture.scale)
        }
    }
    
    /// Handles rotation gesture
    /// - Parameter gesture: Rotation gesture recognizer
    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let node = currentProductNode else { return }
        
        if gesture.state == .changed {
            viewModel.rotateObject(node: node, by: Float(gesture.rotation))
            gesture.rotation = 0
        }
    }
    
    /// Handles pan gesture to move object
    /// - Parameter gesture: Pan gesture recognizer
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let node = currentProductNode else { return }
        
        let location = gesture.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        guard let hitResult = hitTestResults.first else { return }
        
        let position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        viewModel.updateObjectPosition(node: node, to: position)
    }
    
    // MARK: - Button Actions
    
    /// Handles reset button tap
    @objc private func resetButtonTapped() {
        guard let node = currentProductNode else { return }
        
        viewModel.removeObject(node: node)
        currentProductNode = nil
        resetButton.isHidden = true
        showPlaneNodes()
    }
    
    /// Handles close button tap
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Plane Visualization
    
    /// Shows plane visualization nodes
    private func showPlaneNodes() {
        planeNodes.values.forEach { $0.isHidden = false }
    }
    
    /// Hides plane visualization nodes
    private func hidePlaneNodes() {
        planeNodes.values.forEach { $0.isHidden = true }
    }
    
    /// Creates a plane node for visualization
    /// - Parameter anchor: Plane anchor
    /// - Returns: SCNNode representing the plane
    private func createPlaneNode(for anchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        plane.firstMaterial?.diffuse.contents = UIColor.systemBlue.withAlphaComponent(0.3)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
        
        return planeNode
    }
    
    // MARK: - Deinitialization
    
    deinit {
        pauseARSession()
        cancellables.removeAll()
    }
}

// MARK: - ARSCNViewDelegate

extension ARProductShowcaseViewController: ARSCNViewDelegate {
    
    /// Called when a new plane anchor is added
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create plane visualization
        let planeNode = createPlaneNode(for: planeAnchor)
        node.addChildNode(planeNode)
        planeNodes[planeAnchor.identifier] = planeNode
        
        // Notify view model
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.handlePlaneDetection(anchor: planeAnchor)
        }
    }
    
    /// Called when a plane anchor is updated
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let planeNode = planeNodes[planeAnchor.identifier],
              let plane = planeNode.geometry as? SCNPlane else { return }
        
        // Update plane dimensions
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
    }
    
    /// Called when a plane anchor is removed
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        planeNodes.removeValue(forKey: planeAnchor.identifier)
    }
}

// MARK: - ARSessionDelegate

extension ARProductShowcaseViewController: ARSessionDelegate {
    
    /// Called when session is interrupted
    public func sessionWasInterrupted(_ session: ARSession) {
        instructionLabel.text = "Session interrupted"
    }
    
    /// Called when session interruption ends
    public func sessionInterruptionEnded(_ session: ARSession) {
        instructionLabel.text = "Session resumed"
        // Reset tracking
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    /// Called when session fails
    public func session(_ session: ARSession, didFailWithError error: Error) {
        instructionLabel.text = "Session failed: \(error.localizedDescription)"
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ARProductShowcaseViewController: UIGestureRecognizerDelegate {
    
    /// Allows multiple gestures to be recognized simultaneously
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}



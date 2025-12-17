//
//  ARProductShowcaseViewModel.swift
//  swiggy
//
//  Created by AI Assistant on 30/10/25.
//  Copyright © 2025 www.swiggy.com. All rights reserved.
//

import Foundation
import ARKit
import Combine

// MARK: - ARProductShowcaseViewModelProtocol

/// Protocol defining the interface for AR Product Showcase view model
public protocol ARProductShowcaseViewModelProtocol: AnyObject {
    
    // MARK: - Properties
    
    /// Current placement state
    var placementState: CurrentValueSubject<ARPlacementState, Never> { get }
    
    /// Product to showcase
    var product: ARProductModel { get }
    
    /// Whether AR session is ready
    var isARSessionReady: Bool { get }
    
    /// Feedback message for user
    var feedbackMessage: CurrentValueSubject<String?, Never> { get }
    
    // MARK: - Methods
    
    /// Checks if ARKit is supported on the device
    /// - Returns: True if AR is supported
    func isARSupported() -> Bool
    
    /// Prepares the AR session
    func prepareARSession()
    
    /// Handles plane detection
    /// - Parameter anchor: The detected plane anchor
    func handlePlaneDetection(anchor: ARPlaneAnchor)
    
    /// Places the product at the specified position
    /// - Parameters:
    ///   - position: The 3D position to place the product
    ///   - scene: The AR scene
    /// - Returns: The created product node
    func placeProduct(at position: SCNVector3, in scene: SCNScene) -> ARProductNode?
    
    /// Updates object position during drag
    /// - Parameters:
    ///   - node: The node being dragged
    ///   - position: New position
    func updateObjectPosition(node: ARProductNode, to position: SCNVector3)
    
    /// Handles rotation gesture
    /// - Parameters:
    ///   - node: The node to rotate
    ///   - rotation: Rotation angle in radians
    func rotateObject(node: ARProductNode, by rotation: Float)
    
    /// Handles scale gesture
    /// - Parameters:
    ///   - node: The node to scale
    ///   - scale: Scale factor
    func scaleObject(node: ARProductNode, by scale: Float)
    
    /// Removes the placed object from scene
    /// - Parameter node: The node to remove
    func removeObject(node: ARProductNode)
}

// MARK: - ARProductShowcaseViewModel

/// View model implementation for AR Product Showcase
public final class ARProductShowcaseViewModel: ARProductShowcaseViewModelProtocol {
    
    // MARK: - Properties
    
    /// Current placement state
    public let placementState = CurrentValueSubject<ARPlacementState, Never>(.idle)
    
    /// Product to showcase
    public let product: ARProductModel
    
    /// Whether AR session is ready
    public private(set) var isARSessionReady: Bool = false
    
    /// Feedback message for user
    public let feedbackMessage = CurrentValueSubject<String?, Never>(nil)
    
    /// Currently placed node
    private var placedNode: ARProductNode?
    
    /// Set to track detected planes
    private var detectedPlanes = Set<UUID>()
    
    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes the view model with a product
    /// - Parameter product: The product to showcase in AR
    public init(product: ARProductModel) {
        self.product = product
        setupObservers()
    }
    
    // MARK: - Setup
    
    /// Sets up observers for state changes
    private func setupObservers() {
        placementState
            .sink { [weak self] state in
                self?.updateFeedbackMessage(for: state)
            }
            .store(in: &cancellables)
    }
    
    /// Updates feedback message based on placement state
    /// - Parameter state: Current placement state
    private func updateFeedbackMessage(for state: ARPlacementState) {
        switch state {
        case .idle:
            feedbackMessage.send("Point your camera at a flat surface")
        case .searchingForPlane:
            feedbackMessage.send("Searching for surface...")
        case .planeDetected:
            feedbackMessage.send("Tap to place \(product.name)")
        case .objectPlaced:
            feedbackMessage.send("Pinch to scale, rotate with two fingers")
        case .loading:
            feedbackMessage.send("Loading 3D model...")
        case .error(let message):
            feedbackMessage.send("Error: \(message)")
        }
    }
    
    // MARK: - ARProductShowcaseViewModelProtocol
    
    /// Checks if ARKit is supported on the device
    /// - Returns: True if AR is supported
    public func isARSupported() -> Bool {
        return ARWorldTrackingConfiguration.isSupported
    }
    
    /// Prepares the AR session
    public func prepareARSession() {
        guard isARSupported() else {
            placementState.send(.error("AR is not supported on this device"))
            return
        }
        
        isARSessionReady = true
        placementState.send(.searchingForPlane)
    }
    
    /// Handles plane detection
    /// - Parameter anchor: The detected plane anchor
    public func handlePlaneDetection(anchor: ARPlaneAnchor) {
        // Track unique planes
        guard !detectedPlanes.contains(anchor.identifier) else { return }
        
        detectedPlanes.insert(anchor.identifier)
        
        // Update state if not already placed
        if placementState.value == .searchingForPlane {
            placementState.send(.planeDetected)
        }
    }
    
    /// Places the product at the specified position
    /// - Parameters:
    ///   - position: The 3D position to place the product
    ///   - scene: The AR scene
    /// - Returns: The created product node
    public func placeProduct(at position: SCNVector3, in scene: SCNScene) -> ARProductNode? {
        // Remove existing node if present
        if let existingNode = placedNode {
            removeObject(node: existingNode)
        }
        
        // Create new product node
        let productNode = ARProductNode(product: product)
        productNode.position = position
        
        // Update state to loading
        placementState.send(.loading)
        
        // Load the 3D model
        productNode.loadModel { [weak self] success in
            guard let self = self else { return }
            
            if success {
                self.placementState.send(.objectPlaced)
                self.placedNode = productNode
            } else {
                self.placementState.send(.error("Failed to load 3D model"))
            }
        }
        
        // Add to scene
        scene.rootNode.addChildNode(productNode)
        
        return productNode
    }
    
    /// Updates object position during drag
    /// - Parameters:
    ///   - node: The node being dragged
    ///   - position: New position
    public func updateObjectPosition(node: ARProductNode, to position: SCNVector3) {
        node.position = position
    }
    
    /// Handles rotation gesture
    /// - Parameters:
    ///   - node: The node to rotate
    ///   - rotation: Rotation angle in radians
    public func rotateObject(node: ARProductNode, by rotation: Float) {
        node.eulerAngles.y += rotation
    }
    
    /// Handles scale gesture
    /// - Parameters:
    ///   - node: The node to scale
    ///   - scale: Scale factor
    public func scaleObject(node: ARProductNode, by scale: Float) {
        let currentScale = node.scale
        let newScale = SCNVector3(
            currentScale.x * scale,
            currentScale.y * scale,
            currentScale.z * scale
        )
        
        // Clamp scale between reasonable limits
        let minScale: Float = 0.1
        let maxScale: Float = 5.0
        
        if newScale.x >= minScale && newScale.x <= maxScale {
            node.scale = newScale
        }
    }
    
    /// Removes the placed object from scene
    /// - Parameter node: The node to remove
    public func removeObject(node: ARProductNode) {
        node.removeFromParentNode()
        
        if placedNode === node {
            placedNode = nil
            placementState.send(.planeDetected)
        }
    }
    // MARK: - Deinitialization
    
    deinit {
        // Clean up resources
        placedNode?.removeFromParentNode()
        cancellables.removeAll()
    }
}

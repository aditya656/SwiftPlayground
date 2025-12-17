//
//  ARProductModel.swift
//  swiggy
//
//  Created by AI Assistant on 30/10/25.
//  Copyright © 2025 www.swiggy.com. All rights reserved.
//

import Foundation
import SceneKit

// MARK: - String Extension

private extension String {
    /// Returns the file path extension
    func pathExtension() -> String? {
        return (self as NSString).pathExtension
    }
    
    /// Returns the string without the file extension
    func deletingPathExtension() -> String {
        return (self as NSString).deletingPathExtension
    }
}

// MARK: - ARProductModel

/// Model representing a product to be displayed in AR
public struct ARProductModel {
    
    // MARK: - Properties
    
    /// Unique identifier for the product
    let productId: String
    
    /// Display name of the product
    let name: String
    
    /// Description of the product
    let description: String?
    
    /// URL to the 3D model file (.scn, .dae, .usdz, etc.)
    let modelURL: String?
    
    /// Local asset name for 3D model (if bundled in app)
    let localModelName: String?
    
    /// Product image URL (fallback if 3D model is unavailable)
    let imageURL: String?
    
    /// Scale factor for the 3D model (default: 1.0)
    let scale: Float
    
    /// Initial rotation in degrees (x, y, z)
    let rotation: SCNVector3
    
    /// Product price (optional)
    let price: String?
    
    /// Additional metadata
    let metadata: [String: Any]?
    
    // MARK: - Initialization
    
    /// Initializes a new AR product model
    /// - Parameters:
    ///   - productId: Unique identifier for the product
    ///   - name: Display name of the product
    ///   - description: Product description
    ///   - modelURL: Remote URL to 3D model
    ///   - localModelName: Local asset name for bundled 3D models
    ///   - imageURL: Fallback image URL
    ///   - scale: Scale factor for 3D model (default: 1.0)
    ///   - rotation: Initial rotation (default: zero)
    ///   - price: Product price
    ///   - metadata: Additional metadata
    public init(
        productId: String,
        name: String,
        description: String? = nil,
        modelURL: String? = nil,
        localModelName: String? = nil,
        imageURL: String? = nil,
        scale: Float = 1.0,
        rotation: SCNVector3 = SCNVector3Zero,
        price: String? = nil,
        metadata: [String: Any]? = nil
    ) {
        self.productId = productId
        self.name = name
        self.description = description
        self.modelURL = modelURL
        self.localModelName = localModelName
        self.imageURL = imageURL
        self.scale = scale
        self.rotation = rotation
        self.price = price
        self.metadata = metadata
    }
}

// MARK: - ARPlacementState

/// Represents the state of AR object placement
public enum ARPlacementState: Equatable {
    /// Initial state, no object placed
    case idle
    
    /// Searching for horizontal plane
    case searchingForPlane
    
    /// Plane detected, ready to place object
    case planeDetected
    
    /// Object placed on plane
    case objectPlaced
    
    /// Loading 3D model
    case loading
    
    /// Error occurred
    case error(String)
}

// MARK: - ARProductNode

/// Custom SCNNode for AR product display
public class ARProductNode: SCNNode {
    
    // MARK: - Properties
    
    /// Associated product model
    public let product: ARProductModel
    
    /// Whether the node is currently being dragged
    public var isDragging: Bool = false
    
    // MARK: - Initialization
    
    /// Initializes a new AR product node
    /// - Parameter product: The product model to represent
    public init(product: ARProductModel) {
        self.product = product
        super.init()
        setupNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /// Sets up the node with product properties
    private func setupNode() {
        // Apply scale
        self.scale = SCNVector3(product.scale, product.scale, product.scale)
        
        // Apply rotation
        self.eulerAngles = product.rotation
        
        // Add default geometry if no model is provided
        if product.localModelName == nil && product.modelURL == nil {
            let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
            box.firstMaterial?.diffuse.contents = UIColor.systemBlue
            self.geometry = box
        }
    }
    
    /// Loads the 3D model asynchronously
    /// - Parameter completion: Completion handler with success status
    public func loadModel(completion: ((Bool) -> Void)? = nil) {
        // Load from local asset first
        if let localModelName = product.localModelName {
            loadLocalModel(named: localModelName, completion: completion)
            return
        }
        
        // TODO: Implement remote model loading from modelURL
        // This would involve downloading the model and caching it
        
        completion?(false)
    }
    
    /// Loads model from app bundle
    /// - Parameters:
    ///   - modelName: Name of the model file (with extension)
    ///   - completion: Completion handler with success status
    private func loadLocalModel(named modelName: String, completion: ((Bool) -> Void)? = nil) {
        // Method 1: Try loading with SCNScene(named:)
        // This works for .scn, .dae, .abc files in the main bundle
        if let scene = SCNScene(named: modelName) {
            for child in scene.rootNode.childNodes {
                self.addChildNode(child)
            }
            completion?(true)
            return
        }
        
        // Method 2: Try loading from bundle with full path
        // This works for .usdz, .obj, and other formats
        guard let fileURL = Bundle.main.url(forResource: modelName.deletingPathExtension(),
                                           withExtension: modelName.pathExtension()) else {
            print("⚠️ Model file not found: \(modelName)")
            completion?(false)
            return
        }
        
        do {
            let scene = try SCNScene(url: fileURL, options: [
                .checkConsistency: true,
                .flattenScene: false
            ])
            
            // Add all child nodes from the scene
            for child in scene.rootNode.childNodes {
                self.addChildNode(child)
            }
            
            print("✅ Successfully loaded model: \(modelName)")
            completion?(true)
            
        } catch {
            print("❌ Failed to load model: \(modelName), error: \(error.localizedDescription)")
            completion?(false)
        }
    }
}


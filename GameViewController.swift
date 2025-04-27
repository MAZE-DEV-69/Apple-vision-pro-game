import UIKit
import RealityKit
import ARKit

class GameViewController: UIViewController {
    @IBOutlet var arView: ARView!
    var tetrisGame: TetrisGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal // Detect horizontal surfaces
        arView.session.run(configuration)
        
        // Initialize the game logic
        tetrisGame = TetrisGame(arView: arView)
        
        // Start the game loop
        tetrisGame.startGameLoop()
        
        // Add tap gesture to interact with blocks
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: arView)
        if let entity = arView.entity(at: location) {
            // Handle tap on the entity, such as rotating the block
            if let block = entity as? ModelEntity {
                block.transform.rotation *= simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
            }
        }
    }
}

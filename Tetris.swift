import ARKit
import RealityKit

class TetrisGame {
    var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 10), count: 20)  // A grid of blocks. They're not as tough as they look.
    var arView: ARView
    var currentBlock: ModelEntity?
    var gameTimer: Timer?
    
    init(arView: ARView) {
        self.arView = arView
    }

    func startGameLoop() {
        // Timer to update the game. Because you can’t just sit around waiting for things to fall.
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        spawnBlock() // Spawning blocks like a pro. Don't get cocky.
    }
    
    @objc func updateGame() {
        moveBlockDown() // Blocks fall. Always. Deal with it.
    }
    
    func spawnBlock() {
        currentBlock = createBlock() // Look, we made a block. It’s not much, but it’s honest work.
        let blockAnchor = AnchorEntity(world: SIMD3(x: 0, y: 1, z: -0.5)) // Start position. No, it’s not a vacation spot.
        blockAnchor.addChild(currentBlock!)
        arView.scene.addAnchor(blockAnchor)
    }
    
    func createBlock() -> ModelEntity {
        let block = ModelEntity(mesh: .generateBox(size: 0.1)) // A box. Really cutting-edge tech here, right?
        block.materials = [SimpleMaterial(color: .random(), isMetallic: false)] // Because every block needs some flair.
        return block
    }
    
    func moveBlockDown() {
        guard let block = currentBlock else { return }
        block.position.y -= 0.1 // Physics? Pffft, it’s just gravity doing its thing.
        if block.position.y <= -0.5 {
            placeBlock() // Block's hit the bottom. Yeah, welcome to reality.
        }
    }
    
    func placeBlock() {
        let gridX = Int(currentBlock!.position.x * 10) // Converting AR coordinates into grid. Because math, obviously.
        let gridY = Int(currentBlock!.position.y * 10)
        grid[gridY][gridX] = true // Marking the spot like a territorial animal. It's mine now.
        checkForFullLine() // Time to see if things are about to collapse.
        spawnBlock() // Here we go again... like a never-ending cycle.
    }
    
    func checkForFullLine() {
        for i in 0..<grid.count {
            if !grid[i].contains(false) { // Full line? I bet it's a mess.
                clearLine(at: i) // Clearing lines like it's my job.
            }
        }
    }
    
    func clearLine(at index: Int) {
        for i in stride(from: index, to: 0, by: -1) {
            grid[i] = grid[i-1] // Shifting down like I'm trying to get rid of the mess.
        }
        grid[0] = Array(repeating: false, count: 10) // Reset the top. It’s a new day, new mess.
        print("Line cleared... Guess the block's not the only thing that's falling apart.") // Yeah, that just happened.
    }
}

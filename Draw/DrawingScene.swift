import SpriteKit
import Foundation

open class DrawingScene: SKScene {
    
    open var pen: Pen!
    var background = SKSpriteNode(texture: SKTexture(imageNamed: "blank"))
    open var penSprite = SKSpriteNode()
    var lastShapeNode = 0
    var lastImage = #imageLiteral(resourceName: "blank.png")
    
    // ******************************************************************
    // ******************************************************************
    
    func draw() {
        // Your drawing code here
       
        moveFifty()
        rotateNinety()
        moveFifty()
        rotateNinety()
        moveFifty()
        rotateNinety()
        moveFifty()
        
       
    }
    
    // ******************************************************************
    // ******************************************************************
    
    
    
    override open func didMove(to view: SKView) {
        penSprite.size = CGSize(width: 20, height: 20)
        penSprite.position = CGPoint(x:160, y:284)
        penSprite.zPosition = 5000
        background.size = CGSize(width: 320, height: 568)
        background.position = CGPoint(x:160, y:284)
        background.zPosition = -1
        pen = Pen.sharedInstance
        addChild(background)
        addChild(penSprite)
        
        draw()
    }
    
    open override func update(_ currentTime: TimeInterval) {
        penSprite.position = pen.position
        penSprite.zRotation = pen.rotation
        
        if pen.processing {
            pen.newShapeNode()
            if (self.view?.texture(from: background)) != nil {
                let image = lastImage
                image.lockFocus()
                NSGraphicsContext.current?.shouldAntialias = true
                for i in lastShapeNode ..< (pen.shapeNodes.count - 1) {
                    let data = pen.shapeNodes[i]!
                    if data.numberOfPoints > 0 {
                        let path = data.path
                        data.color.set()
                        path.stroke()
                    }
                    lastShapeNode += 1
                    pen.shapeNodes[i] = nil
                }
                image.unlockFocus()
                
                lastImage = image
                background.texture = SKTexture(image: lastImage)
                
                if !pen.processing {
                    pen.shapeNodes = [ShapeNodeData?]()
                }
            }
        }
    }
    
    open class func setup() -> SKView {
        let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        
        sceneView.wantsLayer = true
        let scene = DrawingScene(fileNamed: "DrawingScene")!
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
        return sceneView
    }
}

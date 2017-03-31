//: Playground - noun: a place where people can play
import PlaygroundSupport
import UIKit
import SpriteKit
import GameplayKit

class Scene: SKScene, SKPhysicsContactDelegate{
    var secondView = SKView()
    
    var birdNodes = [SKSpriteNode]()
    var pigs = [SKSpriteNode]()
    
    var birdNodesTurn = true
    
    var switchPlayer = SKSpriteNode()
    var playButton = SKSpriteNode()
    
    var index = [-1, -1]
    var shapeLayers = [[CAShapeLayer]]()
    var layerEndPoints = [[CGPoint]]()
    var touchPoint: CGPoint?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.459, green: 0.820, blue: 0.973, alpha: 1.00)
        
        self.physicsWorld.contactDelegate = self
        
        let logo = SKSpriteNode(texture: SKTexture(imageNamed: "Logo.png"))
        logo.xScale = 0.0008
        logo.yScale = 0.0008
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - logo.frame.height * 2 / 3)
        addChild(logo)
        
        
        
        switchPlayer = SKSpriteNode(texture: SKTexture(imageNamed: "changePlayer.png"))
        switchPlayer.xScale = 0.001
        switchPlayer.yScale = 0.001
        switchPlayer.position = CGPoint(x: self.frame.minX + self.frame.width / 4, y: self.frame.minY + switchPlayer.frame.height * 2 / 3)
        addChild(switchPlayer)
        
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "play.png"))
        playButton.xScale = 0.001
        playButton.yScale = 0.001
        playButton.position = CGPoint(x: self.frame.minX + (self.frame.width / 4) * 3, y: self.frame.minY + playButton.frame.height * 2/3)
        playButton.isHidden = true
        addChild(playButton)
        
        secondView = SKView(frame: CGRect(x: view.frame.midX, y: view.frame.midY, width: 350, height: 350))
        secondView.center.x = view.frame.midX
        secondView.center.y = view.frame.midY
        secondView.layer.masksToBounds = false
        secondView.layer.cornerRadius = 20
        secondView.layer.zPosition = 0
        secondView.clipsToBounds = false

        makeNodes()
        
        for i in 0...1{
            shapeLayers.append([CAShapeLayer]())
            layerEndPoints.append([CGPoint]())
            for j in 0...2{
                let shape = CAShapeLayer()
                shape.strokeColor = UIColor.black.cgColor
                shape.lineWidth = 4
                shapeLayers[i].append(shape)
//                secondView.layer.addSublayer(shape)
                self.view?.layer.addSublayer(shape)
                layerEndPoints[i].append(CGPoint(x: 0, y: 0))
            }
        }
    }
    

    
    func makeNodes(){
        for num in -1...1 {
            
            let birdNode = SKSpriteNode(texture: SKTexture(imageNamed: "Bird.png"))
            birdNode.position = CGPoint(x: self.frame.midX + self.frame.width / 3, y: self.frame.midY + CGFloat(-num) * self.frame.height / 3)
            birdNode.setScale(CGFloat(0.0005))
            birdNode.physicsBody = SKPhysicsBody(circleOfRadius: birdNode.size.height / 2)
            birdNode.physicsBody?.allowsRotation = true
            birdNode.physicsBody?.affectedByGravity = false
            birdNode.physicsBody?.isDynamic = true
            birdNode.physicsBody!.angularDamping = 2
            birdNode.zPosition = 10
            birdNodes.append(birdNode)
            
            let pigNode = SKSpriteNode(texture: SKTexture(imageNamed: "Pig.png"))
            pigNode.position = CGPoint(x: self.frame.midX - self.frame.width / 3, y: self.frame.midY + CGFloat(num) * self.frame.height / 3)
//            pigNode.xScale = 0.0002
//            pigNode.yScale = 0.0002
            pigNode.setScale(CGFloat(0.000333))
            pigNode.physicsBody = SKPhysicsBody(circleOfRadius: pigNode.size.height / 2)
            pigNode.physicsBody?.affectedByGravity = false
            pigNode.physicsBody?.isDynamic = true
            pigNode.physicsBody?.allowsRotation = true
            pigNode.physicsBody!.angularDamping = 2
            pigNode.zPosition = 10
            pigs.append(pigNode)
            
            addChild(birdNode)
            addChild(pigNode)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact")
    }
    
    
    var hasTouched = [false, false, false]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if birdNodesTurn{
            for i in 0...2{
                if birdNodes[i].contains(touch.location(in: secondView)){
                    touchPoint = birdNodes[i].position
                    index[0] = 0
                    index[1] = i
                    hasTouched[i] = true
                }
            }
            
        }else{
            for i in 0...2{
                if pigs[i].contains(touch.location(in: secondView)){
                    touchPoint = pigs[i].position
                    index[0] = 1
                    index[1] = i
                    hasTouched[i] = true
                }
            }
        }
        if switchPlayer.contains(touch.location(in: self)){
            var allIsWell = true
            for i in hasTouched{ if !i { allIsWell = false } }
            if allIsWell{
                for i in shapeLayers[0]{
                    i.isHidden = true
                    i.strokeColor = UIColor(red: 0.824, green: 0.043, blue: 0.196, alpha: 1.00).cgColor
                }
                newTurn()
            }
        }
        if playButton.contains(touch.location(in: self)){
            var allIsWell = true
            for i in hasTouched{ if !i { allIsWell = false } }
            if allIsWell{
                for i in shapeLayers[0]{
                    i.isHidden = false
                }
                for i in shapeLayers[1]{
                    i.strokeColor = UIColor(red: 0.443, green: 0.878, blue: 0.325, alpha: 1.00).cgColor
                }
                self.run(SKAction.wait(forDuration: 2)){
                    self.resetTurn()
                }
            }
        }
        
    }
    
    
    
    
    func newTurn() {
        birdNodesTurn = !birdNodesTurn
        for i in 0...2 { hasTouched[i] = false }
        switchPlayer.isHidden = true
        playButton.isHidden = false
    }
    
    func resetTurn() {
        
        for j in shapeLayers{
            for i in j{
                i.isHidden = true
                i.removeFromSuperlayer()
            }
        }
        
        for i in 0...2{
            let birdPoint = layerEndPoints[0][i]
            let pigPoint = layerEndPoints[1][i]
            let birdX = birdPoint.x - birdNodes[i].position.x
            let birdY = birdPoint.y - birdNodes[i].position.y
            let pigX = pigPoint.x - pigs[i].position.x
            let pigY = pigPoint.y - pigs[i].position.y
            
            
            var a = 0
            switch (i){
            case 0: a = 2
            case 1: a = 1
            case 2: a = 0
            default: break
            }
            
            birdNodes[a].physicsBody?.applyImpulse(CGVector(dx: birdX/25, dy: -birdY/25))
            pigs[a].physicsBody?.applyImpulse(CGVector(dx: pigX/25, dy: -pigY/25))
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if index[0] != -1{
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: touchPoint!)
            
            let touch = touches.first!
            let location = touch.location(in: secondView)
            bezierPath.addLine(to: location)
            
            let shape = shapeLayers[index[0]][index[1]]
            shape.path = bezierPath.cgPath
            
            layerEndPoints[index[0]][index[1]] = location
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for i in 0...2{
            birdNodes[i].physicsBody?.velocity = CGVector(dx: (birdNodes[i].physicsBody?.velocity.dx)! / 1.05, dy: (birdNodes[i].physicsBody?.velocity.dy)! / 1.05)
            pigs[i].physicsBody?.velocity = CGVector(dx: pigs[i].physicsBody!.velocity.dx / 1.05, dy: pigs[i].physicsBody!.velocity.dy / 1.05)
        }
    }
    
}

extension SKScene{
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}





let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
let view = SKView(frame: frame)
view.layer.masksToBounds = true
view.layer.cornerRadius = 16

let scene = Scene()
view.presentScene(scene)
PlaygroundPage.current.liveView = view

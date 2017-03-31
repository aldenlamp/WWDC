//: Playground - noun: a place where people can play
import PlaygroundSupport
import UIKit
import SpriteKit
import GameplayKit

class Scene: SKScene, SKPhysicsContactDelegate{
//    var secondView = SKView()
    var secondView = SKSpriteNode()
    
    var birdNodes = [SKSpriteNode]()
    var pigs = [SKSpriteNode]()
    
    var birdNodesTurn = true
    
    var switchPlayer = SKSpriteNode()
    var playButton = SKSpriteNode()
    
    var index = [-1, -1]
    var shapeLayers = [[CAShapeLayer]]()
    var layerEndPoints = [[CGPoint]]()
    var touchPoint: CGPoint?
    
//    var objectLine : SKC
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.459, green: 0.820, blue: 0.973, alpha: 1.00)
        
        self.physicsWorld.contactDelegate = self
        
        let logo = SKSpriteNode(texture: SKTexture(imageNamed: "Logo.png"))
        logo.xScale = 0.6
        logo.yScale = 0.6
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - logo.frame.height * 2 / 3)
        addChild(logo)
        
        switchPlayer = SKSpriteNode(texture: SKTexture(imageNamed: "changePlayer.png"))
        switchPlayer.xScale = 0.6
        switchPlayer.yScale = 0.6
        switchPlayer.position = CGPoint(x: self.frame.origin.x + self.frame.width / 4, y: self.frame.origin.y + switchPlayer.frame.height * 2 / 3)
        addChild(switchPlayer)
        
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "play.png"))
        playButton.xScale = 0.6
        playButton.yScale = 0.6
        playButton.position = CGPoint(x: self.frame.minX + (self.frame.width / 4) * 3, y: self.frame.minY + playButton.frame.height * 2/3)
        playButton.isHidden = true
        addChild(playButton)
        
//        secondView = SKView(frame: CGRect(x: view.frame.midX, y: view.frame.midY, width: 350, height: 350))
        
        secondView = SKSpriteNode(imageNamed: "whiteness.png")
        secondView.position = CGPoint(x: self.position.x + self.size.width / 2, y: self.position.y + self.size.height / 2)
        secondView.size = CGSize(width: 350, height: 350)
        self.addChild(secondView)
//        secondView.center.x = view.frame.midX
//        secondView.center.y = view.frame.midY
//        secondView.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
//        secondView.layer.masksToBounds = false
//        secondView.clipsToBounds = false
//        secondView.layer.cornerRadius = 20
//        secondView.layer.zPosition = 0
//        secondView.backgroundColor = UIColor.white
//
//        let secondScene = SKScene(size: secondView.frame.size)
//        secondScene.backgroundColor = UIColor.white
//        secondScene.size = CGSize(width: 350, height: 350)
//        secondView.presentScene(secondScene)
//        self.view?.addSubview(secondView)
        secondView.position
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
//            birdNode.position = CGPoint(x: secondView.scene!.frame.midX + secondView.scene!.frame.width / 3, y: secondView.scene!.frame.midY + CGFloat(-num) * secondView.scene!.frame.height / 3)
//            birdNode.position = CGPoint(x: self.frame.midX + self.frame.width / 3, y: self.frame.midY + CGFloat(-num) * self.frame.height / 3)
//            birdNode.position = CGPoint(x: secondView.frame.origin.x + secondView.frame.width / 3, y: secondView.frame.origin.y + CGFloat(-num) * secondView.frame.height / 3)
//            birdNode.position = CGPoint(x: (self.view?.frame.midX)! + self.frame.width / 4, y: (self.view?.frame.midY)! + CGFloat(-num) * self.frame.height / 4)
            birdNode.name = "bird\(num)"
            birdNode.position = CGPoint(x: secondView.position.x + secondView.size.width * 1 / 3.0, y: secondView.position.y + CGFloat(-num ) * secondView.size.height / 3)
            print(birdNode.position)
            birdNode.setScale(CGFloat(0.21))
//            birdNode.setScale(CGFloat(0.0005))
            birdNode.physicsBody = SKPhysicsBody(circleOfRadius: birdNode.size.height / 2)
            birdNode.physicsBody?.allowsRotation = true
            birdNode.physicsBody?.affectedByGravity = false
            birdNode.physicsBody?.isDynamic = true
            birdNode.physicsBody!.angularDamping = 2
            birdNode.zPosition = 100
            birdNodes.append(birdNode)
            
            let pigNode = SKSpriteNode(texture: SKTexture(imageNamed: "Pig.png"))
//            pigNode.position = CGPoint(x: secondView.scene!.frame.midX - secondView.scene!.frame.width / 3, y: secondView.scene!.frame.midY + CGFloat(-num) * secondView.scene!.frame.height / 3)
            pigNode.position = CGPoint(x: secondView.position.x - secondView.size.width * 1 / 3.0, y: secondView.position.y + CGFloat(-num ) * secondView.size.height / 3)
            pigNode.name = "pig\(num)"
            pigNode.setScale(CGFloat(0.135))
//            pigNode.setScale(CGFloat(0.0003214285714))
            pigNode.physicsBody = SKPhysicsBody(circleOfRadius: pigNode.size.height / 2)
            pigNode.physicsBody?.affectedByGravity = false
            pigNode.physicsBody?.isDynamic = true
            pigNode.physicsBody?.allowsRotation = true
            pigNode.physicsBody!.angularDamping = 2
            pigNode.zPosition = 100
            pigs.append(pigNode)
            print(pigNode.position)
//            secondView.scene!.addChild(birdNode)
//            secondView.scene!.addChild(pigNode)
            
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
        let touchLocation = touch.location(in: self)
        let touchedNode = self.nodes(at: touchLocation)
        print(touchedNode)
        touchedNode.forEach{
            print($0.name)
        }
        if birdNodesTurn{
            for i in 0...2{
                if birdNodes[i].name == touchedNode.first?.name {
//                    touchPoint = birdNodes[i].position
                    touchPoint = CGPoint(x: birdNodes[i].position.x, y: flipOverPoint(value: self.size.height / 2.0, point: birdNodes[i].position.y))
                    index[0] = 0
                    index[1] = i
                    print(touchPoint)
                    hasTouched[i] = true
                }
            }
            
        }else{
            for i in 0...2{
                if pigs[i].name == touchedNode.first?.name{
//                    touchPoint = pigs[i].position
                    touchPoint = CGPoint(x: pigs[i].position.x, y: flipOverPoint(value: self.size.height / 2.0, point: pigs[i].position.y))
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
    
    func flipOverPoint(value:CGFloat, point: CGFloat)->CGFloat{
        return value * 2 - point
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
            let location = touch.location(in: self)
            print(location)
            bezierPath.addLine(to: CGPoint(x: location.x, y:  flipOverPoint(value: 250, point: location.y)))
            
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





let frame = CGRect(x: 0, y: 0, width: 500, height: 500)
let view = SKView(frame: frame)
view.layer.masksToBounds = true
view.layer.cornerRadius = 16

let scene = Scene()
scene.size = frame.size
view.presentScene(scene)
PlaygroundPage.current.liveView = view

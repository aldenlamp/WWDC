//: Playground - noun: a place where people can play
import PlaygroundSupport
import UIKit
import SpriteKit
import GameplayKit

class Scene: SKScene, SKPhysicsContactDelegate{

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
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.459, green: 0.820, blue: 0.973, alpha: 1.00)
        
        self.physicsWorld.contactDelegate = self
        
        let logo = SKSpriteNode(texture: SKTexture(imageNamed: "Logo.png"))
        logo.xScale = 0.6
        logo.yScale = 0.6
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - logo.frame.height * 2 / 3)
        addChild(logo)
        
//        let node = SKNode()
//        node.position = CGPoint(x: secondView.frame.maxX, y: secondView.frame.minY)
        
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
        

        secondView = SKSpriteNode(imageNamed: "whiteness.png")
        secondView.position = CGPoint(x: self.position.x + self.size.width / 2, y: self.position.y + self.size.height / 2)
        secondView.size = CGSize(width: 350, height: 350)
//        secondView.physicsBody = SKPhysicsBody(edgeLoopFrom: secondView.frame)
//        secondView.physicsBody?.isDynamic = false
//        secondView.physicsBody?.affectedByGravity = false
//        secondView.physicsBody?.allowsRotation = false
//        secondView.physicsBody?.categoryBitMask = 1
//        secondView.name = "White View"
        self.addChild(secondView)


        makeNodes()
        
        for i in 0...1{
            shapeLayers.append([CAShapeLayer]())
            layerEndPoints.append([CGPoint]())
            for _ in 0...2{
                let shape = CAShapeLayer()
                shape.strokeColor = UIColor.black.cgColor
                shape.lineWidth = 4
                shapeLayers[i].append(shape)
                self.view?.layer.addSublayer(shape)
                layerEndPoints[i].append(CGPoint(x: 0, y: 0))
            }
        }
    }
    

    
    func makeNodes(){
        for num in -1...1 {
            
            let birdNode = SKSpriteNode(texture: SKTexture(imageNamed: "Bird.png"))
            birdNode.name = "bird\(num + 1)"
            birdNode.position = CGPoint(x: secondView.position.x + secondView.size.width * 1 / 3.0, y: secondView.position.y + CGFloat(-num ) * secondView.size.height / 3)
            birdNode.setScale(CGFloat(0.15))

            birdNode.physicsBody = SKPhysicsBody(circleOfRadius: birdNode.size.height / 2)
            birdNode.physicsBody?.allowsRotation = true
            birdNode.physicsBody?.affectedByGravity = false
            birdNode.physicsBody?.isDynamic = true
            birdNode.physicsBody!.angularDamping = 2
            birdNode.zPosition = 100
//            birdNode.physicsBody?.restitution = 1.000009
//            birdNode.physicsBody?.categoryBitMask = 0
//            birdNode.physicsBody?.contactTestBitMask = 1
//            birdNode.physicsBody?.collisionBitMask = 1
            birdNodes.append(birdNode)
            
            let pigNode = SKSpriteNode(texture: SKTexture(imageNamed: "Pig.png"))
            pigNode.position = CGPoint(x: secondView.position.x - secondView.size.width * 1 / 3.0, y: secondView.position.y + CGFloat(-num ) * secondView.size.height / 3)
            pigNode.name = "pig\(num + 1)"
            pigNode.setScale(CGFloat(0.105))
            
            pigNode.physicsBody = SKPhysicsBody(circleOfRadius: pigNode.size.height / 2)
            pigNode.physicsBody?.affectedByGravity = false
            pigNode.physicsBody?.isDynamic = true
            pigNode.physicsBody?.allowsRotation = true
            pigNode.physicsBody!.angularDamping = 2
//            pigNode.physicsBody?.restitution = 1.000009
//            pigNode.physicsBody?.categoryBitMask = 1
//            pigNode.physicsBody?.contactTestBitMask = 2
//            pigNode.physicsBody?.collisionBitMask = 2
            
            pigNode.zPosition = 100
            pigs.append(pigNode)
            
            addChild(birdNode)
            addChild(pigNode)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact Happened: A: \(contact.bodyA.node?.name), B: \(contact.bodyB.node?.name)")
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("Contact Ended: A: \(contact.bodyA.node?.name), B: \(contact.bodyB.node?.name) ")
    }
    
    
    var hasTouched = [false, false, false]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = self.nodes(at: touchLocation)
        if birdNodesTurn{
            for i in 0...2{
                if birdNodes[i].name == touchedNode.first?.name {
//                    touchPoint = birdNodes[i].position
                    touchPoint = CGPoint(x: birdNodes[i].position.x, y: flipOverPoint(value: self.size.height / 2.0, point: birdNodes[i].position.y))
                    index[0] = 0
                    index[1] = i
                    hasTouched[i] = true
                }
            }
        
        }else{
            
            for i in 0...2{
                
                if pigs[i].name == touchedNode.first?.name{
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
                birdNodesTurn = !birdNodesTurn
                for i in 0...2 { hasTouched[i] = false }
                switchPlayer.isHidden = true
                playButton.isHidden = false
                index = [-1, -1]
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
    
    var shouldCheck = false
    
    func resetTurn() {
        
        shouldCheck = true
        
        for j in shapeLayers{
            for i in j{
                i.isHidden = true
            }
        }
        for i in 0...2{
            hasTouched[i] = false
            let birdPoint = layerEndPoints[0][i]
            let pigPoint = layerEndPoints[1][i]

            birdNodes[i].physicsBody?.applyImpulse(CGVector(dx: (birdPoint.x - birdNodes[i].position.x) / 17, dy: (birdPoint.y - birdNodes[i].position.y) / 17))
            pigs[i].physicsBody?.applyImpulse(CGVector(dx: (pigPoint.x - pigs[i].position.x) / 17, dy: (pigPoint.y - pigs[i].position.y) / 17))
        }
    }
    
    func finishResetingTurn(){
        shouldCheck = false
        print("\n\nShould Check is Checking Now\n\n")
        for i in 0...20{
            self.run(SKAction.wait(forDuration: TimeInterval(Double(i) / 20.0))){
                self.secondView.size = CGSize(width: self.secondView.size.width - 2, height: self.secondView.size.height - 2)
                if i == 20 { self.editView() }
            }
        }
    }
    
    func editView(){
        for j in shapeLayers{
            for i in j{
                i.isHidden = false
                i.path = UIBezierPath().cgPath
                i.strokeColor = UIColor.black.cgColor
            }
        }
        
        playButton.isHidden = true
        switchPlayer.isHidden = false
        
        birdNodesTurn = true
        index[0] = -1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if index[0] != -1{
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: touchPoint!)
            
            let touch = touches.first!
            let location = touch.location(in: self)
            
            
            
//            let m = (newPoint.y - touchPoint!.y)/(newPoint.x - touchPoint!.x)
//            let b = newPoint.y / (newPoint.x * m)
            
            var newPoint = CGPoint(x: location.x, y: flipOverPoint(value: 250, point: location.y))
            
            let dist = sqrt(pow(newPoint.x - touchPoint!.x, 2) + pow(newPoint.y - touchPoint!.y, 2))
            
            if dist > 175{
                let ratio = 175.0 / dist
                let newx = (newPoint.x - touchPoint!.x) * ratio + touchPoint!.x
                let newy = (newPoint.y - touchPoint!.y) * ratio + touchPoint!.y
                newPoint = CGPoint(x: newx, y: newy)
            }
//            let x = CGFloat(175) / dist * (newPoint.x - touchPoint!.x)
//            let y = CGFloat(175) / dist * (newPoint.y - touchPoint!.y)
            
            
            bezierPath.addLine(to: newPoint)
            
            let shape = shapeLayers[index[0]][index[1]]
            shape.path = bezierPath.cgPath
            
            layerEndPoints[index[0]][index[1]] = location
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var allStopped = true
        for i in 0...2{
            birdNodes[i].physicsBody?.velocity = CGVector(dx: (birdNodes[i].physicsBody?.velocity.dx)! / 1.05, dy: (birdNodes[i].physicsBody?.velocity.dy)! / 1.05)
            pigs[i].physicsBody?.velocity = CGVector(dx: pigs[i].physicsBody!.velocity.dx / 1.05, dy: pigs[i].physicsBody!.velocity.dy / 1.05)
            
            if birdNodes[i].physicsBody!.velocity.dx > 0.0 || birdNodes[i].physicsBody!.velocity.dy > 0.0 || pigs[i].physicsBody!.velocity.dx > 0.0 || pigs[i].physicsBody!.velocity.dy > 0.0{
                allStopped = false
            }
            
            
        }
        if shouldCheck && allStopped { finishResetingTurn() }
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

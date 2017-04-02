//: Playground - noun: a place where people can play
import PlaygroundSupport
import UIKit
import SpriteKit
import GameplayKit

class Scene: SKScene{

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
        

        secondView = SKSpriteNode(imageNamed: "whiteness.png")
        secondView.position = CGPoint(x: self.position.x + self.size.width / 2, y: self.position.y + self.size.height / 2)
        secondView.size = CGSize(width: 350, height: 350)
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
            pigNode.zPosition = 100
            pigs.append(pigNode)
            
            addChild(birdNode)
            addChild(pigNode)
            
        }
    }
    
    var hasTouched = [false, false, false]
    var inboundNodes = [[false, false, false],[false, false, false]]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = self.nodes(at: touchLocation)
        if birdNodesTurn{
            for i in 0...2{
                if birdNodes[i].name == touchedNode.first?.name {
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
            for i in 0...2{ if !hasTouched[i] && !inboundNodes[0][i] { allIsWell = false } }
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
            for i in 0...2{ if !hasTouched[i] && !inboundNodes[1][i] { allIsWell = false } }
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
            shouldCheck = true
        }
    }
    
    func finishResetingTurn(){
        shouldCheck = false
        print("Pre: \(secondView.frame.height - 40)\t\(secondView.frame.height)\tDiff: \((secondView.frame.height - 40) / secondView.frame.height)")
        let scale = SKAction.scale(by: (secondView.frame.height - 40) / secondView.frame.height, duration: 1)
        secondView.run(scale){
            print(self.secondView.frame.size)
            self.editView()
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
            
            var newPoint = CGPoint(x: location.x, y: flipOverPoint(value: 250, point: location.y))
            
            let dist = sqrt(pow(newPoint.x - touchPoint!.x, 2) + pow(newPoint.y - touchPoint!.y, 2))
            
            if dist > 175{
                let ratio = 175.0 / dist
                let newx = (newPoint.x - touchPoint!.x) * ratio + touchPoint!.x
                let newy = (newPoint.y - touchPoint!.y) * ratio + touchPoint!.y
                newPoint = CGPoint(x: newx, y: newy)
            }
            
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
            
            if !secondView.contains(birdNodes[i].position){
                birdNodes[i].removeFromParent()
                inboundNodes[0][i] = true
            }
            
            if !secondView.contains(pigs[i].position){
                pigs[i].removeFromParent()
                inboundNodes[1][i] = true
            }
            
            if ((birdNodes[i].physicsBody!.velocity.dx > 0.0 || birdNodes[i].physicsBody!.velocity.dy > 0.0) && !inboundNodes[0][i]) || ((pigs[i].physicsBody!.velocity.dx > 0.0 || pigs[i].physicsBody!.velocity.dy > 0.0) && inboundNodes[1][i]){
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

import UIKit

import Foundation

@IBDesignable class RunCircles : UIView{
   
    @IBInspectable var bigCircleColor: UIColor = UIColor.blueColor()
    @IBInspectable var smallCircleColor: UIColor = UIColor.orangeColor()
    @IBInspectable var outlineColorSmall: UIColor = UIColor.blueColor()
    @IBInspectable var outlineColorBig: UIColor = UIColor.blueColor()
    var arcWidthSmall: CGFloat = 27.0
    var maxValueSmall:Int = 0
    var counterSmall: Int = 0 {
        didSet {
            if counterSmall <=  maxValueSmall {
                setNeedsDisplay()
            }
        }
    }
    var arcWidthBig: CGFloat = 30.0
    var maxValueBig:Int = 0
    var counterBig: Int = 0 {
        didSet {
            if counterBig <=  maxValueBig {
                setNeedsDisplay()
            }
        }
    }


    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(bounds.width - bounds.width*(5/6),  4, bounds.width*(5/6)-4, bounds.width*(5/6)))
        //smallCircleColor.setStroke()
        bigCircleColor.setFill()
        circlePath.lineWidth = 4
        circlePath.fill()
        //circlePath.stroke()
        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = π / 2
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        let centerBig = CGPoint(x:bounds.width - bounds.width*5/12, y: bounds.height*5/12+4)

        let arcLengthPerGlassBig = angleDifference / CGFloat(maxValueBig)
        
        let outlineEndAngleBig = arcLengthPerGlassBig * CGFloat(counterBig) + startAngle
        
        let outlinePathBig = UIBezierPath(arcCenter: centerBig,
                                          radius: bounds.width*5/12 - 2.5,
                                          startAngle: startAngle,
                                          endAngle: outlineEndAngleBig,
                                          clockwise: true)
        
//        outlinePathBig.addArcWithCenter(centerBig,
//                                        radius: bounds.width*5/12 - arcWidthBig + 2.5,
//                                        startAngle: outlineEndAngleBig,
//                                        endAngle: startAngle,
//                                        clockwise: false)
        
//        outlinePathBig.closePath()
        outlineColorBig.setStroke()
        outlinePathBig.lineWidth = 15.0
        outlinePathBig.stroke()

        
        let circlePath2 = UIBezierPath(ovalInRect: CGRectMake(0,  bounds.width*(1/2), bounds.width*(1/2), bounds.width*(1/2)))
        let trColor = smallCircleColor.colorWithAlphaComponent(0.7)
        trColor.setFill()
        circlePath2.fill()
        
        let center = CGPoint(x:bounds.width/4, y: bounds.height*3/4)
        
        //let radius: CGFloat = max(bounds.width/2, bounds.height/2)
        
        let arcLengthPerGlass = angleDifference / CGFloat(maxValueSmall)
        
       
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counterSmall) + startAngle
        
       
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/4 - 2.5,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
       
//        outlinePath.addArcWithCenter(center,
//                                     radius: bounds.width/4 - arcWidthSmall + 2.5,
//                                     startAngle: outlineEndAngle,
//                                     endAngle: startAngle,
//                                     clockwise: false)
//       
//        outlinePath.closePath()
       // let trColor2 = outlineColorBig.colorWithAlphaComponent(0.7)
        
        outlineColorSmall.setStroke()
        outlinePath.lineWidth = 10.0
        outlinePath.stroke()
//        let diceRoll = Int(arc4random_uniform(2))
//        if(diceRoll == 0){
//            let circlePath = UIBezierPath(ovalInRect: CGRectMake(bounds.width - 20,  bounds.width - 20, 20, 20))
//            
//            UIColor.greenColor().setFill()
//            circlePath.fill()
//        } else{
//            let circlePath = UIBezierPath(ovalInRect: CGRectMake(0,  0, 20, 20))
//            
//            UIColor.blueColor().setFill()
//            circlePath.fill()
//        }
//        
//        print(diceRoll)
        
        
    }
}
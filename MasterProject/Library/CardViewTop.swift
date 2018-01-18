
import UIKit

@IBDesignable
class CardViewTop: UIView {

    @IBInspectable var cornerRadius: CGFloat = 15
    @IBInspectable var cornerRadiusWidth: CGFloat = 15.0
    @IBInspectable var cornerRadiusHeight: CGFloat = 15.0

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.clear
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
//        layer.cornerRadius = cornerRadius
      //  let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        let shadowPath = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii:CGSize(width: cornerRadiusWidth, height: cornerRadiusHeight))

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

}

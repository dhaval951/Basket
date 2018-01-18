//
//  CustomTextField.swift
//  MasterProject
//
//  Created by Sanjay Shah on 03/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    // MARK: View components
    
    /// The internal `UIView` to display the line below the text input.
    open var lineView:UIView!
    
    fileprivate var _renderingInInterfaceBuilder:Bool = false
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// The backing property for the highlighted property
    fileprivate var _highlighted = false
    
    /// A Boolean value that determines whether the receiver is highlighted. When changing this value, highlighting will be done with animation
    override open var isHighlighted:Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            self.updateLineView()
        }
    }
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected:Bool {
        get {
            return super.isEditing || self.isSelected
        }
    }
    
    /// A Boolean value that determines if the language displayed is LTR. Default value set automatically from the application language settings.
    var isLTRLanguage = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
            self.updateTextAligment()
        }
    }
    
    fileprivate func updateTextAligment() {
        if(self.isLTRLanguage) {
            self.textAlignment = .left
        } else {
            self.textAlignment = .right
        }
    }
    
    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable open var placeholderColor:UIColor = UIColor.lightGray {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable open var placeholderFont:UIFont? {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    fileprivate func updatePlaceholder() {
        if let
            placeholder = self.placeholder,
            let font = self.placeholderFont ?? self.font {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName:placeholderColor,
                                                                                              NSFontAttributeName: font])
        }
    }
    
    /// A UIImage value that set LeftImage to the UItextfield
    @IBInspectable open var leftImage:UIImage? {
        didSet {
            if (leftImage != nil) {
                self.leftImage(leftImage!)
            }
        }
    }
    
    fileprivate func leftImage(_ image: UIImage)
    {
        rightPadding()
        
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        imageView.frame = CGRect(x: 0, y: 0, width: icn.size.width + 20, height: icn.size.height)
        imageView.contentMode = UIViewContentMode.center
        self.leftViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        view.addSubview(imageView)
        self.leftView = view
    }
    
    /// A UIImage value that set RightImage to the UItextfield
    @IBInspectable open var rightImage:UIImage? {
        didSet {
            if (rightImage != nil) {
                self.rightImage(rightImage!)
            }
        }
    }
    
    fileprivate func rightImage(_ image: UIImage) {
        leftPadding()
        
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        imageView.contentMode = .center
        imageView.frame = CGRect(x: 0, y: 0, width: icn.size.width + 20, height: icn.size.height)
        
        self.rightViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        view.addSubview(imageView)
        self.rightView = view
    }
    
    /// Give left padding to UITextField
    fileprivate func leftPadding() {
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.leftView = paddingLeft
        self.leftViewMode = UITextFieldViewMode.always
    }

    /// Give right padding to UITextField
    fileprivate func rightPadding() {
        let paddingRight = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.rightView = paddingRight
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    /// Give padding to UITextField
    fileprivate func padding() {
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.leftView = paddingLeft
        self.leftViewMode = UITextFieldViewMode.always
        
        let paddingRight = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 5))
        self.rightView = paddingRight
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    // MARK: Bottom Line Setup
    @IBInspectable open var lineWant: Bool = false {
        didSet {
            self.setNeedsDisplay()
            self.borderStyle = .none
            self.createLineView()
            self.updateControl()
            self.addEditingChangedObserver()
            self.updateTextAligment()
        }
    }
    
    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(CustomTextField.editingChanged), for: .editingChanged)
    }
    
    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    open func editingChanged() {
        updateControl()
    }
    
    // MARK: Line Color
    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable open var lineColor:UIColor = UIColor.lightGray {
        didSet {
            self.updateLineView()
        }
    }
    
    /// A UIColor value that determines the color of the line in a selected state
    @IBInspectable open var lineSelectedColor:UIColor = UIColor.black {
        didSet {
            self.updateLineView()
        }
    }
    
    // MARK: Line height
    
    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable open var lineHeight:CGFloat = 1.0 {
        didSet {
            self.updateLineView()
            self.setNeedsDisplay()
        }
    }
    
    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable open var lineSelectedHeight:CGFloat = 1.0 {
        didSet {
            self.updateLineView()
            self.setNeedsDisplay()
        }
    }
    
    fileprivate func createLineView() {
        
        if lineWant {
            if self.lineView == nil {
                let lineView = UIView()
                lineView.isUserInteractionEnabled = false
                self.lineView = lineView
                self.configureDefaultLineHeight()
            }
            lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(lineView)
        }
    }
    
    fileprivate func configureDefaultLineHeight() {
        let onePixel:CGFloat = 1.0 / UIScreen.main.scale
        self.lineHeight = 2.0 * onePixel
        self.lineSelectedHeight = 2.0 * self.lineHeight
    }
    
    // MARK: - UITextField text/placeholder positioning overrides
    
    /**
     Calculate the rectangle for the textfield when it is not being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        super.textRect(forBounds: bounds)
//        
//        let lineHeight = self.selectedLineHeight
//        let rect = CGRect(x: 40, y: 0, width: bounds.size.width, height: bounds.size.height - lineHeight)
//        return rect
//    }
    
    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        let lineHeight = self.selectedLineHeight
//        let rect = CGRect(x: 40, y: 0, width: bounds.size.width, height: bounds.size.height - lineHeight)
//        return rect
//    }
    
    /**
     Calculate the bounds for the bottom line of the control. Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    
    open func lineViewRectForBounds(_ bounds:CGRect, editing:Bool) -> CGRect {
        let lineHeight:CGFloat = editing ? CGFloat(self.lineSelectedHeight) : CGFloat(self.lineHeight)
        return CGRect(x: 0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
    }
    
    fileprivate func updateLineView() {
        if lineWant {
            if let lineView = self.lineView {
                lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected)
            }
            self.updateLineColor()
        }
    }
    
    fileprivate func updateLineColor() {
        if lineWant {
            self.lineView.backgroundColor = self.editingOrSelected ? self.lineSelectedColor : self.lineColor
        }
    }
    
    /**
     Calcualte the height of the textfield.
     -returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        return self.font!.lineHeight
    }
    
    // MARK: - Layout
    
    /// Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }
        
        self.borderStyle = .none
        
        self.isSelected = true
        _renderingInInterfaceBuilder = true
        self.updateControl()
        self.invalidateIntrinsicContentSize()
    }
    
    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if lineWant {
            self.lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected || _renderingInInterfaceBuilder)
        }
    }
    
    // MARK: Responder handling
    
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateControl()
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.updateControl()
        return result
    }
    
    // MARK: - View updates
    
    fileprivate func updateControl() {
        if lineWant {
            self.updateLineColor()
            self.updateLineView()
        }
    }
    
    /**
     Calculate the content size for auto layout
     
     - returns: the content size to be used for auto layout
     */
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: self.bounds.size.width, height: self.textHeight())
    }
}

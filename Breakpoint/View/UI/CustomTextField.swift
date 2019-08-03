import UIKit

@IBDesignable
class CustomTextField: UITextField {

    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    @IBInspectable var placeholderColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet
        {
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupPlaceholder()
    }
    
    private func setupPlaceholder(){
        if let placeholderText = placeholder{
            let place = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
            attributedPlaceholder = place
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

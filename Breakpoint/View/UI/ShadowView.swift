import UIKit

@IBDesignable
class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView(){
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
    }
}

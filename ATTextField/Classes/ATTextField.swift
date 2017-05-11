//
//  ATTextField.swift
//  ATTextField
//
//  Created by tikhonov on 3/25/17.
//  Copyright © 2017 tikhonov. All rights reserved.
//

import UIKit

@IBDesignable
open class ATTextField: UITextField {
    
    public private(set) var headLabel: UILabel!
    public private(set) var baseLineLayer: CALayer!
    public private(set) var alertLabel: UILabel!
    
    open var headLabelPadding        = CGPoint(x: 0.0, y: 0.0)
    open var alertLabelPadding       = CGPoint(x: 0.0, y: 0.0)
    open var textFieldAreaPadding    = CGPoint(x: 0.0, y: 0.0)
    open var baseLinePadding         = CGPoint(x: 0.0, y: 0.0)
    
    open var validator: ATValidatoring?
    open var baseLineHeight: CGFloat = 1.0
    
    private var textFieldAreaFrame: CGRect = .zero
    
    private var textLineHeight: CGFloat {
        return font!.lineHeight.rounded(.up)
    }
    
    @IBInspectable var showAlertWhenInvalid: Bool = true {
        didSet {
            updateAlertLabelProperties()
        }
    }
    
    @IBInspectable open var hideAlertWhenDidEndEditingPassValidation: Bool = true
    
    @IBInspectable var hideHeadWhenTextFieldIsEmpty: Bool = false {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    // MARK: - @IBInspectables
    
    @IBInspectable var headText: String? = "Head" {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    @IBInspectable var headColor: UIColor = .black {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    @IBInspectable var headTextAlignment: Int = 0 {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    @IBInspectable var baseColor: UIColor = .black  {
        didSet {
            updateBaseLineProperties()
        }
    }
    
    @IBInspectable var baseCornerRadius: CGFloat = 1.0  {
        didSet {
            updateBaseLineProperties()
        }
    }
    
    @IBInspectable var alertText: String? = "Alert" {
        didSet {
            updateAlertLabelProperties()
        }
    }
    
    @IBInspectable var alertColor: UIColor = .red  {
        didSet {
            updateAlertLabelProperties()
        }
    }
    
    @IBInspectable var alertTextAlignment: Int = 0 {
        didSet {
            updateAlertLabelProperties()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextField()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextField()
    }
    
    private func prepareTextField() {
        addHeadLabel()
        addBaseLineLayer()
        addAlertLabel()
        stylizeTextField()
    }
    
    // MARK: - Overriding
    
    override open func layoutSubviews() {
        updateBounds()
        layoutHeadLabel()
        updateTextFieldAreaFrame()
        layoutBaseLine()
        layoutAlertLabel()
        super.layoutSubviews()
    }
    
    func updateBounds() {
        if let headText = headLabel.text, headText.isEmpty == false {
            headLabel.sizeToFit()
        }
        if let alertText = alertLabel.text, alertText.isEmpty == false {
            alertLabel.sizeToFit()
        }
        
        bounds = CGRect(origin: .zero, size: intrinsicContentSize)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return boundsForTextFieldArea(of: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return boundsForTextFieldArea(of: bounds)
    }
    
    override open var intrinsicContentSize: CGSize {
        let maxWidth = max(headLabel.intrinsicContentSize.width, alertLabel.intrinsicContentSize.width, super.intrinsicContentSize.width)
        let maxXPadding = [headLabelPadding.x, textFieldAreaPadding.x, baseLinePadding.x, alertLabelPadding.x].max()!
        var width = maxWidth + maxXPadding
        
        let headLabelHeight = headLabelPadding.y + headLabel.font.lineHeight.rounded(.up)
        let textFieldAreaHeight = textFieldAreaPadding.y + frameOfTextFieldArea(for: bounds).height
        let baselineHeight = baseLinePadding.y + baseLineHeight
        let alertLabelHeight = alertLabelPadding.y + alertLabel.font.lineHeight.rounded(.up)
        var height = headLabelHeight + textFieldAreaHeight + baselineHeight + alertLabelHeight
        
        width = max(width, 25.0)
        height = max(height, 30.0)
        
        return CGSize(width: width, height: height)
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        if let _ = newSuperview {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        alertLabel.alpha = 1.0
        borderStyle = .none
    }
    
    // MARK: - Layout subviews
    
    private func layoutHeadLabel() {
        let x = headLabelPadding.x
        let y = headLabelPadding.y
        let width = bounds.width - x
        let height = headLabel.font.lineHeight
        headLabel.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func layoutBaseLine() {
        baseLineLayer.frame = frameForNextView(of: textFieldAreaFrame, withHeight: baseLineHeight, withPadding: baseLinePadding)
    }
    
    private func layoutAlertLabel() {
        alertLabel.frame = frameForNextView(of: baseLineLayer.frame, withHeight: alertLabel.font.lineHeight, withPadding: alertLabelPadding)
    }
    
    private func frameForNextView(of previuosFrame: CGRect, withHeight height: CGFloat, withPadding padding: CGPoint) -> CGRect {
        let prevX = previuosFrame.origin.x
        let prevY = previuosFrame.origin.y + previuosFrame.height
        let x = padding.x + prevX
        let y = padding.y + prevY
        let width = bounds.width - x
        return CGRect(x: x, y: y, width: width, height: height )
    }
    
    private func updateTextFieldAreaFrame() {
        textFieldAreaFrame = frameOfTextFieldArea(for: bounds)
    }
    
    private func frameOfTextFieldArea(for bounds: CGRect) -> CGRect {
        guard let headLabel = headLabel else { return .zero }
        let textFieldAreaHeight = textLineHeight
        let newBounds = frameForNextView(of: headLabel.frame, withHeight: textFieldAreaHeight, withPadding: textFieldAreaPadding)
        return newBounds
    }
    
    private func boundsForTextFieldArea(of bounds: CGRect) -> CGRect {
        var newBounds = frameOfTextFieldArea(for: bounds)
        let centerY = (bounds.height / 2.0 - textLineHeight / 2.0).rounded(.up)
        newBounds.origin.y -= centerY
        newBounds.size = bounds.size
        return newBounds
    }
    
    // MARK: - UITextField Observing
    
    @objc private func textFieldDidBeginEditing() {
        guard let text = self.text, text.isEmpty else { return }
        show(view: headLabel, withAnimation: true)
    }
    
    @objc private func textFieldDidEndEditing() {
        if hideHeadWhenTextFieldIsEmpty && (self.text == nil || text!.isEmpty) {
            hide(view: headLabel, withAnimation: true)
        }
        if hideAlertWhenDidEndEditingPassValidation {
            let result = validate(forceExit: true)
            switch result {
            case .valid?:
                hide(view: alertLabel, withAnimation: true)
            default:
                break
            }
        }
    }
    
    // MARK: - Validation
    
    open func validate(forceExit: Bool) -> ATValidatorResult? {
        guard let validator = validator else { return nil}
        return validator.isValid(forceExit: forceExit)
    }
    
    @discardableResult
    open func validate(withAnimation animation: Bool) -> ATValidatorResult?  {
        guard let result = validate(forceExit: true), showAlertWhenInvalid else { return nil }
        switch result {
        case .valid:
            hideAlert(withAnimation: animation)
        case .notValid(let criteria):
            let text = criteria.error?.localizedDescription ?? ""
            showAlert(withText: text, withAnimation: animation)
        case .notValides(let criterias):
            let text = criterias.first?.error?.localizedDescription ?? ""
            showAlert(withText: text, withAnimation: animation)
        }
        return result
    }
    
    // MARK: - Animation
    
    open func showAlert(withText text: String, withAnimation animation: Bool = false) {
        alertText = text
        if animation == false {
            alertLabel.alpha = 1.0
            self.baseLineLayer.backgroundColor = alertLabel.textColor.cgColor
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.alertLabel.alpha = 1.0
            self.baseLineLayer.backgroundColor = self.alertLabel.textColor.cgColor
        }
    }
    
    open func hideAlert(withAnimation animation: Bool = false) {
        if animation == false {
            alertLabel.alpha = 0.0
            self.baseLineLayer.backgroundColor = baseColor.cgColor
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.alertLabel.alpha = 0.0
            self.baseLineLayer.backgroundColor = self.baseColor.cgColor
        }
    }
    
    private func show(view: UIView, withAnimation animation: Bool = false) {
        if animation == false {
            view.alpha = 1.0
            return
        }
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1.0
        }
    }
    
    private func hide(view: UIView, withAnimation animation: Bool = false) {
        if animation == false {
            view.alpha = 0.0
            return
        }
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0.0
        }
    }
    
    // MARK: - Methods
    
    private func addHeadLabel() {
        headLabel = UILabel()
        configureVisibilityHeadLabel()
        addSubview(headLabel)
    }
    
    private func addBaseLineLayer() {
        baseLineLayer = CALayer()
        layer.addSublayer(baseLineLayer)
    }
    
    private func addAlertLabel() {
        alertLabel = UILabel()
        alertLabel.alpha = 0.0
        addSubview(alertLabel)
    }
    
    private func stylizeTextField() {
        borderStyle = .none
    }
    
    private func configureVisibilityHeadLabel() {
        if let text = text {
            if text.isEmpty, hideHeadWhenTextFieldIsEmpty {
                hide(view: headLabel, withAnimation: false)
            } else {
                show(view: headLabel, withAnimation: false)
            }
        } else {
            hide(view: headLabel, withAnimation: false)
        }
    }
    
    // MARK: - @IBInspectable updates
    
    private func updateHeadLabelProperties() {
        headLabel.textColor = headColor
        headLabel.text = headText
        switch headTextAlignment {
        case let textAlignment where 0...2 ~= textAlignment:
            headLabel.textAlignment = NSTextAlignment(rawValue: textAlignment)!
        default:
            break
        }
        if hideHeadWhenTextFieldIsEmpty, hasText == false {
            hide(view: headLabel, withAnimation: false)
        }
        setNeedsLayout()
    }
    
    private func updateBaseLineProperties() {
        baseLineLayer.backgroundColor = baseColor.cgColor
        baseLineLayer.cornerRadius = baseCornerRadius
        setNeedsLayout()
    }
    
    private func updateAlertLabelProperties() {
        alertLabel.textColor = alertColor
        alertLabel.text = alertText
        switch alertTextAlignment {
        case let textAlignment where 0...2 ~= textAlignment:
            alertLabel.textAlignment = NSTextAlignment(rawValue: textAlignment)!
        default:
            break
        }
        if showAlertWhenInvalid, let validate = validate(forceExit: true), validate.boolValue == false {
            show(view: alertLabel, withAnimation: false)
        }
        setNeedsLayout()
    }
}

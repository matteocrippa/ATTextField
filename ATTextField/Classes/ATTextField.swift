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
    
    
    private var headLabelHeight: CGFloat {
        return headLabel.intrinsicContentSize.height
    }
    
    private var textFieldViewHeight: CGFloat {
        return super.intrinsicContentSize.height
    }
    
    private var baselineHeight: CGFloat = 1.0
    
    private var alertLabelHeight: CGFloat {
        return alertLabel.intrinsicContentSize.height
    }
    
    //
    public private(set) var headLabel: UILabel!
    public private(set) var baseLineView: UIView!
    public private(set) var alertLabel: UILabel!
    public private(set) var textFieldView: UIView!
    
    @IBInspectable open var hideHeadWhenTextFieldIsEmpty: Bool = false {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    @IBInspectable open var highlightBaseLineWhenActive: Bool = false  {
        didSet {
            updateBaseLineProperties()
        }
    }
    
    // MARK: - @IBInspectables
    
    @IBInspectable open var headText: String? = "Head" {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    @IBInspectable open var headColor: UIColor = .black {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    @IBInspectable open var baseLineColor: UIColor = .black  {
        didSet {
            updateBaseLineProperties()
        }
    }
    
    @IBInspectable open var highlightedBaseLineColor: UIColor = .blue  {
        didSet {
            updateBaseLineProperties()
        }
    }
    
    @IBInspectable open var alertText: String? = "Alert" {
        didSet {
            updateAlertLabelProperties()
        }
    }
    
    @IBInspectable open var alertColor: UIColor = .red  {
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
        addTextFieldView()
        addBaseLineLayer()
        addAlertLabel()
        stylizeTextField()
    }
    
    // MARK: - Overriding
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textViewRect(forBounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return textViewRect(forBounds: bounds)
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        if let _ = newSuperview {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var width: CGFloat = max(headLabel.intrinsicContentSize.width, alertLabel.intrinsicContentSize.width, super.intrinsicContentSize.width)
        var height: CGFloat = headLabelHeight + textFieldViewHeight + baselineHeight + alertLabelHeight
        width = max(width, 25.0)
        height = max(height, 30.0)
        return CGSize(width: width, height: height)
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        alertLabel.alpha = 1.0
        borderStyle = .none
    }
    
    // MARK: - Methods
    
    private func addHeadLabel() {
        headLabel = UILabel()
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headLabel)
        configureVisibilityHeadLabel()
        
        headLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func addTextFieldView() {
        textFieldView = UIView()
        textFieldView.isUserInteractionEnabled = false
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldView)
        
        textFieldView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textFieldView.topAnchor.constraint(equalTo: headLabel.bottomAnchor).isActive = true
        textFieldView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func addBaseLineLayer() {
        baseLineView = UIView()
        baseLineView.isUserInteractionEnabled = false
        baseLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(baseLineView)
        baseLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        baseLineView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor).isActive = true
        baseLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        baseLineView.heightAnchor.constraint(equalToConstant: baselineHeight).isActive = true
    }
    
    private func addAlertLabel() {
        alertLabel = UILabel()
        alertLabel.alpha = 0.0
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(alertLabel)
        
        alertLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        alertLabel.topAnchor.constraint(equalTo: baseLineView.bottomAnchor).isActive = true
        alertLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        alertLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func stylizeTextField() {
        borderStyle = .none
    }
    
    private func textViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let textFieldView = textFieldView else { return .zero }
        var rect = bounds
        rect.origin.y -= (bounds.height / 2.0) - (textFieldView.frame.origin.y + textFieldView.frame.height / 2.0)
        return rect
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
    
    // MARK: - UITextField Observing
    
    @objc private func textFieldDidBeginEditing() {
        if highlightBaseLineWhenActive {
            highlightBaseLine(highlight: true, withAnimation: true)
        }
        guard let text = self.text, text.isEmpty else { return }
        show(view: headLabel, withAnimation: true)
    }
    
    @objc private func textFieldDidEndEditing() {
        if highlightBaseLineWhenActive {
            highlightBaseLine(highlight: false, withAnimation: true)
        }
        if hideHeadWhenTextFieldIsEmpty && (text == nil || text!.isEmpty) {
            hide(view: headLabel, withAnimation: true)
        }
    }
    
    // MARK: - Animation
    
    open func showAlert(withText text: String, withAnimation animation: Bool = false) {
        alertText = text
        if animation == false {
            alertLabel.alpha = 1.0
            self.baseLineView.backgroundColor = alertLabel.textColor
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.alertLabel.alpha = 1.0
            self.baseLineView.backgroundColor = self.alertLabel.textColor
        }
    }
    
    open func hideAlert(withAnimation animation: Bool = false) {
        if animation == false {
            alertLabel.alpha = 0.0
            self.baseLineView.backgroundColor = baseLineColor
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.alertLabel.alpha = 0.0
            self.baseLineView.backgroundColor = self.baseLineColor
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
    
    private func highlightBaseLine(highlight: Bool, withAnimation animation: Bool = false) {
        let color = highlight ? highlightedBaseLineColor : baseLineColor
        guard color != baseLineView.backgroundColor else { return }
        if animation == false {
            baseLineView.backgroundColor = color
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.baseLineView.backgroundColor = color
        }
    }
    
    // MARK: - @IBInspectable updates
    
    private func updateHeadLabelProperties() {
        headLabel.textColor = headColor
        headLabel.text = headText
    }
    
    private func updateBaseLineProperties() {
        baseLineView.backgroundColor = baseLineColor
    }
    
    private func updateAlertLabelProperties() {
        alertLabel.textColor = alertColor
        alertLabel.text = alertText
    }
}

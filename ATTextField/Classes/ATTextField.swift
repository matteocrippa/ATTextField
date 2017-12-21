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
    
    enum ATState {
        case normal
        case alert
    }
    
    open override var text: String? {
        didSet {
            configureVisibilityHeadLabel()
        }
    }
    
    private var textFieldState: ATState = .normal
    
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
    
    private var isWasFirstResponder: Bool = false
    
    public private(set) var headLabel: UILabel!
    public private(set) var baseLineView: UIView!
    public private(set) var alertLabel: UILabel!
    public private(set) var textFieldView: UIView!
    
    @IBInspectable open var hideHeadWhenTextFieldIsEmpty: Bool = false {
        didSet {
            updateHeadLabelProperties()
        }
    }
    
    open var hideAlertWhenBecomeActive:   Bool = false
    open var hideAlertWhenBecomeInactive: Bool = false
    
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
    
    public var headLabelEdge: UIEdgeInsets = .zero {
        didSet {
            updateHeadLabelConstraints()
        }
    }
    private var headLabelLeadingConstraint: NSLayoutConstraint!
    private var headLabelTopConstraint: NSLayoutConstraint!
    private var headLabelTrailingConstraint: NSLayoutConstraint!
    
    public var textViewEdge: UIEdgeInsets = .zero {
        didSet {
            updateTextViewConstraints()
        }
    }

    private var textViewLeadingConstraint: NSLayoutConstraint!
    private var textViewTopConstraint: NSLayoutConstraint!
    private var textViewTrailingConstraint: NSLayoutConstraint!
    
    public var baseLineEdge: UIEdgeInsets = .zero {
        didSet {
            updateBaselineConstraints()
        }
    }
    private var baselineLeadingConstraint: NSLayoutConstraint!
    private var baselineTopConstraint: NSLayoutConstraint!
    private var baselineTrailingConstraint: NSLayoutConstraint!
    
    public var alertLabelEdge: UIEdgeInsets = .zero {
        didSet {
            updateAlertLabelConstraints()
        }
    }
    private var alertLeadingConstraint: NSLayoutConstraint!
    private var alertTopConstraint: NSLayoutConstraint!
    private var alertTrailingConstraint: NSLayoutConstraint!
    private var alertBottomConstraint: NSLayoutConstraint!
    
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
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var width: CGFloat = max(headLabel.intrinsicContentSize.width, alertLabel.intrinsicContentSize.width, super.intrinsicContentSize.width)
        var height: CGFloat = headLabelHeight + textFieldViewHeight + baselineHeight + alertLabelHeight
        height = height + headLabelEdge.top + textViewEdge.top + baseLineEdge.top + alertLabelEdge.top
        width = max(width, 25.0)
        height = max(height, 30.0)
        return CGSize(width: width, height: height)
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        alertLabel.alpha = 1.0
        borderStyle = .none
    }
    
    open override var isSecureTextEntry: Bool {
        willSet {
            guard #available(iOS 10.0, *) else {
                isWasFirstResponder = isFirstResponder
                resignFirstResponder()
                return
            }
        }
        didSet {
            guard #available(iOS 10.0, *) else {
                if isWasFirstResponder {
                    becomeFirstResponder()
                    isWasFirstResponder = false
                }
                return
            }
        }
    }
    
    // MARK: - Methods
    
    private func updateHeadLabelConstraints() {
        headLabelLeadingConstraint.constant = headLabelEdge.left
        headLabelTopConstraint.constant = headLabelEdge.top
        headLabelTrailingConstraint.constant = headLabelEdge.right
        setNeedsLayout()
    }
    
    private func addHeadLabel() {
        headLabel = UILabel()
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headLabel)
        
        headLabelLeadingConstraint = headLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: headLabelEdge.left)
        headLabelTopConstraint = headLabel.topAnchor.constraint(equalTo: topAnchor, constant: headLabelEdge.top)
        headLabelTrailingConstraint = trailingAnchor.constraint(equalTo: headLabel.trailingAnchor, constant: headLabelEdge.right)
        NSLayoutConstraint.activate([headLabelLeadingConstraint, headLabelTopConstraint, headLabelTrailingConstraint])
    }
    
    private func updateTextViewConstraints() {
        textViewLeadingConstraint.constant = textViewEdge.left
        textViewTopConstraint.constant = textViewEdge.top
        textViewTrailingConstraint.constant = textViewEdge.right
        setNeedsLayout()
    }
    
    private func addTextFieldView() {
        textFieldView = UIView()
        textFieldView.isUserInteractionEnabled = false
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldView)
        
        textViewLeadingConstraint = textFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textViewEdge.left)
        textViewTopConstraint = textFieldView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: textViewEdge.top)
        textViewTrailingConstraint = trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: textViewEdge.right)
        
        NSLayoutConstraint.activate([textViewLeadingConstraint, textViewTopConstraint, textViewTrailingConstraint])
    }
    
    private func updateBaselineConstraints() {
        baselineLeadingConstraint.constant = baseLineEdge.left
        baselineTopConstraint.constant = baseLineEdge.top
        baselineTrailingConstraint.constant = baseLineEdge.right
        setNeedsLayout()
    }
    
    private func addBaseLineLayer() {
        baseLineView = UIView()
        baseLineView.isUserInteractionEnabled = false
        baseLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(baseLineView)
        baselineLeadingConstraint = baseLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: baseLineEdge.left)
        baselineTopConstraint = baseLineView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: baseLineEdge.top)
        baselineTrailingConstraint = trailingAnchor.constraint(equalTo: baseLineView.trailingAnchor, constant: baseLineEdge.right)
        let baselineHeightContraint = baseLineView.heightAnchor.constraint(equalToConstant: baselineHeight)
        NSLayoutConstraint.activate([baselineLeadingConstraint, baselineTopConstraint, baselineTrailingConstraint, baselineHeightContraint])
    }
    
    private func updateAlertLabelConstraints() {
        alertLeadingConstraint.constant = alertLabelEdge.left
        alertTopConstraint.constant = alertLabelEdge.top
        alertTrailingConstraint.constant = alertLabelEdge.right
        alertBottomConstraint.constant = alertLabelEdge.right
        setNeedsLayout()
    }
    
    private func addAlertLabel() {
        alertLabel = UILabel()
        alertLabel.alpha = 0.0
        
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(alertLabel)
        
        alertLeadingConstraint = alertLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: alertLabelEdge.left)
        alertTopConstraint = alertLabel.topAnchor.constraint(equalTo: baseLineView.bottomAnchor, constant: alertLabelEdge.top)
        alertTrailingConstraint = trailingAnchor.constraint(equalTo: alertLabel.trailingAnchor, constant: alertLabelEdge.right)
        alertBottomConstraint = alertLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: alertLabelEdge.bottom)
        NSLayoutConstraint.activate([alertLeadingConstraint, alertTopConstraint, alertTrailingConstraint, alertBottomConstraint])
    }
    
    private func stylizeTextField() {
        borderStyle = .none
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.y -= (bounds.height / 2.0) - (textFieldView.frame.origin.y + textFieldView.frame.height / 2.0)
        return rect
    }
    
    private func textViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let textFieldView = textFieldView else { return super.textRect(forBounds: bounds) }
        var rect = bounds
        
        rect.origin.y -= (bounds.height / 2.0) - (textFieldView.frame.origin.y + textFieldView.frame.height / 2.0)
        rect.origin.x = textViewEdge.left
        rect.size.width -= (textViewEdge.right + textViewEdge.left)
        
        if let rightViewFrame = rightView?.frame {
            rect.size.width -= rightViewFrame.size.width
        }
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
    
    @objc private func textFieldDidChange() { }
    
    @objc private func textFieldDidBeginEditing() {
        switch textFieldState {
        case .normal where highlightBaseLineWhenActive:
            highlightBaseLine(highlight: true, withAnimation: true)
        case .alert where hideAlertWhenBecomeActive:
            hideAlert(withHighlight: highlightBaseLineWhenActive, withAnimation: true)
            textFieldState = .normal
        default:
            break
        }
        guard let text = self.text, text.isEmpty else { return }
        show(view: headLabel, withAnimation: true)
    }
    
    @objc private func textFieldDidEndEditing() {
        switch textFieldState {
        case .normal where highlightBaseLineWhenActive:
            highlightBaseLine(highlight: false, withAnimation: true)
        case .alert where hideAlertWhenBecomeInactive:
            hideAlert(withHighlight: false, withAnimation: true)
            textFieldState = .normal
        default:
            break
        }
        guard hideHeadWhenTextFieldIsEmpty, let text = self.text, text.isEmpty else { return }
        hide(view: headLabel, withAnimation: true)
    }
    
    // MARK: - Animation
    
    open func showAlert(withText text: String, withHighlight highlight: Bool = false,  withAnimation animation: Bool = false) {
        let baseLineColor = highlight ? highlightedBaseLineColor : alertLabel.textColor
        alertText = text
        textFieldState = .alert
        if animation == false {
            alertLabel.alpha = 1.0
            self.baseLineView.backgroundColor = baseLineColor
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.alertLabel.alpha = 1.0
            self.baseLineView.backgroundColor = baseLineColor
        }
    }
    
    open func hideAlert(withHighlight highlight: Bool = false, withAnimation animation: Bool = false) {
        let baseLineColor = highlight ? highlightedBaseLineColor : self.baseLineColor
        textFieldState = .normal
        if animation == false {
            alertLabel.alpha = 0.0
            self.baseLineView.backgroundColor = baseLineColor
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.alertLabel.alpha = 0.0
            self.baseLineView.backgroundColor = baseLineColor
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
    
    private func updateBaseLineProperties() {
        let color = highlightBaseLineWhenActive && isEditing ? highlightedBaseLineColor : baseLineColor
        baseLineView.backgroundColor = color
    }
    
    private func updateAlertLabelProperties() {
        alertLabel.textColor = alertColor
        alertLabel.text = alertText
    }
}

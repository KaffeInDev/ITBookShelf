//
//  LoadingView.swift
//  iTunesSearch
//
//  Created by JunKyung.Park on 2020/06/27.
//  Copyright © 2020 CoffeDev. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    // MARK: - Private Property
    private lazy var didUpdateConstraints: Bool = false
    
    typealias LoadingHandler = () -> Void
    private var onLoadHandler: LoadingHandler?
    
    // MARK: - Subviews Property
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .systemGray
        return activityView
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
        
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addSubviews() {
        addSubview(containerView)
        addSubview(activityView)
    }
    
    var activityIndicatorStyle: UIActivityIndicatorView.Style = .large {
        didSet {
            if activityIndicatorStyle != oldValue {
                activityView.style = activityIndicatorStyle
            }
        }
    }
    
    func setActivityColor(_ color: UIColor) {
        activityView.color = color
    }
    
    func startLoading() {
        activityView.startAnimating()
        containerView.isHidden = true
    }
    
    func endLoading(completion: LoadingHandler?) {
        DispatchQueue.main.safeAsync { [weak self] in
            self?.activityView.stopAnimating()
        }
        UIView.animate(withDuration: 0.25,
                       animations: { [weak self] in
                        self?.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.isHidden = true
                self?.removeFromSuperview()
                completion?()
        })
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            func applyConstratint(_ view: UIView) {
                guard let superView = view.superview else { return }
                view.translatesAutoresizingMaskIntoConstraints = false
                view.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
                view.heightAnchor.constraint(equalTo: superView.heightAnchor).isActive = true
            }
            
            applyConstratint(containerView)
            applyConstratint(activityView)
        }
        
        super.updateConstraints()
    }
}

extension UIView {
    private struct AssociatedKeys {
        static var loadingView: String = "LoadingView"
    }
    
    private var loadingView: LoadingView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingView) as? LoadingView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func startLoading(_ backgroundColor: UIColor = .white, targetView: UIView? = nil) {
        removeLoadingView()
        
        let parentView: UIView = targetView ?? self
        
        loadingView = LoadingView()
        loadingView?.backgroundColor = backgroundColor

        if let loadingView = loadingView {
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(loadingView)
            loadingView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
            loadingView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
            loadingView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
            loadingView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        }
        
        loadingView?.startLoading()
    }
    
    func endLoading(_ handler: LoadingView.LoadingHandler? = nil) {
        loadingView?.endLoading(completion: { [weak self] in
            self?.removeLoadingView()
            handler?()
        })
    }
    
    // MARK: - Private
    private func removeLoadingView() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}

extension UIViewController {
    func startLoading(_ backgroundColor: UIColor = .white, targetView: UIView? = nil) {
        let parentView: UIView = targetView ?? self.view
        view.startLoading(backgroundColor, targetView: parentView)
    }
    
    func endLoading(_ handler: LoadingView.LoadingHandler? = nil) {
        view.endLoading(handler)
    }
}

//
//  RefreshFooterView.swift
//  shen
//
//  Created by 沈凯强 on 2021/01/01.
//  Copyright © 2021 mn. All rights reserved.
//

import UIKit

class SKRefreshFooterView: SKRefreshFooter {
    
    private let refreshLabelHeight:CGFloat = 25
    private var titleLabel:UILabel! //提示标题
    private var imageView:UIImageView! //下拉箭头
    private var activityView:UIActivityIndicatorView! //刷新时的活动指示器
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: bounds.width, height: refreshLabelHeight))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        // 上拉下拉图片
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: titleLabel.frame.minY, width: refreshLabelHeight, height: refreshLabelHeight))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "SKRefreshImages.bundle/arrow")
        addSubview(imageView)
        imageView.isHidden = true
        // 旋转的菊花
        activityView = UIActivityIndicatorView.init(frame: imageView.frame)
        activityView.style = .gray
        activityView.hidesWhenStopped = true  // default is true.
        addSubview(activityView)
        
        imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        
        // 修改 imageView 的位置
        updateImageViewX(by: SKRefreshFooter.RefreshState.normal.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 根据提示文字的宽度 修改 imageView 的位置
    private func updateImageViewX(by title:String){
        let dic:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        let titleSize = title.boundingRect(with: CGSize.init(width: 1000, height: refreshLabelHeight), options: .usesFontLeading, attributes: dic, context: nil)
        let imgHeight = refreshLabelHeight
        let oriX:CGFloat = bounds.width/2 - titleSize.width/2 - imgHeight
        imageView.frame.origin.x = oriX
        activityView.frame.origin.x = oriX
    }
    
    override func refreshStateChanged(refreshState: SKRefreshFooter.RefreshState) {
        var imgVisHidden = false
        var imgVTransform = CGAffineTransform.identity // 箭头图标的旋转方向
        weak var weakself = self
        switch refreshState {
        case .normal:
            //旋转箭头图标朝下
            imgVTransform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        case .willRefresh:
            break
        case .refreshing:
            imgVisHidden = true
            activityView.startAnimating()
        case .refreshed:
            activityView.stopAnimating()
        case .noMore:
            imgVisHidden = true
        }
        titleLabel.text = refreshState.rawValue
        // 修改 imageView 的位置
        updateImageViewX(by: refreshState.rawValue)
        imageView.isHidden = imgVisHidden
        
        UIView.animate(withDuration: SKRefreshConstant.animateDur, animations: {
            weakself?.imageView.transform = imgVTransform
        })
    }
}



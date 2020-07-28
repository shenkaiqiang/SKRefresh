//
//  SKRefreshHeaderView.swift
//  shen
//
//  Created by 沈凯强 on 2021/01/01.
//  Copyright © 2021 mn. All rights reserved.
//

import UIKit

class SKRefreshHeaderView: SKRefreshHeader {
    
    /// 上次下拉刷新的时间字符串
    private let lastTimeText:String = "上次刷新 : "
    private let lastTimeKey:String = "\(String(describing: self.self))"
    
    private let refreshLabelHeight:CGFloat = 25
    private var timeLabel:UILabel! //刷新时间
    private var titleLabel:UILabel! //提示标题
    private var imageView:UIImageView! //下拉箭头
    private var activityView:UIActivityIndicatorView! //刷新时的活动指示器
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: refreshLabelHeight))
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
        // 旋转的菊花
        activityView = UIActivityIndicatorView.init(frame: imageView.frame)
        activityView.style = .gray
        activityView.hidesWhenStopped = true  // default is true.
        addSubview(activityView)
        
        // 记录上次下拉刷新时间的 label
        timeLabel = UILabel.init(frame: CGRect.init(x: 0, y: titleLabel.frame.maxY, width: bounds.width, height: refreshLabelHeight))
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.gray
        let timeStr = UserDefaults.standard.string(forKey: lastTimeKey) ?? ""
        timeLabel.text = timeStr.isEmpty ? "最近未刷新" : "\(lastTimeText)\(timeStr)"
        addSubview(timeLabel)
        
        updateImageViewX(by: SKRefreshHeader.RefreshState.normal.rawValue)
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
    
    override func refreshStateChanged(refreshState: SKRefreshHeader.RefreshState) {
        var imgVisHidden = false
        var imgVTransform = CGAffineTransform.identity // 箭头图标的旋转方向
        weak var weakself = self
        switch refreshState {
        case .normal:
            break
        case .willRefresh:
            //旋转箭头图标朝上
            imgVTransform = CGAffineTransform.init(rotationAngle: (CGFloat.pi - 0.0001))
        case .refreshing:
            imgVisHidden = true
            activityView.startAnimating()
            //保存刷新的时间
            let dateStr = updateAndSaveRefreshTime()
            timeLabel.text = "\(lastTimeText)\(dateStr)"
        case .refreshed:
            activityView.stopAnimating()
        }
        titleLabel.text =  refreshState.rawValue
        updateImageViewX(by: refreshState.rawValue)
        imageView.isHidden = imgVisHidden
        
        UIView.animate(withDuration: SKRefreshConstant.animateDur, animations: {
            weakself?.imageView.transform = imgVTransform
        })
    }
    
    /// 保存刷新的时间
    private func updateAndSaveRefreshTime() -> String {
        //实例化一个NSDateFormatter对象
        let dateFor = DateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFor.dateFormat = "MM-dd HH:mm:ss"
        let currentDateStr = dateFor.string(from: Date.init(timeIntervalSinceNow: 0))
        // 保存最后一次刷新时间
        UserDefaults.standard.set(currentDateStr, forKey: lastTimeKey)
        UserDefaults.standard.synchronize()
        return currentDateStr
    }
}




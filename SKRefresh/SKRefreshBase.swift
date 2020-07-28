//
//  SKRefreshBase.swift
//  shen
//
//  Created by 沈凯强 on 2021/01/01.
//  Copyright © 2021 mn. All rights reserved.
//

import UIKit

class SKRefreshBase: UIView {
    private let observerKey_contentOffset = "contentOffset"
    private let observerKey_contentSize = "contentSize"
    /// 父视图（表格scrollView）
    private var superScrollView:UIScrollView?
    
    // 将要显示在父视图时调用，此时添加KVO监听表格偏移量
    override func willMove(toSuperview newSuperview: UIView?) {
        guard newSuperview is UIScrollView else {
            return
        }
        //记录父视图
        superScrollView = newSuperview as? UIScrollView
        //添加KVO监听父视图的偏移量
        newSuperview?.addObserver(self, forKeyPath: observerKey_contentOffset, options: .new, context: nil)
        newSuperview?.addObserver(self, forKeyPath: observerKey_contentSize, options: .new, context: nil)
    }
    
    // 移除 KVO
    deinit {
        removeObserver()
    }
    
    override func removeFromSuperview() {
        removeObserver()
        super.removeFromSuperview()
    }
    
    private func removeObserver() {
        // 如果之前没有进行添加,就移除的话会系统崩溃
        if superScrollView != nil {
            superScrollView?.removeObserver(self, forKeyPath: observerKey_contentOffset)
            superScrollView?.removeObserver(self, forKeyPath: observerKey_contentSize)
        }
    }
    // 要根据表格的滑动距离，判断并更新头，尾部刷新的状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let superScrollView = superScrollView else {
            return
        }
        var top:CGFloat = 0
        var bottom:CGFloat = 0
        top = superScrollView.adjustedContentInset.top
        bottom = superScrollView.adjustedContentInset.bottom
        if keyPath == observerKey_contentOffset {
            guard let newOffset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else {
                return
            }
            var offsetY = newOffset.y + top
            // 判断是否是手动滑动
            guard offsetY != 0 else {
                return
            }
            // header,下拉
            scrollViewContentOffsetDidChangedInHeader(scrollView: superScrollView, offsetY: offsetY)
            // footer, 上拉
            if superScrollView.contentSize.height > (superScrollView.bounds.height-top-bottom) {
                let diff = superScrollView.contentSize.height - (superScrollView.bounds.height-top-bottom)
                offsetY = offsetY - diff
            }
            scrollViewContentOffsetDidChangedInFooter(scrollView: superScrollView, offsetY: offsetY)
        } else if keyPath == observerKey_contentSize {
            guard let newContentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize else {
                return
            }
            let height = newContentSize.height
            var newY = superScrollView.bounds.height-top
            if height > (superScrollView.bounds.height-top-bottom) {
                // 如果内容高度超出视图高度
                newY = height
            }
            refreshFooterOrigin(scrollView: superScrollView, newOriginY: newY)
        }
    }
    
    /// 下拉刷新,偏移量改变
    func scrollViewContentOffsetDidChangedInHeader(scrollView:UIScrollView, offsetY:CGFloat) {
        
    }
    /// 上拉加载,偏移量改变
    func scrollViewContentOffsetDidChangedInFooter(scrollView:UIScrollView, offsetY:CGFloat) {
        
    }
    /// 尾部刷新状态,更新自己的位置，让自己始终显示在表格的最下面
    func refreshFooterOrigin(scrollView:UIScrollView, newOriginY:CGFloat) {
        
    }
    /// 显示头部刷新视图
    func showHeaderView() {
        if let top = superScrollView?.contentInset.top {
            superScrollView?.contentInset.top = top + SKRefreshConstant.headerHeight
        }
    }
    /// 隐藏头部刷新视图
    func hiddenHeaderView() {
        weak var weakself = self
        UIView.animate(withDuration: SKRefreshConstant.animateDur) {
            if let top = weakself?.superScrollView?.contentInset.top {
                weakself?.superScrollView?.contentInset.top = top - SKRefreshConstant.headerHeight
            }
        }
    }
    /// 显示尾部刷新视图
    func showFooterView() {
        if let bottom = superScrollView?.contentInset.bottom {
            superScrollView?.contentInset.bottom = bottom + SKRefreshConstant.footerHeight
        }
    }
    /// 隐藏尾部刷新视图
    func hiddenFooterView() {
        weak var weakself = self
        UIView.animate(withDuration: SKRefreshConstant.animateDur) {
            if let bottom = weakself?.superScrollView?.contentInset.bottom {
                weakself?.superScrollView?.contentInset.bottom = bottom - SKRefreshConstant.footerHeight
            }
        }
    }
}

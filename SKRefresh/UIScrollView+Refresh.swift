//
//  UIScrollView+Refresh.swift
//  shen
//
//  Created by 沈凯强 on 2021/01/01.
//  Copyright © 2021 mn. All rights reserved.
//

import UIKit

extension UIScrollView {
    // 正常情况下, extension 中不能定义属性,
    private struct Refresh {
        static var headerTag = 102410241
        static var footerTag = 102410242
    }
    /// 添加头部下拉刷新重新请求数据
    @discardableResult public func sk_addHeaderRefresh(headerRefresh headerClosure:@escaping () -> Void) -> UIScrollView {
        // 防止重复添加
        if (viewWithTag(Refresh.headerTag) as? SKRefreshHeaderView) != nil{
            return self
        }
        //添加头部刷新
        let header = SKRefreshHeaderView.init(frame: CGRect.init(x: 0, y: -SKRefreshConstant.headerHeight, width: bounds.width, height: SKRefreshConstant.headerHeight))
        header.headerBlock = headerClosure
        addSubview(header)
        header.tag = Refresh.headerTag
        return self
    }
    /// 添加尾部上拉加载更多数据
    public func sk_addFooterRefresh(footerRefresh footerClosure:@escaping () -> Void) {
        // 防止重复添加
        if (viewWithTag(Refresh.footerTag) as? SKRefreshFooterView) != nil{
            return
        }
        //添加尾部刷新
        let footer = SKRefreshFooterView.init(frame: CGRect.init(x: 0, y: frame.height, width: bounds.size.width, height: SKRefreshConstant.footerHeight))
        footer.footerBlock = footerClosure
        addSubview(footer)
        footer.tag = Refresh.footerTag
    }
    
    private func getHeaderView() -> SKRefreshHeaderView? {
        return viewWithTag(Refresh.headerTag) as? SKRefreshHeaderView
    }
    private func getFooterView() -> SKRefreshFooterView? {
        return viewWithTag(Refresh.footerTag) as? SKRefreshFooterView
    }
    /// 开始头部刷新
    public func sk_beginHeaderRefresh() {
        let header = getHeaderView()
        header?.beginRefresh()
    }
    /// 停止头部刷新
    public func sk_endHeaderRefresh() {
        let header = getHeaderView()
        header?.endRefresh()
    }
    
    /// 开始尾部刷新
    public func sk_beginFooterRefresh() {
        let footer = getFooterView()
        footer?.beginRefresh()
    }
    /// 停止尾部刷新
    public func sk_endFooterRefresh() {
        let footer = getFooterView()
        footer?.endRefresh()
    }
    /// 没有更多数据
    public func noMoreData(noMore:Bool) {
        let footer = getFooterView()
        footer?.noMoreData(noMore: noMore)
    }
}

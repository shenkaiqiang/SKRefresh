//
//  SKRefreshFooter.swift
//  shen
//
//  Created by 沈凯强 on 2021/01/01.
//  Copyright © 2021 mn. All rights reserved.
//

import UIKit

class SKRefreshFooter: SKRefreshBase {
    
    /// 刷新的各个状态
    enum RefreshState:String {
        ///普通状态(nomal state)
        case normal = "上拉即可加载更多"
        ///将要刷新(will refresh state)
        case willRefresh = "松开立即加载更多"
        ///正在刷新(refreshing state)
        case refreshing = "正在加载更多数据"
        ///刷新完成(refreshed state)
        case refreshed = "加载完成"
        ///没有更多(no more state)
        case noMore = "没有更多数据"
    }
    
    var footerBlock:(()->Void)?
    
    // 记录底部刷新状态,set方法,当状态发生改变时，调用
    private var footerState:RefreshState = .normal{
        didSet{
            refreshStateChanged(refreshState: footerState)
            guard footerState != .noMore else {
                return
            }
            switch footerState {
            case .normal:
                break
            case .willRefresh:
                break
            case .refreshing:
                showFooterView()
                // 开始刷新
                footerBlock?()
            case .refreshed:
                hiddenFooterView()
            case .noMore:
                break
            }
        }
    }
    
    func refreshStateChanged(refreshState:RefreshState) {
        
    }
    
    // 尾部刷新状态,更新自己的位置，让自己始终显示在表格的最下面
    override func refreshFooterOrigin(scrollView: UIScrollView, newOriginY: CGFloat) {
        frame.origin.y = newOriginY
    }
//    (offsetY-(superScrollView.contentSize.height-superScrollView.bounds.height + bottom))
    override func scrollViewContentOffsetDidChangedInFooter(scrollView: UIScrollView, offsetY: CGFloat) {
        //当未获取到父视图的大小时，不更新底部状态，直接返回
        if scrollView.contentSize.height == 0 {
            return
        }
        // 父视图偏移量,下拉,返回
        if offsetY <= 0{
            return
        }
        // 当前是正在刷新状态,返回
        if footerState == .refreshing {
            return
        }
        // 没有更多数据,直接返回
        if footerState == .noMore {
            return
        }
        //定义新的底部刷新状态（待会要判断状态是否发生改变，没改变就不用更新）
        var newState = footerState
        // 判断是否到达临界值,
        if offsetY < SKRefreshConstant.footerHeight {
            //小余临界值，正常状态
            newState = .normal
        } else {
            if scrollView.isDragging {
                //手指未松开，保持准备刷新状态
                newState = .willRefresh
            } else {
                //手指松开，立即进入开始刷新状态
                newState = .refreshing
            }
        }
        
        // 如果刷新状态发生了改变就更新
        if footerState != newState {
            footerState = newState
        }
    }
    /// 开始刷新
    func beginRefresh() {
        if footerState != .refreshing {
            footerState = .refreshing
        }
    }
    /// 结束刷新
    func endRefresh() {
        if footerState == .refreshing {
            footerState = .refreshed
        }
    }
    /// 没有更多数据
    func noMoreData(noMore:Bool) {
        if noMore {
            footerState = .noMore
        } else {
            footerState = .normal
        }
    }
}

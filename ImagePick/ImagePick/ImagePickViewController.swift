//
//  ImagePickViewController.swift
//  ImagePick
//
//  Created by Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

import UIKit
import SnapKit

class ImagePickViewController: UIViewController {

    public var imagePickBackgroundColor = UIColor.black
    
    private lazy var backScrollView: UIScrollView = {
        let backScrollView = UIScrollView(frame: .zero)
        backScrollView.bounces = false
        backScrollView.showsVerticalScrollIndicator = false
        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.isScrollEnabled = false
        backScrollView.isPagingEnabled = true
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin).offset(-50)
        })
        return backScrollView
    }()
    
    private var albumButton: UIButton = UIButton(frame: .zero)
    private var cameraButton: UIButton = UIButton(frame: .zero)
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = imagePickBackgroundColor
        view.addSubview(bottomView)
        
        albumButton.setTitle("相册", for: .normal)
        albumButton.setTitleColor(UIColor.white, for: .selected)
        albumButton.setTitleColor(UIColor.gray, for: .normal)
        albumButton.tag = 1
        albumButton.addTarget(self, action: #selector(bottomClick(_:)), for: .touchUpInside)
        albumButton.isSelected = true

        cameraButton.setTitle("拍照", for: .normal)
        cameraButton.setTitleColor(UIColor.white, for: .selected)
        cameraButton.setTitleColor(UIColor.gray, for: .normal)
        cameraButton.tag = 2
        cameraButton.addTarget(self, action: #selector(bottomClick(_:)), for: .touchUpInside)
        bottomView.addSubview(albumButton)
        bottomView.addSubview(cameraButton)
        
        bottomView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(backScrollView.snp.bottom)
        })
        albumButton.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(bottomView.snp.centerX)
        })
        cameraButton.snp.makeConstraints({ (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(bottomView.snp.centerX)
        })
        return UIView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    func setUpUI() {
        view.backgroundColor = imagePickBackgroundColor
        
        backScrollView.contentSize = CGSize(width: view.width * 2, height: 0)
        backScrollView.layoutIfNeeded()
        let albumVc = AlbumViewController()
        let cameraVc = CameraViewController()
        albumVc.view.frame = CGRect(origin: .zero, size: backScrollView.size)
        cameraVc.view.frame = CGRect(x: backScrollView.width, y: 0, width: backScrollView.width, height: backScrollView.height)
        addChildViewController(albumVc)
        addChildViewController(cameraVc)
        backScrollView.addSubview(albumVc.view)
        backScrollView.addSubview(cameraVc.view)
        
        bottomView.isHidden = false
    }
    
    @objc func bottomClick(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if backScrollView.contentOffset.x == backScrollView.width {
                sender.isSelected = true
                cameraButton.isSelected = false
                backScrollView.setContentOffset(CGPoint.zero, animated: true)
            }
            break
        case 2:
            if backScrollView.contentOffset.x == 0 {
                sender.isSelected = true
                albumButton.isSelected = false
                backScrollView.setContentOffset(CGPoint(x: backScrollView.width, y: 0), animated: true)
            }
        default:
            break
        }
    }
}











//
//  AlbumViewController.swift
//  ImagePick
//
//  Created by Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

import UIKit
import Photos


class AlbumViewController: UIViewController {
    
    
    private let cellId = "AlbumFinderTableViewCell"
    lazy var photoTableView: UITableView = {
        let photoTableView = UITableView(frame: CGRect(x: 0, y: NavigationBarHeight, width: SCREEN_WIDTH, height:SCREEN_HEIGHT - NavigationBarHeight))
        photoTableView.backgroundColor = UIColor.black
        photoTableView.showsVerticalScrollIndicator = false
        photoTableView.showsHorizontalScrollIndicator = false
        photoTableView.separatorStyle = .none
        photoTableView.delegate = self
        photoTableView.dataSource = self
        photoTableView.rowHeight = 100.0
        photoTableView.tableFooterView = UIView()
        photoTableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        UIApplication.shared.keyWindow?.addSubview(photoTableView)
        return photoTableView
    }()
    
    var collectionArrr: PHFetchResult<PHCollection>?
    var assetsFetchResults: PHFetchResult<PHAsset>?
    var imageManager: PHImageManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            guard let `self` = self else {return}
            switch status {
            case .authorized:
                self.imageManager = PHImageManager.default()
                //总相册
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                let totalResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//                print(totalResult)
//
//                for i in 0 ..< totalResult.count {
//                    print(totalResult[i].localIdentifier)
//                    print(totalResult[i].localizedTitle ?? "")
//                    if totalResult[i].localizedTitle == "Camera Roll" {
//                        let assets = PHAsset.fetchAssets(in: totalResult[i], options: nil)
//                        print(assets)
//                    }
//                }
                
                self.assetsFetchResults = PHAsset.fetchAssets(with: options)
                
                let result = PHCollectionList.fetchTopLevelUserCollections(with: nil)
                self.collectionArrr = result
                print(result)
                DispatchQueue.main.async {
                    
                    self.photoTableView.reloadData()
                }
            default:
                break
            }
        }
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionArrr?.count ?? 0 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AlbumFinderTableViewCell
        cell?.selectionStyle = .none
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isSynchronous = true
        options.normalizedCropRect = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        if indexPath.row == 0 {
            
            imageManager?.requestImage(for: assetsFetchResults![0], targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                print(info ?? "")
                cell?.converImageV.image = image
            })
            cell?.titleLabel.text = "全部照片"
            cell?.photoNumLabel.text = "\(assetsFetchResults?.count ?? 0) photos"
        } else {
            guard let assetCollection = collectionArrr![indexPath.row - 1] as? PHAssetCollection  else {return UITableViewCell()}
            let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
            cell?.titleLabel.text = assetCollection.localizedTitle
            cell?.photoNumLabel.text = "\(assetCollection.estimatedAssetCount) photos"
            if assets.count > 0 {
                imageManager?.requestImage(for: assets.lastObject!, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    print(info ?? "")
                    cell?.converImageV.image = image
                })
            } else {
              cell?.converImageV.image = UIImage()
            }
        }
        return cell ?? UITableViewCell()
    }
    
    
}

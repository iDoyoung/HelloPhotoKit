//
//  ViewController.swift
//  HelloPhotoKit
//
//  Created by Doyoung on 2021/11/12.
//

import UIKit
import Photos

class ViewController: UIViewController {

    var photos: PHFetchResult<PHAsset>?
    let imageManager = PHImageManager()
    let scale = UIScreen.main.scale
    lazy var imageSize = CGSize(width: 1024 * self.scale, height: 1024 * self.scale)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        accessPhotos()
    }

    func accessPhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                self?.photos = PHAsset.fetchAssets(with: nil)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func datePicker(_ sender: Any) {
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        
        let asset = photos?[indexPath.item]
        cell.representedAssetIdentifier = asset?.localIdentifier
        imageManager.requestImage(for: asset!, targetSize: imageSize, contentMode: .default, options: nil) { image, _ in
            if cell.representedAssetIdentifier == asset?.localIdentifier {
                cell.image.image = image
            }
        }
        return cell
    }
}

class Cell: UICollectionViewCell {
    var representedAssetIdentifier: String?
    @IBOutlet weak var image: UIImageView!
}

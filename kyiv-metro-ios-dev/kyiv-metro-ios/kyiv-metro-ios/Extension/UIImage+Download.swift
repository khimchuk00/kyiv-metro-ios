

import UIKit
import Kingfisher

extension UIImageView {
    func downloadAndSetImage(url: URL?, placeholder: UIImage? = nil) {
        let processor = DownsamplingImageProcessor(size: frame.size)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
}

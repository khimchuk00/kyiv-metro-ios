
import UIKit

@IBDesignable
final class ImageScrollView: UIScrollView {
    
    private var imageView = UIImageView()
    
    override var frame: CGRect {
        didSet {
            if frame.size != oldValue.size { setZoomScale() }
        }
    }
    
    @IBInspectable var image: UIImage! {
        didSet {
            imageView.removeFromSuperview()
            imageView = UIImageView()
            imageView.image = image
            imageView.sizeToFit()
            addSubview(imageView)
            contentSize = imageView.bounds.size
            setZoomScale()
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        delegate = self
    }
    
    // MARK: - Helper methods
    func setZoomScale() {
        let widthScale = frame.size.width / imageView.bounds.width
        let heightScale = frame.size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
    }
    
}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
}

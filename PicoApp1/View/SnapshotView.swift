import SwiftUI

struct SnapshotView: UIViewRepresentable {
    var contentView: UIView

    // Create the UIView for SwiftUI
    func makeUIView(context: Context) -> UIView {
        return contentView
    }

    // Update the view (no need to update here, as we only want to render once)
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed, we will capture the snapshot only when requested
    }

    // Capture the view as a UIImage
    func captureImage() -> UIImage? {
        // Ensure the contentView has a valid size
        guard contentView.bounds.size.width > 0, contentView.bounds.size.height > 0 else {
            print("Error: contentView has an invalid size.")
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: contentView.bounds.size)
        
        // Capture the content of the view as an image
        return renderer.image { ctx in
            // Render the view's layer into the context
            contentView.layer.render(in: ctx.cgContext)
        }
    }
}

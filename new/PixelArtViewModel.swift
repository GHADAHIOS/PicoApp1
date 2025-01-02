
import SwiftUI
import SwiftData

class PixelArtViewModel: UIView {
    var pixelArt: PixelArt
    var selectedColor: UIColor
    var selectedNumber: Int?
    var cellColors: [[UIColor?]] // Stores the selected color for each cell
    var onColorChanged: (() -> Void)? // Closure to notify color changes
    var modelContext: ModelContext // Store the model context
    var colorMapping: [Int: UIColor] // Color mapping for voice command numbers

    init(frame: CGRect, pixelArt: PixelArt, selectedColor: UIColor, modelContext: ModelContext, colorMapping: [Int: UIColor]) {
        self.pixelArt = pixelArt
        self.selectedColor = selectedColor
        self.cellColors = Array(repeating: Array(repeating: nil, count: pixelArt.width), count: pixelArt.height)
        self.modelContext = modelContext
        self.colorMapping = colorMapping
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func savePixelArtToDatabase(pixelArt: PixelArt) {
        do {
            modelContext.insert(pixelArt)
            try modelContext.save()
            print("Pixel art updated successfully!")
        } catch {
            print("Error saving updated pixel art: \(error)")
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let pixelWidth = rect.width / CGFloat(pixelArt.width)
        let pixelHeight = rect.height / CGFloat(pixelArt.height)

        for row in 0..<pixelArt.height {
            for col in 0..<pixelArt.width {
                let colorHex = pixelArt.pixels[row][col]
                guard let color = UIColor(hex: colorHex) else { continue }

                let fillColor: UIColor
                if let selected = cellColors[row][col] {
                    fillColor = selected // If user has selected a color for this pixel, use that
                } else {
                    fillColor = color // Otherwise, use the original color from the pixelArt
                }

                fillColor.setFill() // Set the fill color
                let pixelRect = CGRect(x: CGFloat(col) * pixelWidth, y: CGFloat(row) * pixelHeight, width: pixelWidth, height: pixelHeight)
                let pixelPath = UIBezierPath(rect: pixelRect)
                pixelPath.fill() // Draw the pixel

                // Optionally, if there's a number to display
                if let number = pixelArt.numbers?[row][col] {
                    let text = "\(number)"
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 12),
                        .foregroundColor: UIColor.black
                    ]
                    let string = NSString(string: text)
                    string.draw(in: pixelRect, withAttributes: attributes)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let touchLocation = touch.location(in: self)
        let pixelWidth = self.bounds.width / CGFloat(pixelArt.width)
        let pixelHeight = self.bounds.height / CGFloat(pixelArt.height)

        let col = Int(touchLocation.x / pixelWidth)
        let row = Int(touchLocation.y / pixelHeight)

        // Ensure the touch is within bounds
        if col >= 0 && col < pixelArt.width && row >= 0 && row < pixelArt.height {
            let cellNumber = pixelArt.numbers?[row][col]

            // Dynamically set the selected number based on the cell tapped
            if let tappedNumber = cellNumber {
                selectedNumber = tappedNumber
            }

            // Handle the coloring logic based on the selected number
            if let selectedNumber = selectedNumber {
                // Color only the cells that have the same number as the selected one
                for r in 0..<pixelArt.height {
                    for c in 0..<pixelArt.width {
                        if let number = pixelArt.numbers?[r][c], number == selectedNumber {
                            cellColors[r][c] = selectedColor // Color matching cells
                            pixelArt.pixels[r][c] = selectedColor.toHex() // Update the pixel color
                        }
                    }
                }
            }

            // Notify that a color change occurred
            onColorChanged?()
            savePixelArtToDatabase(pixelArt: pixelArt)

            // Redraw the view to reflect the changes
            setNeedsDisplay()
        }
    }

    // New function to handle either a number or color name
    func updatePixelColor(by input: String) {
        // Check if input is a valid color name
        if let color = UIColor(named: input) {
            // If valid color name, color the pixels accordingly
            for r in 0..<pixelArt.height {
                for c in 0..<pixelArt.width {
                    if let pixelNumber = pixelArt.numbers?[r][c], pixelNumber == selectedNumber {
                        cellColors[r][c] = color
                        pixelArt.pixels[r][c] = color.toHex() // Update the pixel color in the model
                    }
                }
            }
        } else if let number = Int(input), let color = colorMapping[number] {
            // If input is a valid number, update corresponding pixels with the mapped color
            for r in 0..<pixelArt.height {
                for c in 0..<pixelArt.width {
                    if let pixelNumber = pixelArt.numbers?[r][c], pixelNumber == number {
                        cellColors[r][c] = color
                        pixelArt.pixels[r][c] = color.toHex() // Update the pixel color in the model
                    }
                }
            }
        } else {
            print("Invalid input: \(input) is neither a valid color nor a valid number.")
            return
        }

        // Notify that a color change occurred
        onColorChanged?()
        setNeedsDisplay() // Redraw the view
    }
}

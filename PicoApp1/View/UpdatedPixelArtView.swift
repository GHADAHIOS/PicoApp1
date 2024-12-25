//
//  PixelArtListView.swift
//  PJson
//
//  Created by Ashwaq on 24/06/1446 AH.
//

import SwiftUI
import SwiftData

struct UpdatePixelArtView: View {
    @Query(sort: \PixelArt.id) var pixelArts: [PixelArt]  // Fetch all PixelArt objects sorted by id
    @Environment(\.modelContext) private var modelContext
    @Binding var pixelArt: PixelArt? // Binding to optional PixelArt
  
    var body: some View {
        VStack {
            // Display the selected PixelArt ID and dimensions
            if let pixelArt = pixelArt {
                Text("Selected Pixel Art: \(pixelArt.id.uuidString)") // Show PixelArt ID
                    .font(.headline)
                    .padding()

                Text("Width: \(pixelArt.width), Height: \(pixelArt.height)") // Show dimensions
                    .padding()

                // Render the Pixel Grid (assuming pixelArt.pixels is a 2D array of color hex strings)
                VStack {
                    ForEach(0..<pixelArt.height, id: \.self) { row in
                        HStack {
                            ForEach(0..<pixelArt.width, id: \.self) { col in
                                let colorHex = pixelArt.pixels[row][col]
                                if let color = UIColor(hex: colorHex) {
                                    Rectangle()
                                        .fill(Color(color))
                                        .frame(width: 20, height: 20)
                                        .padding(0)// Adjust size of each pixel
                                        //.border(Color.black, width: 2)
                                } else {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 20)
                                       // .border(Color.black, width: 0)
                                }
                            }
                        }
                    }
                }
                .padding()
            } else {
                Text("No Pixel Art selected.") // When no PixelArt is selected
                    .font(.title)
                    .padding()
            }

            // Display the list of PixelArt entries from the database
//            if pixelArts.isEmpty {
//                Text("No Pixel Art data available.")
//                    .font(.title)
//                    .padding()
//            } else {
//                List(pixelArts, id: \.id) { pixelArt in
//                    VStack(alignment: .leading) {
//                        Text("PixelArt ID: \(pixelArt.id.uuidString)") // Display PixelArt ID
//                        Text("Width: \(pixelArt.width), Height: \(pixelArt.height)") // Dimensions of the PixelArt
//                    }
//                    .padding()
//                }
//            }
        }
        .onAppear {
            print("PixelArtListView appeared. Fetched \(pixelArts.count) PixelArt items.")
        }
        .navigationTitle("Pixel Art List")
    }
}

struct UpdatePixelArtView_Previews: PreviewProvider {
    static var previews: some View {
        // Providing sample data for Preview
        UpdatePixelArtView(pixelArt: .constant(nil))
            .previewDevice("iPhone 14")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

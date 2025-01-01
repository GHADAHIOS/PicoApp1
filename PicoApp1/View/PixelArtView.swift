//
//
//import SwiftUI
//import UIKit
//
//
//
//struct PixelArtView: View {
//    
//    @State private var gridData: [[GridCell]]  // The grid data model
//    @State private var selectedColor: UIColor = .red // Default color selected by the user
//    @State private var selectedNumber: Int = 1 // Default number to color cells (can be 1, 2, or 3)
//    @State private var originalGridData: [[GridCell]] // Keep a copy of the initial grid data
//    @State private var snapshotView: SnapshotView? // View for capturing the snapshot
////    @State private var gridImage: UIImage? // Store the grid image for the celebration view
//    @State private var gridImage: UIImage? = UIImage(named: "defaultImage")  // Set a default image if you prefer
//    @State private var isNavigatingToCollaborationScreen = false // To control navigation
//
//    
//    init() {
//        // Initialize the grid data (15x15 grid with all cells starting with number 0 and white color)
//        var initialGrid: [[GridCell]] = []
//        for _ in 0..<15 {
//            var rowData: [GridCell] = []
//            for _ in 0..<15 {
//                rowData.append(GridCell(number: 0, color: .white)) // Initialize cells with number 0 and color white
//            }
//            initialGrid.append(rowData)
//            
//        }
//        _gridData = State(initialValue: initialGrid)
//        _originalGridData = State(initialValue: initialGrid) //
//        drawArt()
//
//    }
//   
//    
//    
//    var body: some View {
//       NavigationStack{
//            ZStack {
//                // Background Color
//                Color(.BG)
//                    .ignoresSafeArea()
//                
//                VStack {
//                    // Header with title and buttons
//                    HStack {
//                        // Left button
//                        Button {
//                            // Action for "Category" button
//                        } label: {
//                            VStack {
//                                ZStack {
//                                    Circle()
//                                        .fill(Color.inspire)
//                                        .frame(width: 70, height: 70)
//                                        .offset(x: 3, y: 3)
//                                    
//                                    Circle()
//                                        .fill(Color.binspire)
//                                        .frame(width: 70, height: 70)
//                                        .padding(5)
//                                    
//                                    Image(systemName: "circle.grid.2x2")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                        .foregroundColor(.white)
//                                }
//                                Text("Category")
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.black)
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        //
//                        //
//                        //                HStack {
//                        //                    Image("Pico")
//                        //                        .resizable()
//                        //                        .scaledToFit()
//                        //                        .frame(width: 115, height: 115)
//                        //                        .offset(x: 10, y: 30)
//                        //
//                        //                    ZStack {
//                        //                        Image("cloud")
//                        //                            .resizable()
//                        //                            .scaledToFit()
//                        //                            .frame(width: 780.0, height: 326)
//                        //                            .offset(x: -50, y: -80)
//                        //
//                        //                        Text("Say the number to color it")
//                        //                            .font(.title)
//                        //                            .fontWeight(.semibold)
//                        //                            .foregroundColor(.font1)
//                        //                            .multilineTextAlignment(.center)
//                        //                            .padding(.horizontal, 50)
//                        //                            .offset(x: -40, y: -80)
//                        //                    }
//                        //                }
//                        //                .padding(.top, 0)
//                        
//                        
//                        
//                        
//                        
//                        // Title at the center
//                        Text("Say the number to color it")
//                            .font(.title)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.font1)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal, 50)
//                        
//                        Spacer()
//                        
//                        // Right button
//                        Button {
//                            // Action for "Colorings" button
//                        } label: {
//                            VStack {
//                                ZStack {
//                                    Circle()
//                                        .fill(Color.inspire)
//                                        .frame(width: 70, height: 70)
//                                        .offset(x: 3, y: 3)
//                                    
//                                    Circle()
//                                        .fill(Color.binspire)
//                                        .frame(width: 70, height: 70)
//                                    
//                                    Image(systemName: "paintbrush.fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(.white)
//                                }
//                                Text("Colorings")
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.black)
//                            }
//                        }
//                    }
//                    .padding(.top, 10)  // Add padding to the top of the header
////                    .padding()
//                    //            .background(Color.white.opacity(0.7))
//                    
//                    // Main content area (Grid + Left Panel + Color Buttons)
//                    HStack(spacing: -30) {
//                        // Left panel for Undo/Redo/Reset buttons
//                        VStack(spacing: 10)
//                        {
//                            
////                            NavigationLink(destination:  CellarbrationScreen(pixelArt: $pixelArt),isActive: $isNavigatingToCollaborationScreen) {
////                                VStack {
////                                    ZStack {
////                                        Circle()
////                                            .fill(Color.green)
////                                            .frame(width: 77, height: 73)
////                                            .offset(x: 3, y: 3)
////                                        
////                                        Circle()
////                                            .fill(Color.green)
////                                            .frame(width: 77, height: 70)
////                                            .padding(5)
////                                        
////                                        Image(systemName: "checkmark")
////                                            .resizable()
////                                            .scaledToFit()
////                                            .frame(width: 40, height: 40)
////                                            .foregroundColor(.white)
////                                    }
////                                    Text("Done")
////                                        .font(.title2)
////                                        .fontWeight(.bold)
////                                        .foregroundColor(.black)
////                                } .onTapGesture {
////                                    // Capture the snapshot before navigation
////                                    if let capturedImage = captureSnapshot() {
////                                        gridImage = capturedImage
////                                        isNavigatingToCollaborationScreen = true
////                                    }
////                                    
////                                }
////                                
////                            }
//                           // .padding()
//                           // .frame(width: 120)
//                            //.cornerRadius(10)
//                            
//                            
////                            Button {
////                                redo()
////                            } label: {
////                                VStack {
////                                    ZStack {
////                                        Circle()
////                                            .fill(Color.inspire)
////                                            .frame(width: 70, height: 70)
////                                            .offset(x: 3, y: 3)
////                                        
////                                        Circle()
////                                            .fill(Color.binspire)
////                                            .frame(width: 70, height: 70)
////                                            .padding(5)
////                                        
////                                        Image(systemName: "arrowshape.turn.up.right.fill")
////                                            .resizable()
////                                            .scaledToFit()
////                                            .frame(width: 40, height: 40)
////                                            .foregroundColor(.white)
////                                    }
////                                    Text("Redo")
////                                        .font(.title2)
////                                        .fontWeight(.bold)
////                                        .foregroundColor(.black)
////                                }
////                            }
//                            
//                            Button {
//                                reset()
//                            } label: {
//                                VStack {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color.bBrave)
//                                            .frame(width: 70, height: 70)
//                                            .offset(x: 3, y: 3)
//                                        
//                                        Circle()
//                                            .fill(Color.brave)
//                                            .frame(width: 70, height: 70)
//                                            .padding(5)
//                                        
//                                        Image(systemName: "arrow.counterclockwise")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 40, height: 40)
//                                            .foregroundColor(.white)
//                                    }
//                                    Text("Reset")
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.black)
//                                }
//                            }
//                        }
//                        .padding()
//                        .frame(width: 100)
//                        .cornerRadius(10)
//                        
//                        Spacer()
//                        
//                        // Main content area (Grid + Color Buttons)
//                        VStack {
//                            GridCollectionView(gridData: $gridData, cellSize: 30, selectedColor: $selectedColor, selectedNumber: $selectedNumber)
//                                .frame(width: 450, height: 450) // Fixed size for the grid
//                            
//                            Spacer()
//                            
//                            // Color buttons at the bottom, centered
//                            HStack {
//                                ColorButton(color: .black, label: "Black", selectedColor: $selectedColor)
//                                ColorButton(color: .gray, label: "Gray", selectedColor: $selectedColor)
//                                ColorButton(color: .purple, label: "Purple", selectedColor: $selectedColor)
//                                ColorButton(color: .blue, label: "Blue", selectedColor: $selectedColor)
//                                ColorButton(color: .green, label: "Green", selectedColor: $selectedColor)
//                                ColorButton(color: .brown, label: "Brown", selectedColor: $selectedColor)
//                                ColorButton(color: .red, label: "Red", selectedColor: $selectedColor)
//                                ColorButton(color: .orange, label: "Pink", selectedColor: $selectedColor)
//                                ColorButton(color: .orange, label: "Orange", selectedColor: $selectedColor)
//                                ColorButton(color: .yellow, label: "Yellow", selectedColor: $selectedColor)
//                                ColorButton(color: .white, label: "White", selectedColor: $selectedColor)
//                            }
//                            .frame(maxWidth: .infinity) // Center the color buttons horizontally
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the grid stays centered
//                    }
//                    
//                }.padding(.horizontal) // Add left and right padding to the main content
//                
//            }
//            .navigationBarBackButtonHidden(true)
//            .onAppear {
//                drawArt()
//            }
//        }
//        
//    }
//
////* End the Pixel Art view *//
//    
//    // Method to draw predefined art (numbering the cells and coloring shapes)
// 
//    
//    // Reset Functionality
//    func reset() {
//        gridData = originalGridData // Reset the grid to the original state
//       drawArt() // Reapply the art
//    }
//    
//    
//    // Function to capture the snapshot of the grid
//    func captureSnapshot() -> UIImage? {
//            // Create a dummy UIView to capture the image of the grid
//            let gridView = UIHostingController(rootView: GridCollectionView(gridData: $gridData, cellSize: 30, selectedColor: $selectedColor, selectedNumber: $selectedNumber))
//            let size = CGSize(width: 450, height: 450) // Set the size of the grid
//            let renderer = UIGraphicsImageRenderer(size: size)
//
//            return renderer.image { ctx in
//                gridView.view.layer.render(in: ctx.cgContext)
//            }
//        }
//   
//    
//    func drawArt() {
//        print("drawArt")
//        // Number cells with "1" and color gray for shape 1
//        numberCellsWithNumberAndGrayShape([
//            (1, 10), (1, 11),
//            (2, 11), (2, 12),
//            (3, 12), (3, 13),
//            (4, 12), (4, 13),
//            (5, 12), (5, 13),
//            (6, 13), (6, 12),
//            (7, 12), (7, 13),
//            (8, 12), (8, 13),
//            (9, 11), (9, 12),
//            (10, 1), (10, 10), (10, 11), (10, 12),
//            (11, 1), (11, 2), (11, 9), (11, 10), (11, 11),
//            (12, 2), (12, 3), (12, 4), (12, 5), (12, 6), (12, 7), (12, 8), (12, 9), (12, 10),
//            (13, 3), (13, 4), (13, 5), (13, 6), (13, 7), (13, 8)
//        ], number: 1, color: UIColor.lightGray)
//
//        // Number cells with "2" and color gray for shape 2
//        numberCellsWithNumberAndGrayShape([
//            (2, 10), (3, 10),
//            (3, 10), (3, 11),
//            (4, 11), (4, 11),
//            (5, 11), (6, 11), (7, 11), (8, 11), (8, 10), (9, 10),
//            (10, 2), (10, 3), (10, 8), (10, 9),
//            (11, 3), (11, 4), (11, 5), (11, 6), (11, 7), (11, 8)
//        ], number: 2, color: UIColor.darkGray)
//
//        // Number cells with "3" and color gray for shape 3
//        numberCellsWithNumberAndGrayShape([
//            (2, 9),
//            (3, 8), (3, 9),
//            (4, 7), (4, 8), (4, 10),
//            (5, 6), (5, 7), (5, 8), (5, 9), (5, 10),
//            (6, 5), (6, 6), (6, 7), (6, 9), (6, 10),
//            (7, 4), (7, 5), (7, 6), (7, 7), (7, 8), (7, 9), (7, 10),
//            (8, 3), (8, 4), (8, 5), (8, 7), (8, 8), (8, 9),
//            (9, 2), (9, 3), (9, 5), (9, 6), (9, 7), (9, 8), (9, 9),
//            (10, 4), (10, 5), (10, 6), (10, 7)
//        ], number: 3, color: UIColor.gray)
//    }
//
//    // Method to number specific cells and color them with gray shapes
//    func numberCellsWithNumberAndGrayShape(_ coordinates: [(Int, Int)], number: Int, color: UIColor) {
//   
//        for (row, col) in coordinates {
//            guard row >= 0, row < 15, col >= 0, col < 15 else { continue }
//            gridData[row][col].number = number // Set the number of the cell
//            gridData[row][col].color = color // Set the color of the cell to the gray color based on the shape number
//        }
//    }
//
//    // Method to apply the selected color to all cells that match the selected number
//    func colorCellsWithSelectedNumber() {
//        print("colorCellsWithSelectedNumber")
//        for row in 0..<15 {
//            for col in 0..<15 {
//                if gridData[row][col].number == selectedNumber {
//                    gridData[row][col].color = selectedColor
//                }
//            }
//        }
//    }
//}
//
//// Color Button Component to change the selected color
//struct ColorButton: View {
//    var color: UIColor
//    var label:String
//    @Binding var selectedColor: UIColor
//    
//    var body: some View {
//        
//        Button(action: {
//            selectedColor = color
//        }) {
//            
//            VStack{
//                ZStack {
//                    // Use Color here directly, not UIColor
//                    Circle()
//                        .fill(Color(color))
//                        .frame(width: 40, height: 40)
//                    
//                    Circle()
//                        .stroke(Color.white, lineWidth: 6)
//                        .frame(width: 40, height: 40)
//                        .shadow(color: Color.black, radius: 1)
//                }
//                Text(label)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .padding(.horizontal, 10)
//            }
//        }
//    }
//}
//
//// Grid collection view for displaying the grid
//struct GridCollectionView: UIViewControllerRepresentable {
//    @Binding var gridData: [[GridCell]] // Binding to the grid data
//    var cellSize: CGFloat  // The dynamic size of each cell
//    @Binding var selectedColor: UIColor // Selected color for coloring cells
//    @Binding var selectedNumber: Int // Selected number to match when coloring cells
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
//        var parent: GridCollectionView
//        var collectionView: UICollectionView?  // To hold the reference to UICollectionView
//
//        init(parent: GridCollectionView) {
//            self.parent = parent
//        }
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return 15 * 15 // 15x15 grid
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCellCollectionViewCell
//            let row = indexPath.item / 15
//            let col = indexPath.item % 15
//
//            let gridCell = parent.gridData[row][col]
//            cell.configure(with: gridCell)
//
//            // Store a reference to the collection view for future use
//            self.collectionView = collectionView
//
//            // Tap gesture to allow coloring
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(sender:)))
//            cell.addGestureRecognizer(tapGesture)
//            cell.tag = indexPath.item // Store the index in the cell for later use
//
//            return cell
//        }
//
//        @objc func handleCellTap(sender: UITapGestureRecognizer) {
//            if let cell = sender.view as? GridCellCollectionViewCell {
//                let index = cell.tag
//                let row = index / 15
//                let col = index % 15
//
//                // Get the number of the tapped cell
//                let tappedCellNumber = self.parent.gridData[row][col].number
//                
//                // Set the color of the tapped cell to the selected color
//                self.parent.gridData[row][col].color = self.parent.selectedColor
//                cell.configure(with: self.parent.gridData[row][col])  // Update tapped cell color immediately
//
//                // Loop through the entire grid to find all cells with the same number as the tapped cell
//                for r in 0..<15 {
//                    for c in 0..<15 {
//                        if self.parent.gridData[r][c].number == tappedCellNumber {
//                            // Change the color of all cells with the same number to the selected color
//                            self.parent.gridData[r][c].color = self.parent.selectedColor
//                            
//                            // Get the corresponding cell view and update it
//                            if let updateCell = self.collectionView?.cellForItem(at: IndexPath(item: r * 15 + c, section: 0)) as? GridCellCollectionViewCell {
//                                updateCell.configure(with: self.parent.gridData[r][c])  // Update cell color
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func makeUIViewController(context: Context) -> UICollectionViewController {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: cellSize, height: cellSize)  // Use the dynamic cell size
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//
//        let collectionViewController = UICollectionViewController(collectionViewLayout: layout)
//        collectionViewController.collectionView.delegate = context.coordinator
//        collectionViewController.collectionView.dataSource = context.coordinator
//        collectionViewController.collectionView.register(GridCellCollectionViewCell.self, forCellWithReuseIdentifier: "GridCell")
//
//        return collectionViewController
//    }
//
//    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
//        uiViewController.collectionView.reloadData() // Reload the collection view when gridData changes
//    }
//}
//
//
//// Grid cell collection view cell
//class GridCellCollectionViewCell: UICollectionViewCell {
//    var numberLabel: UILabel!
//    var colorView: UIView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        colorView = UIView(frame: bounds)
//        colorView.layer.borderWidth = 1.0
//        colorView.layer.borderColor = UIColor.black.cgColor
//        contentView.addSubview(colorView)
//
//        numberLabel = UILabel()
//        numberLabel.font = .systemFont(ofSize: 10)
//        numberLabel.textAlignment = .center
//        numberLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(numberLabel)
//
//        NSLayoutConstraint.activate([
//            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            numberLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            numberLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with gridCell: GridCell) {
//        colorView.backgroundColor = gridCell.color
//        numberLabel.text = gridCell.number == 0 ? "" : "\(gridCell.number)"
//    }
//    
//}
//
//#Preview{
//    PixelArtView()
//}

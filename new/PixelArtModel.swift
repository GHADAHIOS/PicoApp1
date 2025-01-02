
import Foundation
import SwiftData
import CoreData

@Model
class PixelArt: Decodable {
    var id: UUID
    var name: String
    var width: Int
    var height: Int
    var pixels: [[String]] // Hex color strings
    var numbers: [[Int?]]?

    // Custom init to handle decoding manually
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the `id` property (ensure to convert it from a string to UUID).
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID() // Fallback to a new UUID if decoding fails

        // Decode the remaining properties.
        self.name =  try container.decode(String.self, forKey: .name)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.pixels = try container.decode([[String]].self, forKey: .pixels)
        self.numbers = try container.decodeIfPresent([[Int?]].self, forKey: .numbers)
        
        // If the `id` is missing from JSON, generate a new UUID
             if let id = try? container.decode(UUID.self, forKey: .id) {
                 self.id = id
             } else {
                 self.id = UUID() // Generate a new UUID if the 'id' key is missing
             }
    }
    
    // Enum for custom decoding keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case width
        case height
        case pixels
        case numbers
    }
    
   
    

}


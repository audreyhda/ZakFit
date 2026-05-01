import Foundation

struct JWToken: Codable {
    let value: String

    enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}

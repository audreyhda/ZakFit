import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(String)
    case decodingFailed(String)
    case server(reason: String, statusCode: Int)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL invalide."
        case .requestFailed(let message): return "Erreur réseau : \(message)"
        case .decodingFailed(let message): return "Erreur de décodage : \(message)"
        case .server(let reason, _): return reason
        case .unauthorized: return "Session expirée. Veuillez vous reconnecter."
        }
    }
}

struct APIClient {
    static let baseURL = "http://127.0.0.1:8080"

    static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    static func url(_ path: String) -> URL? {
        URL(string: baseURL + path)
    }

    static func request(_ path: String, method: String = "GET", body: Data? = nil, authenticated: Bool = false) throws -> URLRequest {
        guard let url = url(path) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if authenticated {
            guard let token = KeychainManager.getTokenFromKeychain() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        return request
    }

    static func send<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.requestFailed("Réponse invalide")
        }
        if http.statusCode == 401 {
            throw APIError.unauthorized
        }
        guard (200..<300).contains(http.statusCode) else {
            let reason = (try? jsonDecoder.decode(ServerErrorResponse.self, from: data))?.reason
                ?? "Erreur serveur (\(http.statusCode))"
            throw APIError.server(reason: reason, statusCode: http.statusCode)
        }
        if T.self == EmptyResponse.self {
            return EmptyResponse() as! T
        }
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error.localizedDescription)
        }
    }

    static func sendVoid(_ request: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.requestFailed("Réponse invalide")
        }
        if http.statusCode == 401 {
            throw APIError.unauthorized
        }
        guard (200..<300).contains(http.statusCode) else {
            let reason = (try? jsonDecoder.decode(ServerErrorResponse.self, from: data))?.reason
                ?? "Erreur serveur (\(http.statusCode))"
            throw APIError.server(reason: reason, statusCode: http.statusCode)
        }
    }
}

struct EmptyResponse: Decodable {}

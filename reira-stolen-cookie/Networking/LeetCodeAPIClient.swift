import Foundation

struct LeetCodeAPIClient {
    private let baseURL = "http://localhost:3000"

    private var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    func fetchSolvedQuestions() async throws -> [SolvedQuestion] {
        guard let url = URL(string: "\(baseURL)/me/solvedQuestions") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try decoder.decode(SolvedQuestionsResponse.self, from: data)
        return response.solvedQuestions
    }
}

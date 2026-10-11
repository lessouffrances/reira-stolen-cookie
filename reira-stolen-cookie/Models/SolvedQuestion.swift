import Foundation

struct TopicTag: Codable, Hashable {
    let name: String
    let slug: String
}

enum Difficulty: String, Codable {
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
}

struct SolvedQuestionsResponse: Codable {
    let count: Int
    let totalSolved: Int
    let solvedQuestions: [SolvedQuestion]
}

struct SolvedQuestion: Codable, Identifiable {
    let questionFrontendId: String
    let title: String
    let titleSlug: String
    let link: String
    let difficulty: Difficulty
    let lastSubmittedAt: Date
    let numSubmitted: Int
    let topicTags: [TopicTag]

    var id: String { questionFrontendId }
}

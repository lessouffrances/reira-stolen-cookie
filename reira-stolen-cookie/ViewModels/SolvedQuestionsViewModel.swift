import Foundation
import Observation

@Observable
final class SolvedQuestionsViewModel {
    var questions: [SolvedQuestion] = []
    var selectedIDs: Set<String> = []
    var isLoading = false
    var error: Error?

    func toggle(_ question: SolvedQuestion) {
        if selectedIDs.contains(question.id) {
            selectedIDs.remove(question.id)
        } else {
            selectedIDs.insert(question.id)
        }
    }

    func fetch() async {
        isLoading = true
        error = nil
        do {
            questions = try await LeetCodeAPIClient().fetchSolvedQuestions()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

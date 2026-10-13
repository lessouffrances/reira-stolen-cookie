import SwiftUI

struct ContentView: View {
    @State private var viewModel = SolvedQuestionsViewModel()
    @State private var showSelectedOnly = false

    var displayedQuestions: [SolvedQuestion] {
        if showSelectedOnly {
            return viewModel.questions.filter { viewModel.selectedIDs.contains($0.id) }
        }
        return viewModel.questions
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Fetching questions...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)
                    Text("Could not connect to server")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(displayedQuestions) { question in
                    QuestionRow(
                        question: question,
                        isSelected: viewModel.selectedIDs.contains(question.id),
                        showCheckbox: !showSelectedOnly
                    ) {
                        viewModel.toggle(question)
                    }
                }
                .listStyle(.inset)
            }
        }
        .navigationTitle("Solved Questions (\(viewModel.questions.count))")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Toggle(isOn: $showSelectedOnly) {
                    Text(showSelectedOnly ? "Selected" : "All")
                        .font(.caption)
                }
                .toggleStyle(.switch)
                .disabled(viewModel.selectedIDs.isEmpty && !showSelectedOnly)
            }
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct QuestionRow: View {
    let question: SolvedQuestion
    let isSelected: Bool
    let showCheckbox: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text("#\(question.questionFrontendId)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(width: 40, alignment: .trailing)

                VStack(alignment: .leading, spacing: 4) {
                    Text(question.title)
                        .font(.body)
                        .foregroundStyle(.primary)

                    HStack(spacing: 6) {
                        DifficultyBadge(difficulty: question.difficulty)

                        Text(question.topicTags.prefix(3).map(\.name).joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    if showCheckbox {
                        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                    }
                    Text("\(question.numSubmitted) attempts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(question.lastSubmittedAt, style: .date)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty

    var color: Color {
        switch difficulty {
        case .easy:   return .green
        case .medium: return .orange
        case .hard:   return .red
        }
    }

    var label: String {
        switch difficulty {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        }
    }

    var body: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    ContentView()
}

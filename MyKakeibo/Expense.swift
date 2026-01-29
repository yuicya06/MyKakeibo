import Foundation

struct Expense: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let amount: Int
    let date: Date
    let category: ExpenseCategory
}

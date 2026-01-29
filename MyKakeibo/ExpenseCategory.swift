import Foundation

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "食費"
    case transport = "交通"
    case fixed = "固定費"
    case entertainment = "娯楽"
    case other = "その他"
}

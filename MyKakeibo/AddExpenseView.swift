import SwiftUI

struct AddExpenseView: View {

    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var category: ExpenseCategory = .food


    let onSave: (Expense) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("内容")) {
                    TextField("支出名（例：ランチ）", text: $title)
                    TextField("金額", text: $amount)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("日付")) {
                    DatePicker("日付", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("カテゴリ")) {
                    Picker("カテゴリ", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }

            }
            .navigationTitle("支出を追加")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if let amountInt = Int(amount) {
                            let expense = Expense(
                                id: UUID(),
                                title: title,
                                amount: amountInt,
                                date: date,
                                category: category,
                            )
                            onSave(expense)
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}

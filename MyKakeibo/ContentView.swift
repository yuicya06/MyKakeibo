import SwiftUI


struct ContentView: View {
    //テストコメント

    @State private var expenses: [Expense] = []
    @State private var showAddView = false
    
    let saveKey = "expenses"
    
    
    var totalAmount: Int {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    
    var currentMonthExpenses: [Expense] {
        let calendar = Calendar.current
        let now = Date()

        return expenses.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }
    }
    
    var currentMonthTotal: Int {
        currentMonthExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var currentMonthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        return formatter.string(from: Date())
    }



    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("今月の合計")
                            .font(.headline)

                        Spacer()

                        Text("¥\(currentMonthTotal.formatted())")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 4)
                }


                Section {
                    ForEach(currentMonthExpenses) { expense in
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(expense.title)
                                    .font(.headline)

                                Spacer()

                                Text(expense.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                 

                            HStack {
                                Text("¥\(expense.amount)")
                                Spacer()
                                Text(expense.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }.onDelete(perform: deleteExpense)

                }
            }

            .navigationTitle("家計簿（\(currentMonthTitle)）")
            .toolbar {
                Button {
                    showAddView = true
                } label: {
                    Image(systemName: "plus")
                }
                EditButton()
            }
            .sheet(isPresented: $showAddView) {
                AddExpenseView { newExpense in
                    expenses.append(newExpense)
                }
            }
            
            .onAppear {
                    loadExpenses()
            }
            .onChange(of: expenses) {
                    saveExpenses()
            }
            
        }
    }
    
    func saveExpenses() {
        if let data = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { currentMonthExpenses[$0] }
        expenses.removeAll { itemsToDelete.contains($0) }
    }

    
    
    
}

import SwiftUI

struct LongestStreaksView: View {
    @EnvironmentObject var viewModel: HabitListViewModel
    @State private var activeSheet: CustomMenuButton.ActiveSheet?
    @Environment(\.presentationMode) private var presentationMode


    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.habits.filter({ $0.streak > 0 }), id: \.id) { habit in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(habit.name)
                                .font(.headline)
                            Text(habit.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "rosette")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.yellow)
                            .overlay(
                                Text("\(habit.longestStreak)")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            )
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationBarTitle("Longest Streaks")
            .navigationBarItems(trailing:
                CustomMenuButton(
                    activeSheet: $activeSheet,
                    currentView: .longestStreaks,
                    onHomeButtonTapped: { presentationMode.wrappedValue.dismiss() }
                )
            )
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .addHabit:
                    AddEditHabitView(habitToEdit: nil)

                        .environmentObject(viewModel)
                case .editHabit:
                    AddEditHabitView(habitToEdit: nil)

                        .environmentObject(viewModel)
                case .longestStreaks:
                    LongestStreaksView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        viewModel.habits.remove(atOffsets: offsets)
    }
}

struct LongestStreaksView_Previews: PreviewProvider {
    static var previews: some View {
        LongestStreaksView()
            .environmentObject(HabitListViewModel())
    }
}



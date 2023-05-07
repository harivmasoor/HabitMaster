import SwiftUI

struct HabitDetailView: View {
    @Binding var habit: Habit
    @State private var editingDescription = false

    var body: some View {
        VStack {
            Text("Completion date:")
                .font(.subheadline)
                .padding(.top)
            
            Text(habit.subtitle)
                .font(.subheadline)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding()
                .onLongPressGesture {
                    self.editingDescription.toggle()
                }
                .sheet(isPresented: $editingDescription) {
                    NavigationView {
                        VStack {
                            TextEditor(text: $habit.subtitle)
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                                .padding()
                            
                            Spacer()
                        }
                        .navigationBarTitle("Edit Description", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Save") {
                            self.editingDescription.toggle()
                        })
                    }
                }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(habit.name)
    }
}

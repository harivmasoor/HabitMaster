import SwiftUI

struct HabitDescriptionEditor: View {
    @Binding var habitDescription: String
    @State private var habitDescriptionLocal: String
    @Environment(\.presentationMode) var presentationMode

    init(habitDescription: Binding<String>) {
        self._habitDescription = habitDescription
        self._habitDescriptionLocal = State(initialValue: habitDescription.wrappedValue)
    }

    var body: some View {
        VStack {
            TextField("Enter Habit Description", text: $habitDescriptionLocal)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            Spacer()
            
            Button(action: {
                habitDescription = habitDescriptionLocal
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
        .navigationBarTitle("Edit Description", displayMode: .inline)
    }
}


struct HabitDescriptionEditor_Previews: PreviewProvider {
    static var previews: some View {
        HabitDescriptionEditor(habitDescription: .constant("Meditate for 5 minutes a day"))
    }
}



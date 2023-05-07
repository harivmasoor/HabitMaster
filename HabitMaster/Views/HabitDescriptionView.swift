import SwiftUI

struct HabitDescriptionView: View {
    @Binding var habitDescription: String
    @State private var editingDescription = false
    @State private var habitDescriptionLocal = ""
    
    var body: some View {
        VStack {
            Text("Description")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text(habitDescription)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.bottom)
        .onTapGesture {
            self.habitDescriptionLocal = self.habitDescription
            self.editingDescription = true
        }
        .sheet(isPresented: $editingDescription) {
            HabitDescriptionEditor(habitDescription: $habitDescriptionLocal)
                .onDisappear {
                    self.habitDescription = self.habitDescriptionLocal
                    self.editingDescription = false
                }
        }
    }
}





struct HabitDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDescriptionView(habitDescription: .constant("Meditate for 5 minutes a day"))
    }
}

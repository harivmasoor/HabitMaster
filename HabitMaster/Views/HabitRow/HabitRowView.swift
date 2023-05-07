import SwiftUI

struct HabitRowView: View {
    var habit: Habit

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.headline)
                Text(habit.subtitle)
                    .font(.subheadline)
            }
            Spacer()
            Text("Streak: \(habit.streak)")
                .font(.callout)
                .padding(5)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        HabitRowView(habit: Habit(name: "Meditate", subtitle: "Meditate for 5 minutes today"))
            .previewLayout(.sizeThatFits)
    }
}



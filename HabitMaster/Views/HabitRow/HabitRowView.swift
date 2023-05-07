// HabitRowView.swift
import SwiftUI

struct HabitRowView: View {
    var habit: Habit
    @Binding var toggleIsOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.headline)
            }
            Spacer()
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(habit.streak)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                )
            Toggle("", isOn: $toggleIsOn)
                .labelsHidden()
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        HabitRowView(habit: Habit(name: "Meditation", subtitle: "Meditate for 10 minutes"), toggleIsOn: .constant(true))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white)
    }
}






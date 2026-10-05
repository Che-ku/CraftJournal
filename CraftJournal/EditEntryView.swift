import SwiftUI
internal import CoreData

struct EditEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var entry: CraftEntry

    @State private var title: String
    @State private var selectedCraft: String
    @State private var notes: String
    @State private var artisanName: String

    let crafts = [
        "Shingzo",
        "Dozo",
        "Parzo",
        "Lhazo",
        "Jinzo",
        "Lugzo",
        "Garzo",
        "Troeko",
        "Tsharzo",
        "Thagzo",
        "Tshemzo",
        "Shagzo",
        "Deh-sho"
    ]

    init(entry: CraftEntry) {
        self.entry = entry

        _title = State(initialValue: entry.title ?? "")
        _selectedCraft = State(initialValue: entry.craftType ?? "Shingzo")
        _notes = State(initialValue: entry.notes ?? "")
        _artisanName = State(initialValue: entry.artisanName ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Craft Information") {
                    TextField("Title", text: $title)

                    Picker("Craft Type", selection: $selectedCraft) {
                        ForEach(crafts, id: \.self) { craft in
                            Text(craft)
                        }
                    }

                    TextField("Artisan name", text: $artisanName)
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(4...8)
                }
            }
            .navigationTitle("Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveChanges() {
        entry.title = title
        entry.craftType = selectedCraft
        entry.notes = notes
        entry.artisanName = artisanName

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Could not update entry: \(error)")
        }
    }
}

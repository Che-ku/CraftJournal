import SwiftUI

struct EntryDetailView: View {
    @ObservedObject var entry: CraftEntry
    @State private var showingEdit = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(entry.title ?? "Untitled")
                    .font(.largeTitle)
                    .bold()
                Text(entry.craftType ?? "")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                if let artisan = entry.artisanName,
                   !artisan.isEmpty {
                    Text("Artisan: \(artisan)")
                        .font(.title3)
                }
                if let notes = entry.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.body)
                }
                if let date = entry.date {
                    Text(date, style: .date)
                }
                if let data = entry.photo,
                   let image = UIImage(data: data) {

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        showingEdit = true
                    }
                }
            }
            .sheet(isPresented: $showingEdit) {
                EditEntryView(entry: entry)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

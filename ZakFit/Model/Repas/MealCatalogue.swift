import Foundation

/// Local representation of a meal category.
/// IDs are the fixed UUIDs from the `Categorie_repas` table — they never change.
struct LocalCategorieRepas: Identifiable {
    let id: UUID
    let nom: String
    let emoji: String
}

enum MealCatalogue {
    // Hex → UUID:
    //   0x7bafb768535244a79c7f91babd6435b5  →  Déjeuner
    //   0x9ea19b0a30314f7ea262e04ac1bc9d35  →  Dîner
    //   0xcb6716edda854bbbae4c1db75a2eb658  →  Snack
    //   0xf8c4640de2ec44909befd1fc18db9584  →  Petit déjeuner
    static let categories: [LocalCategorieRepas] = [
        LocalCategorieRepas(
            id: UUID(uuidString: "f8c4640d-e2ec-4490-9bef-d1fc18db9584")!,
            nom: "Petit déjeuner",
            emoji: "🥐"
        ),
        LocalCategorieRepas(
            id: UUID(uuidString: "7bafb768-5352-44a7-9c7f-91babd6435b5")!,
            nom: "Déjeuner",
            emoji: "🥘"
        ),
        LocalCategorieRepas(
            id: UUID(uuidString: "9ea19b0a-3031-4f7e-a262-e04ac1bc9d35")!,
            nom: "Dîner",
            emoji: "🥗"
        ),
        LocalCategorieRepas(
            id: UUID(uuidString: "cb6716ed-da85-4bbb-ae4c-1db75a2eb658")!,
            nom: "Snack",
            emoji: "🍎"
        )
    ]
}

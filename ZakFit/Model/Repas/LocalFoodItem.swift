import Foundation

struct LocalFoodItem: Identifiable, Hashable {
    let id = UUID()
    let nom: String
    let caloriePer100g: Int
    let proteinePer100g: Double
    let lipidePer100g: Double
    let glucidePer100g: Double

    func calories(forGrams grams: Int) -> Int {
        (caloriePer100g * grams) / 100
    }

    func proteine(forGrams grams: Int) -> Double {
        (proteinePer100g * Double(grams)) / 100
    }

    func lipide(forGrams grams: Int) -> Double {
        (lipidePer100g * Double(grams)) / 100
    }

    func glucide(forGrams grams: Int) -> Double {
        (glucidePer100g * Double(grams)) / 100
    }
}

enum WholeFoodCatalogue {
    static let all: [LocalFoodItem] = [
        // Fruits
        .init(nom: "Pomme",                caloriePer100g: 52,  proteinePer100g: 0.3,  lipidePer100g: 0.2,   glucidePer100g: 14),
        .init(nom: "Banane",               caloriePer100g: 89,  proteinePer100g: 1.1,  lipidePer100g: 0.3,   glucidePer100g: 23),
        .init(nom: "Orange",               caloriePer100g: 47,  proteinePer100g: 0.9,  lipidePer100g: 0.1,   glucidePer100g: 12),
        .init(nom: "Fraises",              caloriePer100g: 32,  proteinePer100g: 0.7,  lipidePer100g: 0.3,   glucidePer100g: 8),
        .init(nom: "Myrtilles",            caloriePer100g: 57,  proteinePer100g: 0.7,  lipidePer100g: 0.3,   glucidePer100g: 14),
        .init(nom: "Raisin",               caloriePer100g: 69,  proteinePer100g: 0.7,  lipidePer100g: 0.2,   glucidePer100g: 18),
        .init(nom: "Mangue",               caloriePer100g: 60,  proteinePer100g: 0.8,  lipidePer100g: 0.4,   glucidePer100g: 15),
        .init(nom: "Ananas",               caloriePer100g: 50,  proteinePer100g: 0.5,  lipidePer100g: 0.1,   glucidePer100g: 13),
        .init(nom: "Kiwi",                 caloriePer100g: 61,  proteinePer100g: 1.1,  lipidePer100g: 0.5,   glucidePer100g: 15),
        .init(nom: "Poire",                caloriePer100g: 57,  proteinePer100g: 0.4,  lipidePer100g: 0.1,   glucidePer100g: 15),
        .init(nom: "Pêche",                caloriePer100g: 39,  proteinePer100g: 0.9,  lipidePer100g: 0.3,   glucidePer100g: 10),
        .init(nom: "Cerise",               caloriePer100g: 50,  proteinePer100g: 1.0,  lipidePer100g: 0.3,   glucidePer100g: 12),
        .init(nom: "Avocat",               caloriePer100g: 160, proteinePer100g: 2.0,  lipidePer100g: 15.0,  glucidePer100g: 9),
        .init(nom: "Pamplemousse",         caloriePer100g: 42,  proteinePer100g: 0.8,  lipidePer100g: 0.1,   glucidePer100g: 11),
        .init(nom: "Grenade",              caloriePer100g: 83,  proteinePer100g: 1.7,  lipidePer100g: 1.2,   glucidePer100g: 19),
        .init(nom: "Figues fraîches",      caloriePer100g: 74,  proteinePer100g: 0.8,  lipidePer100g: 0.3,   glucidePer100g: 19),
        .init(nom: "Dattes",               caloriePer100g: 277, proteinePer100g: 1.8,  lipidePer100g: 0.2,   glucidePer100g: 75),

        // Légumes
        .init(nom: "Brocoli",              caloriePer100g: 34,  proteinePer100g: 2.8,  lipidePer100g: 0.4,   glucidePer100g: 7),
        .init(nom: "Épinards",             caloriePer100g: 23,  proteinePer100g: 2.9,  lipidePer100g: 0.4,   glucidePer100g: 4),
        .init(nom: "Carottes",             caloriePer100g: 41,  proteinePer100g: 0.9,  lipidePer100g: 0.2,   glucidePer100g: 10),
        .init(nom: "Tomate",               caloriePer100g: 18,  proteinePer100g: 0.9,  lipidePer100g: 0.2,   glucidePer100g: 4),
        .init(nom: "Concombre",            caloriePer100g: 16,  proteinePer100g: 0.7,  lipidePer100g: 0.1,   glucidePer100g: 4),
        .init(nom: "Poivron rouge",        caloriePer100g: 31,  proteinePer100g: 1.0,  lipidePer100g: 0.3,   glucidePer100g: 6),
        .init(nom: "Poivron vert",         caloriePer100g: 20,  proteinePer100g: 0.9,  lipidePer100g: 0.2,   glucidePer100g: 5),
        .init(nom: "Courgette",            caloriePer100g: 17,  proteinePer100g: 1.2,  lipidePer100g: 0.3,   glucidePer100g: 3),
        .init(nom: "Chou-fleur",           caloriePer100g: 25,  proteinePer100g: 1.9,  lipidePer100g: 0.3,   glucidePer100g: 5),
        .init(nom: "Champignons",          caloriePer100g: 22,  proteinePer100g: 3.1,  lipidePer100g: 0.3,   glucidePer100g: 3),
        .init(nom: "Oignon",               caloriePer100g: 40,  proteinePer100g: 1.1,  lipidePer100g: 0.1,   glucidePer100g: 9),
        .init(nom: "Patate douce",         caloriePer100g: 86,  proteinePer100g: 1.6,  lipidePer100g: 0.1,   glucidePer100g: 20),
        .init(nom: "Aubergine",            caloriePer100g: 25,  proteinePer100g: 1.0,  lipidePer100g: 0.2,   glucidePer100g: 6),
        .init(nom: "Asperges",             caloriePer100g: 20,  proteinePer100g: 2.2,  lipidePer100g: 0.1,   glucidePer100g: 4),
        .init(nom: "Céleri",               caloriePer100g: 16,  proteinePer100g: 0.7,  lipidePer100g: 0.2,   glucidePer100g: 3),
        .init(nom: "Petits pois",          caloriePer100g: 81,  proteinePer100g: 5.4,  lipidePer100g: 0.4,   glucidePer100g: 14),
        .init(nom: "Haricots verts",       caloriePer100g: 31,  proteinePer100g: 1.8,  lipidePer100g: 0.1,   glucidePer100g: 7),
        .init(nom: "Chou kale",            caloriePer100g: 49,  proteinePer100g: 4.3,  lipidePer100g: 0.9,   glucidePer100g: 9),
        .init(nom: "Roquette",             caloriePer100g: 25,  proteinePer100g: 2.6,  lipidePer100g: 0.7,   glucidePer100g: 4),
        .init(nom: "Laitue",               caloriePer100g: 15,  proteinePer100g: 1.4,  lipidePer100g: 0.2,   glucidePer100g: 3),
        .init(nom: "Chou blanc",           caloriePer100g: 25,  proteinePer100g: 1.3,  lipidePer100g: 0.1,   glucidePer100g: 6),
        .init(nom: "Betterave",            caloriePer100g: 43,  proteinePer100g: 1.6,  lipidePer100g: 0.2,   glucidePer100g: 10),
        .init(nom: "Poireau",              caloriePer100g: 61,  proteinePer100g: 1.5,  lipidePer100g: 0.3,   glucidePer100g: 14),
        .init(nom: "Maïs",                 caloriePer100g: 96,  proteinePer100g: 3.4,  lipidePer100g: 1.5,   glucidePer100g: 21),
        .init(nom: "Fenouil",              caloriePer100g: 31,  proteinePer100g: 1.2,  lipidePer100g: 0.2,   glucidePer100g: 7),
        .init(nom: "Navet",                caloriePer100g: 28,  proteinePer100g: 0.9,  lipidePer100g: 0.1,   glucidePer100g: 6),

        // Protéines animales
        .init(nom: "Poulet (blanc)",       caloriePer100g: 165, proteinePer100g: 31.0, lipidePer100g: 3.6,   glucidePer100g: 0),
        .init(nom: "Saumon",               caloriePer100g: 208, proteinePer100g: 20.0, lipidePer100g: 13.0,  glucidePer100g: 0),
        .init(nom: "Thon (naturel)",       caloriePer100g: 132, proteinePer100g: 29.0, lipidePer100g: 1.0,   glucidePer100g: 0),
        .init(nom: "Œuf entier",           caloriePer100g: 155, proteinePer100g: 13.0, lipidePer100g: 11.0,  glucidePer100g: 1),
        .init(nom: "Bœuf (maigre)",        caloriePer100g: 250, proteinePer100g: 26.0, lipidePer100g: 15.0,  glucidePer100g: 0),
        .init(nom: "Dinde (blanc)",        caloriePer100g: 135, proteinePer100g: 29.0, lipidePer100g: 1.0,   glucidePer100g: 0),
        .init(nom: "Crevettes",            caloriePer100g: 99,  proteinePer100g: 24.0, lipidePer100g: 0.3,   glucidePer100g: 0),
        .init(nom: "Sardines",             caloriePer100g: 208, proteinePer100g: 25.0, lipidePer100g: 11.0,  glucidePer100g: 0),
        .init(nom: "Saumon fumé",          caloriePer100g: 172, proteinePer100g: 18.0, lipidePer100g: 10.0,  glucidePer100g: 0),
        .init(nom: "Cabillaud",            caloriePer100g: 82,  proteinePer100g: 18.0, lipidePer100g: 0.7,   glucidePer100g: 0),
        .init(nom: "Truite",               caloriePer100g: 149, proteinePer100g: 20.0, lipidePer100g: 6.6,   glucidePer100g: 0),
        .init(nom: "Maquereau",            caloriePer100g: 205, proteinePer100g: 19.0, lipidePer100g: 14.0,  glucidePer100g: 0),
        .init(nom: "Porc (filet)",         caloriePer100g: 143, proteinePer100g: 26.0, lipidePer100g: 3.5,   glucidePer100g: 0),
        .init(nom: "Agneau (épaule)",      caloriePer100g: 235, proteinePer100g: 20.0, lipidePer100g: 17.0,  glucidePer100g: 0),
        .init(nom: "Canard (blanc)",       caloriePer100g: 140, proteinePer100g: 23.0, lipidePer100g: 5.0,   glucidePer100g: 0),
        .init(nom: "Calamar",              caloriePer100g: 92,  proteinePer100g: 16.0, lipidePer100g: 1.4,   glucidePer100g: 3),

        // Produits laitiers
        .init(nom: "Fromage blanc 0%",     caloriePer100g: 48,  proteinePer100g: 8.0,  lipidePer100g: 0.1,   glucidePer100g: 4),
        .init(nom: "Yaourt nature",        caloriePer100g: 59,  proteinePer100g: 3.5,  lipidePer100g: 3.3,   glucidePer100g: 4),
        .init(nom: "Skyr nature",          caloriePer100g: 63,  proteinePer100g: 10.0, lipidePer100g: 0.2,   glucidePer100g: 4),
        .init(nom: "Cottage cheese",       caloriePer100g: 98,  proteinePer100g: 11.0, lipidePer100g: 4.3,   glucidePer100g: 3),
        .init(nom: "Lait demi-écrémé",     caloriePer100g: 46,  proteinePer100g: 3.4,  lipidePer100g: 1.6,   glucidePer100g: 5),
        .init(nom: "Mozzarella",           caloriePer100g: 280, proteinePer100g: 22.0, lipidePer100g: 22.0,  glucidePer100g: 0),
        .init(nom: "Ricotta",              caloriePer100g: 174, proteinePer100g: 11.0, lipidePer100g: 13.0,  glucidePer100g: 3),
        .init(nom: "Kéfir nature",         caloriePer100g: 61,  proteinePer100g: 3.3,  lipidePer100g: 3.5,   glucidePer100g: 5),

        // Légumineuses
        .init(nom: "Lentilles cuites",     caloriePer100g: 116, proteinePer100g: 9.0,  lipidePer100g: 0.4,   glucidePer100g: 20),
        .init(nom: "Pois chiches cuits",   caloriePer100g: 164, proteinePer100g: 9.0,  lipidePer100g: 2.6,   glucidePer100g: 27),
        .init(nom: "Haricots rouges",      caloriePer100g: 127, proteinePer100g: 8.7,  lipidePer100g: 0.5,   glucidePer100g: 23),
        .init(nom: "Edamame",              caloriePer100g: 121, proteinePer100g: 11.0, lipidePer100g: 5.2,   glucidePer100g: 8),
        .init(nom: "Tofu",                 caloriePer100g: 76,  proteinePer100g: 8.0,  lipidePer100g: 4.8,   glucidePer100g: 2),

        // Céréales et féculents
        .init(nom: "Riz blanc cuit",       caloriePer100g: 130, proteinePer100g: 2.7,  lipidePer100g: 0.3,   glucidePer100g: 28),
        .init(nom: "Riz complet cuit",     caloriePer100g: 111, proteinePer100g: 2.6,  lipidePer100g: 0.9,   glucidePer100g: 23),
        .init(nom: "Quinoa cuit",          caloriePer100g: 120, proteinePer100g: 4.4,  lipidePer100g: 1.9,   glucidePer100g: 22),
        .init(nom: "Avoine (flocons)",     caloriePer100g: 389, proteinePer100g: 17.0, lipidePer100g: 7.0,   glucidePer100g: 66),
        .init(nom: "Pâtes complètes",      caloriePer100g: 140, proteinePer100g: 5.3,  lipidePer100g: 1.1,   glucidePer100g: 28),
        .init(nom: "Pain complet",         caloriePer100g: 247, proteinePer100g: 9.0,  lipidePer100g: 3.4,   glucidePer100g: 45),
        .init(nom: "Boulgour cuit",        caloriePer100g: 83,  proteinePer100g: 3.1,  lipidePer100g: 0.2,   glucidePer100g: 19),
        .init(nom: "Orge perlé cuit",      caloriePer100g: 123, proteinePer100g: 2.3,  lipidePer100g: 0.4,   glucidePer100g: 28),
        .init(nom: "Millet cuit",          caloriePer100g: 119, proteinePer100g: 3.5,  lipidePer100g: 1.0,   glucidePer100g: 24),

        // Noix et graines
        .init(nom: "Amandes",              caloriePer100g: 579, proteinePer100g: 21.0, lipidePer100g: 50.0,  glucidePer100g: 22),
        .init(nom: "Noix",                 caloriePer100g: 654, proteinePer100g: 15.0, lipidePer100g: 65.0,  glucidePer100g: 14),
        .init(nom: "Noisettes",            caloriePer100g: 628, proteinePer100g: 15.0, lipidePer100g: 61.0,  glucidePer100g: 17),
        .init(nom: "Noix de cajou",        caloriePer100g: 553, proteinePer100g: 18.0, lipidePer100g: 44.0,  glucidePer100g: 30),
        .init(nom: "Noix de pécan",        caloriePer100g: 691, proteinePer100g: 9.0,  lipidePer100g: 72.0,  glucidePer100g: 14),
        .init(nom: "Graines de tournesol", caloriePer100g: 584, proteinePer100g: 21.0, lipidePer100g: 51.0,  glucidePer100g: 20),
        .init(nom: "Graines de chia",      caloriePer100g: 486, proteinePer100g: 17.0, lipidePer100g: 31.0,  glucidePer100g: 42),
        .init(nom: "Graines de lin",       caloriePer100g: 534, proteinePer100g: 18.0, lipidePer100g: 42.0,  glucidePer100g: 29),
        .init(nom: "Graines de courge",    caloriePer100g: 559, proteinePer100g: 30.0, lipidePer100g: 49.0,  glucidePer100g: 11),
        .init(nom: "Graines de sésame",    caloriePer100g: 573, proteinePer100g: 17.0, lipidePer100g: 50.0,  glucidePer100g: 23),
        .init(nom: "Beurre d'amande",      caloriePer100g: 614, proteinePer100g: 21.0, lipidePer100g: 56.0,  glucidePer100g: 19),

        // Divers
        .init(nom: "Huile d'olive",        caloriePer100g: 884, proteinePer100g: 0.0,  lipidePer100g: 100.0, glucidePer100g: 0),
        .init(nom: "Huile de coco",        caloriePer100g: 862, proteinePer100g: 0.0,  lipidePer100g: 100.0, glucidePer100g: 0),
        .init(nom: "Miel",                 caloriePer100g: 304, proteinePer100g: 0.3,  lipidePer100g: 0.0,   glucidePer100g: 82),
    ]
}

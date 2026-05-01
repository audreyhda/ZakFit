import Foundation

struct HistoriqueDay: Identifiable, Hashable {
    /// Stable, date-based identity so chart diffs work correctly across recomputations.
    var id: Date { date }

    let date: Date
    let calorieTotale: Double
    let calorieBrulee: Double
    let proteine: Double
    let lipide: Double
    let glucide: Double
    let activitesCount: Int
    let repasCount: Int

    /// `true` when the day has at least one real or fake entry.
    var hasData: Bool {
        calorieTotale > 0 || calorieBrulee > 0 || activitesCount > 0 || repasCount > 0
    }
}

enum HistoriqueDataSource {

    // MARK: - Real data for today (supplied by ContentViewModel)

    struct TodayData {
        let calorieTotale: Double
        let calorieBrulee: Double
        let proteine: Double
        let lipide: Double
        let glucide: Double
        let activitesCount: Int
        let repasCount: Int
    }

    // MARK: - Last 30 days (used by DateHistoriqueView)

    static func lastMonth(referenceDate: Date = Date(),
                          today: TodayData? = nil,
                          goal: Int = 2000) -> [HistoriqueDay] {
        let calendar   = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        _ = goal
        return (0..<30).compactMap { offset -> HistoriqueDay? in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: referenceDate) else { return nil }
            let dayStart = calendar.startOfDay(for: date)
            return day(for: date, dayStart: dayStart, todayStart: todayStart, today: today)
        }
    }

    // MARK: - Mon–Sun of the ISO week containing referenceDate

    static func currentWeek(referenceDate: Date = Date(),
                             today: TodayData? = nil,
                             goal: Int = 2000) -> [HistoriqueDay] {
        var iso = Calendar(identifier: .iso8601)
        iso.locale = Locale(identifier: "fr_FR")
        var comps = iso.dateComponents([.yearForWeekOfYear, .weekOfYear], from: referenceDate)
        comps.weekday = 2  // Monday
        guard let monday = iso.date(from: comps) else { return [] }
        let cal        = Calendar.current
        let todayStart = cal.startOfDay(for: Date())
        return (0..<7).compactMap { offset -> HistoriqueDay? in
            guard let date = iso.date(byAdding: .day, value: offset, to: monday) else { return nil }
            let dayStart = cal.startOfDay(for: date)
            return day(for: date, dayStart: dayStart, todayStart: todayStart, today: today)
        }
    }

    // MARK: - All days of the calendar month containing referenceDate

    static func currentMonth(referenceDate: Date = Date(),
                              today: TodayData? = nil,
                              goal: Int = 2000) -> [HistoriqueDay] {
        let cal        = Calendar.current
        let todayStart = cal.startOfDay(for: Date())
        guard let range = cal.range(of: .day, in: .month, for: referenceDate) else { return [] }
        var comps = cal.dateComponents([.year, .month], from: referenceDate)
        return range.compactMap { dayNum -> HistoriqueDay? in
            comps.day = dayNum
            guard let date = cal.date(from: comps) else { return nil }
            let dayStart = cal.startOfDay(for: date)
            return day(for: date, dayStart: dayStart, todayStart: todayStart, today: today)
        }
    }

    // MARK: - Private factory

    /// Decides which data to use for a given `date`:
    /// - past (< today)  → deterministic fake data
    /// - today (== today) → real `TodayData` (zeros if nil)
    /// - future (> today) → zeros (empty bar, x-axis label visible)
    private static func day(for date: Date,
                             dayStart: Date,
                             todayStart: Date,
                             today: TodayData?) -> HistoriqueDay {
        if dayStart > todayStart {
            // Future — empty
            return HistoriqueDay(date: date, calorieTotale: 0, calorieBrulee: 0,
                                 proteine: 0, lipide: 0, glucide: 0,
                                 activitesCount: 0, repasCount: 0)
        }
        if dayStart == todayStart {
            // Today — real user entries (or zeros if nothing logged yet)
            let t = today ?? TodayData(calorieTotale: 0, calorieBrulee: 0,
                                       proteine: 0, lipide: 0, glucide: 0,
                                       activitesCount: 0, repasCount: 0)
            return HistoriqueDay(date: date,
                                 calorieTotale: t.calorieTotale,
                                 calorieBrulee: t.calorieBrulee,
                                 proteine: t.proteine,
                                 lipide: t.lipide,
                                 glucide: t.glucide,
                                 activitesCount: t.activitesCount,
                                 repasCount: t.repasCount)
        }
        // Past — deterministic fake data
        var gen = SeededGenerator(seed: daySeed(for: date))
        return HistoriqueDay(
            date: date,
            calorieTotale:  Double.random(in: 1500...2400, using: &gen),
            calorieBrulee:  Double.random(in: 200...700,   using: &gen),
            proteine:       Double.random(in: 60...150,    using: &gen),
            lipide:         Double.random(in: 40...90,     using: &gen),
            glucide:        Double.random(in: 150...320,   using: &gen),
            activitesCount: Int.random(in: 0...3,          using: &gen),
            repasCount:     Int.random(in: 2...5,          using: &gen)
        )
    }

    /// Deterministic seed: year × 10 000 + month × 100 + day
    static func daySeed(for date: Date) -> UInt64 {
        let cal = Calendar.current
        let y = UInt64(cal.component(.year,  from: date))
        let m = UInt64(cal.component(.month, from: date))
        let d = UInt64(cal.component(.day,   from: date))
        return y * 10_000 + m * 100 + d
    }
}

// MARK: - Reproducible random source

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0xDEADBEEF : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

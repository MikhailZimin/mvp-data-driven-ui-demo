typealias Command = CommandWith<Void>

struct CommandWith<T> {
    private var action: (T) -> Void

    static var nop: CommandWith { return CommandWith { _ in } }

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    func execute(with value: T) {
        self.action(value)
    }
}

extension CommandWith where T == Void {
    func execute() {
        self.execute(with: ())
    }
}

extension CommandWith {
    func bind(to value: T) -> Command {
        return Command { self.execute(with: value) }
    }

    func map<U>(block: @escaping (U) -> T) -> CommandWith<U> {
        return CommandWith<U> { self.execute(with: block($0)) }
    }
}

extension CommandWith: Codable {
    private static var currentType: String {
        return T.self == Void.self
        ? "Command"
        : String(describing: CommandWith.self)
    }

    enum CodingError: Error { case decoding(String) }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let descriptor = try container.decode(String.self)
        guard CommandWith.currentType == descriptor else {
            throw CodingError.decoding("Decoding Failed. Expected: \(CommandWith.currentType). Received \(descriptor)")
        }
        self = .nop
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(CommandWith.currentType)
    }
}

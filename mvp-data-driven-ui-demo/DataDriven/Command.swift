struct CommandWith<T> {
    private var action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    func execute(with value: T) {
        action(value)
    }
}

typealias Command = CommandWith<Void>

extension CommandWith where T == Void {
    func execute() {
        execute(with: ())
    }
}

protocol DataDrivenModel { }

protocol DataDrivable: AnyObject {
    func render(model: DataDrivenModel)
}

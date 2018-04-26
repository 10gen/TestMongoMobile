import Foundation
import MongoMobile

class ToDoListItem {
    //MARK: Properties
    var id: ObjectId?
    var name: String = ""
    var completed: Bool = false
    
    //MARK: Initialization
    init() {}
    
    init(withDocument: Document) throws {
        self.id = withDocument["_id"] as? ObjectId
        self.name = withDocument["name"] as! String
        self.completed = withDocument["completed"] as! Bool
    }
    
    init(id: ObjectId, name: String) {
        self.id = id
        self.name = name
    }
    
    //MARK: DB Operations
    func save() throws {
        try? globalToDoList.save(todo:self)
    }
    
    func updateCompleted(completed: Bool) {
        self.completed = completed

        do {
            try self.save()
        } catch {
            self.completed = !completed
            print("error saving: \(error)")
        }
    }
}

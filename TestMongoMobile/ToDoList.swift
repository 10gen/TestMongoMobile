
import MongoMobile

let globalToDoList = try! ToDoList()

class ToDoList {
    var client: MongoClient
    
    init() throws {
        MongoMobile.initialize()
        let settings = MongoClientSettings(dbPath: "test-mongo-mobile")
        self.client = try MongoMobile.create(settings)
    }
    
    deinit {
        MongoMobile.close()
    }
    
    func allTasks() throws -> [ToDoListItem] {
        let docs = try client.db("todo_app").collection("tasks").find()
        return try docs.map { try ToDoListItem(withDocument: $0) }
    }
    
    func save(todo: ToDoListItem) throws {
        let todoAsDocument: Document = [
            "name": todo.name,
            "completed": todo.completed
        ]
        
        if let id = todo.id {
            do {
                let result = try client.db("todo_app").collection("tasks")
                    .replaceOne(filter: [ "_id": id ] as Document, replacement: todoAsDocument)
                print(result!)
            } catch {
                print("update error: \(error)")
            }
            
            return;
        }
            
        // Otherwise insert
        do {
            let result = try client.db("todo_app").collection("tasks").insertOne(todoAsDocument)
            todo.id = result?.insertedId as? ObjectId
            print(result!)
        } catch {
            print("insert error: \(error)")
        }
    }
}

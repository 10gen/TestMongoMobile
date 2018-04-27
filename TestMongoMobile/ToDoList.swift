
import MongoMobile

let globalToDoList = ToDoList()

class ToDoList {
    var client: MongoClient
    
    init() {
        do {
            MongoMobile.initialize()
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            let settings = MongoClientSettings(dbPath: documentPath.stringByAppendingPathComponent("test-mongo-mobile"))
            self.client = try MongoMobile.create(settings)
        } catch {
            print("ToDoList initialization error: \(error)")
        }
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

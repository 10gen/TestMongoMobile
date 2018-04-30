
import MongoMobile

let globalToDoList = ToDoList()

class ToDoList {
    var _client: MongoClient?
    
    init() {
        do {
            // determine dbPath
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let databasePath = documentPath.appendingPathComponent("test-mongo-mobile")

            // create path if it doesn't exist
            do {
                try FileManager.default.createDirectory(at: databasePath, withIntermediateDirectories: false)
            } catch {
                print("couldn't create database path: \(error)");
            }
            
            // initialize
            MongoMobile.initialize()
            let settings = MongoClientSettings(dbPath: databasePath.path)
            self._client = try MongoMobile.create(settings)
        } catch {
            print("ToDoList initialization error: \(error)")
        }
    }
    
    deinit {
        MongoMobile.close()
    }
    
    func allTasks() throws -> [ToDoListItem] {
        guard let client = _client else {
            return []
        }
        
        let docs = try client.db("todo_app").collection("tasks").find()
        return try docs.map { try ToDoListItem(withDocument: $0) }
    }
    
    func save(todo: ToDoListItem) throws {
        guard let client = self._client else {
            print("no client available")
            return
        }
        
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

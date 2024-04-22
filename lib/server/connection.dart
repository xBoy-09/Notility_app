// username : 24100300
import 'package:notility/server/chatgpt.dart';

final MONGO_CONN_URL = "mongodb+srv://24100300:$password@notility.6etpenf.mongodb.net/Notility-Data?retryWrites=true&w=majority&appName=Notility";
const USER_COLLECTION = "UserBase";
const NOTES_COLLECTION = "Notes";
const NOTEBOOK_COLLECTION = "NoteBooks";
const USERSHARE_COLLECTION = "Users";


// mongo mongodb+srv://24100300:STdhdr2mOEFEFv7W@notility.6etpenf.mongodb.net/Notility-Data?retryWrites=true&w=majority&appName=Notility

//mongo "mongodb+srv://notility.6etpenf.mongodb.net/Notility-Data" --username 24100300


//db.NoteBooks.deleteMany({ name: { $in: ["My Notebook", "General"] } })

// db.Notes.deleteMany({ heading: "Welcome" })

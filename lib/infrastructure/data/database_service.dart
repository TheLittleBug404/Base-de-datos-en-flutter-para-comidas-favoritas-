import 'package:data_base_app/infrastructure/models/comida_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  //aca tiene que estar todos mis metodos de mi base de datos
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    //direccion de mi base de datos en mi celular
    String path = join(await getDatabasesPath(), 'comidas_favoritas.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //crear nuestra base de datos
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE comidas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          plato TEXT NOT NULL,
          tipo TEXT NOT NULL,
          pais TEXT NOT NULL,
          calificacion INTEGER NOT NULL,
          descripcion TEXT
        );
      ''');
    await db.execute('''
      CREATE TABLE precio(
        id INTEGER PRIMARY KEY,
        precio INTEGER NOT NULL,
        FOREIGN KEY (id) REFERENCES comidas(id) ON DELETE CASCADE
      );
    ''');
  }

  // CRUD OPERACIONES
  Future<int> insertComida(Comida comida) async {
    Database db = await database;
    return await db.insert('comidas', comida.toMap());
  }

  //read all select * from comidas
  Future<List<Comida>> getAllComidas() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('comidas');
    return List.generate(maps.length, (i) {
      return Comida.fromMap(maps[i]);
    });
  }

  //read one
  Future<Comida?> getComidaById(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'comidas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Comida.fromMap(maps.first);
    }
    return null;
  }
  //update
  Future<int> updateComida(Comida comida)async{
    Database db = await database;
    return await db.update(
      'comidas', 
      comida.toMap(),
      where: 'id = ?',
      whereArgs: [comida.id],
    );
  }
  //delete
  Future<int> deleteComida(int id) async {
    Database db = await database;
    return await db.delete('comidas', where: 'id = ?', whereArgs: [id]);
  }
  //delete all
  Future<void> deleteAllComidas() async{
    Database db = await database;
    await db.delete('comidas');
  }
}

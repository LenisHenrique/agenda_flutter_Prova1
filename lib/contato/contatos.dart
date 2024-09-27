import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String contactTable = "contactTable";
const String idColumn = "idColumn";
const String nameColumn = "nomeColumn";
const String emailColumn = "emailColumn";
const String phoneColumn = "telefoneColumn";
const String imgColumn = "imgColumn";

//estrutura de banco de daodos criando uma tabela de contatos para id, nome, email, telefone e imagem
class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  late Database _db;

  Future<Database> get db async {
    return _db;
    }

  Future<Database> initDb() async {//funcao que localiza ou cria o arquivo do bd que chamei de contacts
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
            "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
      },
    );
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int id) async {//retorna um contato
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {// remove o contato
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {//modifica as infos de um contato que ja existe
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContacts() async {//retorna uma lista de todos os contatos salvs
    Database dbContact = await db;
    List<Map<String, dynamic>> listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = listMap.map((m) => Contact.fromMap(m)).toList();
    return listContact;
  }

  Future<int?> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {//essa funcao fecha a conexao com o bd
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? img;

  Contact();

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    nome = map[nameColumn];
    email = map[emailColumn];
    telefone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      nameColumn: nome,
      emailColumn: email,
      phoneColumn: telefone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, nome: $nome, email: $email, telefone: $telefone, img: $img)";
  }
}

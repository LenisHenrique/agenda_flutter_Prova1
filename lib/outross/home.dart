import 'dart:io';
import 'package:flutter/material.dart';
import '../contato/contatos.dart';
import 'contato_pags.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                value: OrderOptions.orderaz,
                child: Text("Ordenar de A-Z"),
              ),
              const PopupMenuItem(
                value: OrderOptions.orderza,
                child: Text("Ordenar de Z-A"),
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: contacts[index].img != null
                      ? FileImage(File(contacts[index].img!))
                      : const AssetImage("images/person.jpg") as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].nome ?? "",
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contacts[index].telefone ?? "",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse("tel:${contacts[index].telefone}"));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Ligar",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                      child: const Text(
                        "Editar",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        helper.deleteContact(contacts[index].id!);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(contact: contact),
      ),
    );
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    setState(() {
      if (result == OrderOptions.orderaz) {
        contacts.sort((a, b) => a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
      } else {
        contacts.sort((a, b) => b.nome!.toLowerCase().compareTo(a.nome!.toLowerCase()));
      }
    });
  }

  void launchUrl(Uri parse) {}
}

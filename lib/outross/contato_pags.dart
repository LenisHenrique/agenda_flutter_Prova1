import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../contato/contatos.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({super.key, this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  late Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact.nome ?? '';
      _emailController.text = _editedContact.email ?? '';
      _phoneController.text = _editedContact.telefone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //prof se eu colocar o PopScope, ele da erro e eu nao consigo mudar este erro, então estou usando o WillPopScope que ja esta obsoleto mas funcionou
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(_editedContact.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.nome != null && _editedContact.nome!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img!))
                          : const AssetImage("images/person.jpg") as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? file = await picker.pickImage(source: ImageSource.camera);
                  if (file == null) return;
                  setState(() {
                    _editedContact.img = file.path;
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.nome = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.telefone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() async {
    if (_userEdited) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar Alteraçōes?"),
            content: const Text("Se sair as alteraçōes serão perdidas."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Sim"),
              ),
            ],
          );
        },
      );
      return result ?? false;
    } else {
      return true;
    }
  }
}

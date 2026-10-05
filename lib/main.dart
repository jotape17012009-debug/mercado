import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaLista(),
    );
  }
}

// Modelo Item
class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({required this.nome, required this.quantidade, this.comprado = false});
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // Lista de itens
  List<Item> itens = [];

  // Abre a tela de adicionar
  Future<void> abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaAdicionarItem()),
    );

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoItem.nome} adicionado à lista!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Remove um item
  void removerItem(int indice) {
    final String nomeItem = itens[indice].nome;

    setState(() {
      itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nomeItem removido da lista!'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int itensComprados = itens.where((item) => item.comprado).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,

        title: const Row(
          children: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 10),
            Text(
              'Lista de Compras',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              '$itensComprados de ${itens.length} comprados',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),

      body: itens.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 90,
                    color: Colors.deepPurple.shade200,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Sua lista está vazia!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Toque no botão + para adicionar um item.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: itens.length,

              itemBuilder: (context, indice) {
                final item = itens[indice];

                return Card(
                  color: item.comprado ? Colors.green.shade50 : Colors.white,

                  elevation: 3,

                  margin: const EdgeInsets.only(bottom: 10),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),

                    leading: Checkbox(
                      activeColor: Colors.green,
                      value: item.comprado,

                      onChanged: (valor) {
                        setState(() {
                          item.comprado = valor ?? false;
                        });
                      },
                    ),

                    title: Text(
                      item.nome,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,

                        color: item.comprado ? Colors.grey : Colors.deepPurple,

                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.numbers,
                          size: 16,
                          color: Colors.orange,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          'Quantidade: ${item.quantidade}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),

                      onPressed: () {
                        removerItem(indice);
                      },
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,

        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        elevation: 6,

        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  // Controllers
  final TextEditingController nomeController = TextEditingController();

  final TextEditingController quantidadeController = TextEditingController();

  // Salvar item
  void salvar() {
    String nome = nomeController.text.trim();

    String quantidadeTexto = quantidadeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome do item!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    int quantidade = int.tryParse(quantidadeTexto) ?? 1;

    Item novoItem = Item(nome: nome, quantidade: quantidade);

    Navigator.pop(context, novoItem);
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        title: const Row(
          children: [
            Icon(Icons.add_shopping_cart),
            SizedBox(width: 10),
            Text('Novo Item', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Ícone
            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.shopping_basket,
                size: 45,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 25),

            // Nome
            TextField(
              controller: nomeController,

              decoration: InputDecoration(
                labelText: 'Nome do Item',
                hintText: 'Ex: Arroz',

                prefixIcon: const Icon(
                  Icons.shopping_bag,
                  color: Colors.deepPurple,
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quantidade
            TextField(
              controller: quantidadeController,

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: 'Quantidade',
                hintText: 'Ex: 2',

                prefixIcon: const Icon(Icons.numbers, color: Colors.orange),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botão salvar
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: salvar,

                icon: const Icon(Icons.save),

                label: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

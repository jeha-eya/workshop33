import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'queue_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QueueProvider(),
      child: const WaitingRoomApp(),
    ),
  );
}

class WaitingRoomApp extends StatelessWidget {
  const WaitingRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WaitingRoomScreen(),
    );
  }
}

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Écoute les changements de la liste des clients
    final queueProvider = context.watch<QueueProvider>();
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Waiting Room'),
        actions: [
          IconButton(
            key: const Key('nextClientButton'),
            icon: const Icon(Icons.skip_next),
            tooltip: 'Next Client',
            onPressed: () {
              // Appelle nextClient sans écouter les changements
              context.read<QueueProvider>().nextClient();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Client Name'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('addButton'),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      // Ajoute un client via Provider
                      context.read<QueueProvider>().addClient(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Clients in Queue: ${queueProvider.clients.length}'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: queueProvider.clients.length,
                itemBuilder: (context, index) {
                  final clientName = queueProvider.clients[index];
                  return Card(
                    child: ListTile(
                      title: Text(clientName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<QueueProvider>().removeClient(clientName);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

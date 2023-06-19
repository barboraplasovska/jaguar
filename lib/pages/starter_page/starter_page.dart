import 'package:flutter/material.dart';
import 'package:pingfrontend/pages/code_editor/code_editor_page.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Welcome to our super chuper IDE."),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CodeEditorPage(),
                    ),
                  )
                },
                child: const Text("Open the editor"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

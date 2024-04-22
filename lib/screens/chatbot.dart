import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notility/server/chatgpt.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class ChatbotMode extends StatefulWidget {
  final String content;
  const ChatbotMode({super.key, required this.content});

  @override
  State<ChatbotMode> createState() => _ChatbotModeState();
}

class _ChatbotModeState extends State<ChatbotMode> {
  late OpenAI openAI;
  final TextEditingController responseController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  List<String> queries = [];
  List<String> responses = [];

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
        token: token,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 25)),
        enableLog: true);
  }

  void chatComplete() async {
    String query = contentController.text;
    queries.add(query);

    String contento = widget.content + query;
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": contento}),
    ], maxToken: 3000, model: GptTurbo0301ChatModel());

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      String responseMessage = element.message?.content ?? '';
      responses.add(responseMessage);
      responseController.text = responseMessage;
    }
    contentController.text = '';

    // Limit the list size to a fixed number (e.g., 10)
    if (queries.length > 10) {
      queries.removeAt(0);
      responses.removeAt(0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 48,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
        // Pressing the back button
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
        leadingWidth: 48, // Size after leading
        titleSpacing: 0, // Size before text
        title: Text(
          "Ask GPT",
          style: TextStyle(fontSize: 20, color: Colors.grey[700]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chatComplete();
        },
        child: const Icon(Icons.send),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: queries.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: queries[index]));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Query copied to clipboard'),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[800],
                      ),
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Query:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          SelectableText(
                            queries[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Response:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(
                                  ClipboardData(text: responses[index]));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Response copied to clipboard'),
                              ));
                            },
                            child: SelectableText(
                              responses[index],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320.0,
                  child: TextField(
                    maxLines: null,
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: 'Enter your query',
                      hintStyle: TextStyle(color: Colors.grey[700]!),
                      border: const OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

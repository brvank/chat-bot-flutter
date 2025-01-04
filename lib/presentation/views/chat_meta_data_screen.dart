import 'package:chatbot/data/bloc/loader_bloc.dart';
import 'package:chatbot/data/model/chat_meta_data.dart';
import 'package:chatbot/presentation/controller/chat_meta_data_controller.dart';
import 'package:chatbot/presentation/views/chat_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMetaDataScreen extends StatefulWidget {
  const ChatMetaDataScreen({super.key});

  @override
  State<ChatMetaDataScreen> createState() => _ChatMetaDataScreenState();
}

class _ChatMetaDataScreenState extends State<ChatMetaDataScreen> {
  late ChatMetaDataController _chatMetaDataController;
  List<ChatMetaData> metaDataList = [];

  @override
  void initState() {
    super.initState();

    setup();
  }

  setup() async {
    _chatMetaDataController = ChatMetaDataController();
    await _chatMetaDataController.appDataBaseImpl.init();
    metaDataList = await _chatMetaDataController.getAllMetadata();

    setState(() {});
  }

  refresh() async {
    metaDataList = await _chatMetaDataController.getAllMetadata();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter GPT"),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatDataScreen(
                        metaData: ChatMetaData(-1, 'Untitled'),
                      ))).then((res) {
            refresh();
          });
        },
        child: const Icon(Icons.face),
      ),
    );
  }

  Widget body() {
    return BlocProvider<LoaderBloc>(
      create: (context) {
        return _chatMetaDataController.loaderBloc;
      },
      child: BlocBuilder<LoaderBloc, bool>(
        builder: (context, state) {
          if (state) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: metaDataList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            metaDataList[index].title,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Delete ${metaDataList[index].title}?",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await _chatMetaDataController
                                                .deleteChatMetaData(
                                                    metaDataList[index]);
                                            if(mounted){
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              refresh();
                                            }
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatDataScreen(
                                    metaData: metaDataList[index],
                                  ))).then((res) {
                        refresh();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

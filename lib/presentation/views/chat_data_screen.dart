import 'package:chatbot/data/bloc/loader_bloc.dart';
import 'package:chatbot/data/model/chat_data.dart';
import 'package:chatbot/data/model/chat_meta_data.dart';
import 'package:chatbot/presentation/controller/chat_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDataScreen extends StatefulWidget {
  final ChatMetaData metaData;
  const ChatDataScreen({super.key, required this.metaData});

  @override
  State<ChatDataScreen> createState() => _ChatDataScreenState();
}

class _ChatDataScreenState extends State<ChatDataScreen> {
  late ChatDataController _chatDataController;
  List<ChatData> chatDataList = [];
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  late TextEditingController _metaDataTextController;

  @override
  void initState() {
    super.initState();
    _chatDataController = ChatDataController();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _metaDataTextController =
        TextEditingController(text: widget.metaData.title);

    setup();
  }

  setup() async {
    await _chatDataController.appDataBaseImpl.init();
    if (widget.metaData.id == -1) {
      widget.metaData.id =
          await _chatDataController.addChatMetaData(widget.metaData.title);
    } else {
      chatDataList =
          await _chatDataController.getAllChatData(widget.metaData.id!);
    }

    setState(() {});
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
            child: Text(widget.metaData.title),
            onTap: () {
              titleChangeDialog();
            },
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back))),
      body: body(),
    );
  }

  Widget body() {
    return BlocProvider<LoaderBloc>(
      create: (context) {
        return _chatDataController.loaderBloc;
      },
      child: BlocBuilder<LoaderBloc, bool>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                  flex: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.builder(
                          controller: _scrollController,
                          itemCount: chatDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment:
                                  chatDataList[index].owner == ChatData.bot
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.7),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: chatDataList[index].owner ==
                                              ChatData.bot
                                          ? Colors.purpleAccent
                                          : Colors.deepPurpleAccent,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    child: Text(
                                      chatDataList[index].data,
                                      style: const TextStyle(color: Colors.white),
                                    )),
                              ),
                            );
                          });
                    },
                  )),
              Container(
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12))),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                            hintText: 'Enter you questions here...',
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w200),
                            border: InputBorder.none),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          if (state || _textEditingController.text.isEmpty) {
                            return;
                          }
                          var res = await _chatDataController
                              .sendQuery(_textEditingController.text);
                          if (res != null) {
                            //add to list view
                            ChatData promptData = ChatData(
                                null,
                                _textEditingController.text,
                                widget.metaData.id!,
                                ChatData.user);
                            ChatData responseData = ChatData(
                                null, res, widget.metaData.id!, ChatData.bot);

                            chatDataList.add(promptData);
                            chatDataList.add(responseData);

                            //add to db
                            _chatDataController.addChatData(promptData);
                            _chatDataController.addChatData(responseData);

                            _textEditingController.text = '';
                            setState(() {});
                            scrollToBottom();
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Something went wrong! Please retry.",
                              ),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        },
                        child: state
                            ? const Text('Please Wait ...')
                            : const Text('Send'))
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void titleChangeDialog() {
    _metaDataTextController.text = widget.metaData.title;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    "Give this chat a name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _metaDataTextController,
                  decoration:
                      const InputDecoration(hintText: "Your title here"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_metaDataTextController.text.isEmpty) return;
                  widget.metaData.title = _metaDataTextController.text;
                  await _chatDataController.updateChatMetaData(widget.metaData);
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    setState(() {});
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}

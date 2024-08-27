import 'package:flutter/material.dart';
import 'package:handees/shared/res/shapes.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  const SearchWidget({Key? key, required this.onSearch}) : super(key: key);
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final focusNode = FocusNode();
  final textController = TextEditingController();
  bool isFocused = false;

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 32.0,
    );

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = !isFocused;

        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        setState(() {
          isFocused = false;
        });

        return shouldPop;
      },
      child: Material(
        elevation: 4.0,
        shadowColor: Theme.of(context).colorScheme.shadow,
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: Shapes.bigShape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64.0),
          child: isFocused
              ? Padding(
                  padding: padding,
                  child: TextField(
                    focusNode: focusNode,
                    controller: textController,
                    onChanged: widget.onSearch,
                    onEditingComplete: () {
                      setState(() {
                        isFocused = false;
                        focusNode.unfocus();
                      });
                    },
                    cursorColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      suffixIcon: IconButton(
                        onPressed: () {
                          textController.clear();
                        },
                        icon: Icon(
                          Icons.close,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      isFocused = true;
                      focusNode.requestFocus();
                    });
                  },
                  customBorder: Shapes.bigShape,
                  child: Padding(
                    padding: padding,
                    child: Row(
                      children: [
                        const Spacer(flex: 5),
                        Expanded(
                          flex: 9,
                          child: Text(
                            'Need a hand?',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        Icon(
                          Icons.search,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

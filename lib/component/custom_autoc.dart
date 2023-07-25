import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:free_place_search/core/api.dart';
import 'package:free_place_search/models/address.dart';

class SearchWidget extends StatefulWidget {
  final bool isPopup;
  final bool autoFocus;
  final InputDecoration? decoration;
  final void Function(SearchInfo) onDone;
  final int suggestionLimit;
  final int minLengthToStartSearch;

  const SearchWidget(
      {Key? key,
      required this.onDone,
      this.isPopup = false,
      this.autoFocus = false,
      this.decoration,
      this.suggestionLimit = 5,
      this.minLengthToStartSearch = 3})
      : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = const Key("streamAddressSug");
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSearchableTextChanged(String v) async {
    if (v.length > widget.minLengthToStartSearch && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: widget.suggestionLimit,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: TextFormField(
                controller: controller,
                enableInteractiveSelection: false,
                onChanged: onSearchableTextChanged,
                autofocus: widget.autoFocus,
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: widget.isPopup
                      ? IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                          ))
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                  contentPadding: const EdgeInsets.all(5),
                  hintText: "Type City Name",
                  hintStyle: TextStyle(fontFamily: "Poppins"),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  focusColor: Colors.white,
                )),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: notifierAutoCompletion,
            builder: (ctx, isVisible, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: isVisible
                    ? widget.isPopup
                        ? MediaQuery.of(context).size.height / 3
                        : MediaQuery.of(context).size.height / 4
                    : 0,
                child: Card(
                  elevation: 0,
                  child: child!,
                ),
              );
            },
            child: StreamBuilder<List<SearchInfo>>(
              stream: streamSuggestion.stream,
              key: streamKey,
              builder: (ctx, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              snap.data![index].address.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                            onTap: () async {
                              controller.text =
                                  snap.data![index].address.toString();
                              log(snap.data![index].address.toString());
                              widget.onDone(snap.data![index]);

                              /// hide suggestion card
                              notifierAutoCompletion.value = false;
                              await reInitStream();
                              FocusScope.of(context).requestFocus(
                                FocusNode(),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Divider(
                              height: 0.5,
                              thickness: 0.5,
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: snap.data!.length,
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return Card(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum Mode { overlay, fullscreen }

class placeAutocomplete {
  static show(
      {required BuildContext context,
      Mode mode = Mode.overlay,
      final bool autoFocus = false,
      final InputDecoration? textfieldDecoration,
      final Decoration? containerDecoration,
      final int suggestionLimit = 3,
      final int minLengthToStartSearch = 3,
      final EdgeInsetsGeometry? borderPadding,
      required Function(SearchInfo) onDone}) {
    // ignore: prefer_function_declarations_over_variables
    final builder = (BuildContext ctx) => Scaffold(
        backgroundColor: Colors.red,
        body: Padding(
          padding: borderPadding ?? const EdgeInsets.all(20.0),
          child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: SearchWidget(
                onDone: onDone,
                suggestionLimit: suggestionLimit,
                minLengthToStartSearch: minLengthToStartSearch,
                isPopup: mode == Mode.overlay,
                autoFocus: autoFocus,
                decoration: textfieldDecoration,
              )),
        ));
    if (mode == Mode.overlay) {
      return showDialog(context: context, builder: builder);
    } else {
      return Navigator.push(context, MaterialPageRoute(builder: builder));
    }
  }

  static widget({
    required Function(SearchInfo) onDone,
    final bool autoFocus = false,
    final InputDecoration? textfieldDecoration,
    final int suggestionLimit = 3,
    final int minLengthToStartSearch = 3,
  }) {
    return SearchWidget(
      onDone: onDone,
      isPopup: false,
      autoFocus: autoFocus,
      decoration: textfieldDecoration,
      suggestionLimit: suggestionLimit,
      minLengthToStartSearch: minLengthToStartSearch,
    );
  }
}

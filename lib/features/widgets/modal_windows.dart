import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/data/utils/validation.dart';

class ModalWindows {
  void showAddFileBottomSheet(
      BuildContext context, Function(String url) onResult) {
    final UrlFileValidator urlFileValidator =
        UrlFileValidator('error_url_validation'.tr(), 'pdf');
    final StreamController<bool> controller =
        StreamController<bool>.broadcast();
    String returnedUrl = '';
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: Color.fromRGBO(245, 245, 245, 1),
            boxShadow: [
              BoxShadow(color: Colors.white12, spreadRadius: 0.1, blurRadius: 2)
            ],
          ),
          clipBehavior: Clip.antiAlias,
          height: 230 + MediaQuery.of(context).viewInsets.bottom,
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.center,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.black26,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white12,
                          spreadRadius: 0.1,
                          blurRadius: 2)
                    ],
                  ),
                  child: SizedBox(
                    height: 6,
                    width: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'add_file'.tr(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      onChanged: (value) {
                        returnedUrl = value;
                        controller.add(urlFileValidator.isValid(value));
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: urlFileValidator,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'url'.tr(),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black26,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 38,
                      width: double.infinity,
                      child: StreamBuilder(
                        stream: controller.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          return ElevatedButton(
                            onPressed: (snapshot.data != null && snapshot.data!)
                                ? () {
                                    onResult(returnedUrl);
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context).pop();
                                  }
                                : null,
                            child: Text('add_file'.tr()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

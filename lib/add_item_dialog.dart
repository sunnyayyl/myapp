import 'package:flutter/material.dart';
import 'package:myapp/menu_data.dart';

import 'extra_manager.dart';

Future<RecipeItem> addMenuItemDialog(
    BuildContext context, MenuEquivalent menuEquivalent) async {
  final TextEditingController catagoryController = TextEditingController();
  final TextEditingController varientController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  ExtraMenuManager manager = ExtraMenuManager();
  manager.reset();
  return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              bool allowConfirmation =
                  !(menuEquivalent[catagoryController.text] == null ||
                          menuEquivalent[catagoryController.text]![
                                  varientController.text] ==
                              null) &&
                      !manager.extras.contains(InvalidExtra());
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: allowConfirmation
                        ? () => setState(() {
                              RecipeItem selectedItem = RecipeItem(
                                menuItemName: catagoryController.text,
                                varientName: varientController.text,
                                extras: manager.extras
                                    .map((e) => (e as Extra).name)
                                    .toList(),
                                notes: noteController.text.isEmpty
                                    ? null
                                    : noteController.text,
                              );
                              Navigator.pop(context, selectedItem);
                            })
                        : null,
                    child: Text("Confirm"),
                  )
                ],
                title: const Text("Add menu item"),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    children: [
                      DropdownMenu(
                        onSelected: (value) => setState(
                          () {
                            varientController.text = "";
                            manager.reset();
                          },
                        ),
                        controller: catagoryController,
                        label: const Text("Food catagory"),
                        expandedInsets: const EdgeInsets.all(0),
                        dropdownMenuEntries: menuEquivalent.keys
                            .map((e) => DropdownMenuEntry(value: e, label: e))
                            .toList(),
                      ),
                      Builder(
                        builder: (context) {
                          if (menuEquivalent[catagoryController.text] == null) {
                            return Container();
                          } else {
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: DropdownMenu(
                                onSelected: (value) => setState(
                                  () => manager.reset(),
                                ),
                                controller: varientController,
                                expandedInsets: const EdgeInsets.all(0),
                                label: const Text("Varient"),
                                dropdownMenuEntries:
                                    menuEquivalent[catagoryController.text]!
                                        .keys
                                        .map((e) => DropdownMenuEntry(
                                            value: e, label: e))
                                        .toList(),
                              ),
                            );
                          }
                        },
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: manager.extras.length + 1 + 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index < manager.extras.length + 1) {
                            if (menuEquivalent[catagoryController.text] ==
                                    null ||
                                menuEquivalent[catagoryController.text]![
                                        varientController.text] ==
                                    null) {
                              return Container();
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: DropdownMenu(
                                  errorText:
                                      menuEquivalent[catagoryController.text]![
                                                              varientController
                                                                  .text]!
                                                          .extras[
                                                      manager
                                                          .extraControllers[
                                                              index]
                                                          .text] !=
                                                  null ||
                                              manager.extraControllers[index]
                                                  .text.isEmpty
                                          ? null
                                          : "Invalid extra",
                                  label: const Text("Extras"),
                                  expandedInsets: const EdgeInsets.all(0),
                                  controller: manager.extraControllers[index],
                                  onSelected: (value) => setState(
                                    () => manager.update(
                                      index,
                                      menuEquivalent[catagoryController.text]![
                                              varientController.text]!
                                          .extras,
                                    ),
                                  ),
                                  dropdownMenuEntries: manager
                                          .getFilteredExtras(menuEquivalent[
                                                      catagoryController.text]![
                                                  varientController.text]!
                                              .extras)
                                          .keys
                                          .map((e) => DropdownMenuEntry(
                                              value: e, label: e))
                                          .toList() +
                                      [
                                        const DropdownMenuEntry(
                                            value: "", label: "")
                                      ],
                                ),
                              );
                            }
                          } else if (index == manager.extras.length + 1) {
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: noteController,
                                decoration: const InputDecoration(
                                    label: Text("Notes"),
                                    border: OutlineInputBorder()),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ) ??
      () {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("Unexpected error"),
          ),
        );
      }();
}

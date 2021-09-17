import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:settings/view/pages/menu_items.dart';
import 'package:settings/view/widgets/detail_page.dart';
import 'package:settings/view/widgets/detail_route.dart';
import 'package:settings/view/widgets/menu_item.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({Key? key}) : super(key: key);

  @override
  MasterPageState createState() => MasterPageState();
}

class MasterPageState extends State<MasterPage> {
  late MenuItem selectedMenuItem;
  late TextEditingController searchController;
  late ItemScrollController scrollController;

  @override
  void initState() {
    super.initState();
    selectedMenuItem = menuItems.first;
    searchController = TextEditingController();
    scrollController = ItemScrollController();
    Future.microtask(() => {goToDetail(menuItems.indexOf(selectedMenuItem))});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final filteredItems = <MenuItem>[];

    void filterItems() {
      filteredItems.clear();
      for (MenuItem menuItem in menuItems) {
        if (menuItem.name
            .toLowerCase()
            .contains(searchController.value.text.toLowerCase())) {
          filteredItems.add(menuItem);
        }
      }
    }

    filterItems();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          searchController.clear();
          filterItems();
          showDialog(
              useSafeArea: true,
              context: context,
              builder: (_) => StatefulBuilder(builder: (context, setState) {
                    return SingleChildScrollView(
                      child: AlertDialog(
                        title: const Text('Search'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextField(
                                onChanged: (value) {
                                  filterItems();
                                  setState(() {});
                                },
                                controller: searchController,
                                autofocus: true,
                              ),
                            ),
                            SizedBox(
                              height: height / 2,
                              width: 300,
                              child: ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        leading: Icon(
                                          filteredItems[index].iconData,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.8),
                                        ),
                                        selected: filteredItems[index] ==
                                            selectedMenuItem,
                                        title: Text(
                                          filteredItems[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                        ),
                                        onTap: () {
                                          final tappedItem =
                                              filteredItems[index];
                                          late int matchedIndex;
                                          for (var menuItem in menuItems) {
                                            if (menuItem.name ==
                                                tappedItem.name) {
                                              matchedIndex =
                                                  menuItems.indexOf(menuItem);
                                            }
                                          }
                                          goToDetail(matchedIndex);
                                          setState(() {});
                                        });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    );
                  })).then((value) => setState(() {
                scrollController.scrollTo(
                    index: menuItems.indexOf(selectedMenuItem),
                    duration: const Duration(seconds: 1));
                // scrollController.jumpTo(value);
              }));
        },
        child: const Icon(YaruIcons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          child: ScrollablePositionedList.builder(
              itemScrollController: scrollController,
              padding: const EdgeInsets.only(top: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    bottom: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      color: menuItems[index] == selectedMenuItem
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.07)
                          : null,
                    ),
                    child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        leading: Icon(
                          menuItems[index].iconData,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                        selected: menuItems[index] == selectedMenuItem,
                        title: Text(
                          menuItems[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        onTap: () {
                          setState(() => goToDetail(index));
                        }),
                  ),
                );
              }),
        ),
      ),
    );
  }

  void goToDetail(int index) {
    selectedMenuItem = menuItems[index];
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(
      DetailRoute(
        builder: (context) => DetailPage(
          item: selectedMenuItem,
        ),
      ),
    );
  }
}

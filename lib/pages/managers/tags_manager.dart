import 'package:flutter/material.dart';
import 'package:simple_todo/classes/tag.dart';
import 'package:simple_todo/db/tags/tag_dao.dart';
import 'package:simple_todo/pages/tags/edit_tag.dart';
import 'package:simple_todo/pages/tags/new_tag.dart';

import '../../db/tags/tag_controller.dart';
import '../../util/utils_functions.dart';

class TagsManager extends StatefulWidget {
  const TagsManager({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TagsManagerState createState() => _TagsManagerState();
}

class _TagsManagerState extends State<TagsManager> {
  bool loadingTags = true;
  final tags = TagDao.instance;
  List<Map<String, dynamic>> _tagsList = [];

  @override
  void initState() {
    super.initState();
    getTags();
  }

  Future<void> _delete(int idTag) async {
    deleteTag(idTag);
  }

  Future<void> getTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      _tagsList = resp;
      loadingTags = false;
    });
  }

  showAlertDialogOkDelete(BuildContext context, idTag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm",
          ),
          content: const Text(
            "Delete ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () {
                _delete(idTag).then((value) => getTags());
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Tags"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_outlined,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const NewTag(),
                  )).then((value) => getTags());
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        shrinkWrap: true,
        itemCount: _tagsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            leading: Icon(Icons.circle,
                color: parseColorFromDb(_tagsList[index]['color'])),
            title: Text(_tagsList[index]['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tagsList.length > 1
                    ? IconButton(
                        icon: const Icon(
                          Icons.delete_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          showAlertDialogOkDelete(
                              context, _tagsList[index]['id_tag']);
                        })
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 12,
                ),
                IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditTag(
                              tag: Tag(
                                _tagsList[index]['id_tag'],
                                _tagsList[index]['name'],
                                _tagsList[index]['color'],
                              ),
                            ),
                          )).then((value) => getTags());
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}

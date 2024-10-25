// import 'package:flutter/material.dart';
// import 'package:notes/services/crud/notes_service.dart';
// import 'package:notes/utilities/dialogs/delete_dialog.dart';

// typedef NoteCallBack = void Function(DatabaseNote note);

// class NotesListView extends StatelessWidget {
//   final List<DatabaseNote> notes;
//   final NoteCallBack onDeleteNote;
//   final NoteCallBack onTap;

//   const NotesListView({
//     super.key,
//     required this.notes,
//     required this.onDeleteNote,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (context, index) {
//         final note = notes[index];
//         // print(note);
//         return ListTile(
//           onTap: () {
//             onTap(note);
//           },
//           title: Text(
//             note.text,
//             maxLines: 1,
//             softWrap: true,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: IconButton(
//             onPressed: () async {
//               final shouldDelete = await showDeleteDialog(context);
//               if (shouldDelete) {
//                 onDeleteNote(note);
//               }
//             },
//             icon: Icon(Icons.delete),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () {
            onTap(note);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display note text
                Expanded(
                  child: Text(
                    note.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                // Delete button
                IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(note);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

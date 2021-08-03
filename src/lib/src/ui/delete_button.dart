import 'package:flutter/material.dart';

//Creating the Delete Button for the Saved Games Page
//To Do:
//Was only able to figure out how to get delete button to have a pop up function
//Need to figure out how to style it so it looks more like Adobe XD files
//Need to figure out how to list games and put the delete button on the list of games instead

class Delete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        child: Icon(Icons.remove_circle_outline),
        backgroundColor: Colors.red,
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {},
  );
  Widget continueButton = FlatButton(
    child: Text("Delete"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete"),
    content: Text("Are you sure you want to delete this game?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

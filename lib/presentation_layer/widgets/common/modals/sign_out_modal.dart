import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';


void showSignOutDialog(BuildContext context) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
              'Cerrar Sesión',
              style: theme.textTheme.titleMedium!.copyWith(color: theme.primaryColorDark),
        ),
        content: Text(
              '¿Estás seguro de que quieres cerrar sesión?',
              style: theme.textTheme.bodyMedium!.copyWith(color: theme.primaryColorDark),
        ),
        
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async{
              try {
                await Amplify.Auth.signOut();
                Navigator.of(context).pop();
              } catch (e) {
                print('Sign out failed: $e');
              }
            },
            child: Text('Cerrar Sesión', style: TextStyle(color: theme.primaryColor)),
          ),
        ],
      );
    },
  );
}

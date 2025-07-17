// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// SIGN-UP FUNCTION
Future<void> signUpUser(
  BuildContext context,
  String userId,
  String name,
  String password,
) async {
  final supabase = Supabase.instance.client;

  try {
    final int parsedUserId = int.parse(userId);

    final existing = await supabase
        .from('loginandsignup')
        .select()
        .eq('userId', parsedUserId)
        .maybeSingle();

    if (existing != null) {
      Fluttertoast.showToast(
        msg: "User with this ID already exists.",
        backgroundColor: Colors.orange,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    await supabase.from('loginandsignup').insert({
      'userId': parsedUserId,
      'name': name,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    });

    Fluttertoast.showToast(
      msg: "User registered successfully!",
      backgroundColor: Colors.green,
      gravity: ToastGravity.TOP,
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Signup error: ${e.toString()}",
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
    );
  }
}

/// LOGIN FUNCTION
Future<bool> loginUser(
  BuildContext context,
  String userId,
  String password,
) async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from('loginandsignup')
        .select()
        .eq('userId', int.parse(userId))
        .eq('password', password)
        .maybeSingle();

    if (data != null) {
      Fluttertoast.showToast(
        msg: "✅ Login successful!",
        backgroundColor: Colors.green,
        gravity: ToastGravity.TOP,
      );
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "❌ Invalid credentials",
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "🚨 Error: ${e.toString()}",
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
    );
    return false;
  }
}

/// FETCH USER NAME FUNCTION
Future<String?> fetchUserNameById(BuildContext context, String userId) async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from('loginandsignup')
        .select('name')
        .eq('userId', int.parse(userId))
        .maybeSingle();

    if (data != null && data['name'] != null) {
      return data['name'].toString();
    } else {
      print("❌ No user found for userId: $userId");
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "🚨 Error: ${e.toString()}",
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
    );
    return null;
  }
}

Future<bool> checkforcontent(BuildContext context, String userId) async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from('datatable')
        .select('content')
        .eq('userId', int.parse(userId))
        .maybeSingle();

    if (data != null &&
        data['content'] != null &&
        data['content'].toString().trim().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error checking for content: $e');
    return false;
  }
}

Future<List<Map<String, dynamic>>> getNotesByUserId(
  String userId,
) async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from('datatable')
        .select('title, content')
        .eq('userId', int.parse(userId));

    return List<Map<String, dynamic>>.from(data);
  } catch (e) {
    print("❌ Error fetching notes: $e");
    return [];
  }
}

Future<bool> checkForPrivateFolderAccess(
  BuildContext context,
  String userId,
) async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from("privatefolder")
        .select('userId')
        .eq('userId', int.parse(userId))
        .maybeSingle();

    return data != null;
  } catch (e) {
    print("❌ Error checking userId in privatefolder: $e");
    return false;
  }
}

Future<String> fetchPrivatePassword(String userId) async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from("privatefolder")
        .select('password')
        .eq('userId', int.parse(userId))
        .maybeSingle();

    return data?['password'] ?? "";
  } catch (e) {
    print("Error fetching password: $e");
    return "";
  }
}

Future<void> savefiles(
  BuildContext context,
  String userId,
  String title,
  String content,
) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.from('datatable').insert({
      'userId': int.parse(userId),
      'title': title,
      'content': content,
    });

    // Optional: show success message
    Fluttertoast.showToast(
      msg: "Notes Saved Successfully",
      backgroundColor: Colors.lightGreen,
      gravity: ToastGravity.TOP,
    );
  } catch (error) {
    // Handle error (e.g. show a snackbar)
    Fluttertoast.showToast(
      msg: 'Error saving note: $error',
      backgroundColor: Theme.of(context).colorScheme.onError,
      gravity: ToastGravity.TOP,
    );
  }
}

Future<void> savefilesinprivate(
  BuildContext context,
  String userId,
  String title,
  String content,
) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.from("privatefoldercontent").insert({
      'userId': int.parse(userId),
      'title': title,
      'content': content,
    });

    Fluttertoast.showToast(
      msg: 'Notes saved in private folder',
      backgroundColor: Colors.lightGreen,
      gravity: ToastGravity.TOP,
    );
  } catch (error) {
    Fluttertoast.showToast(
      msg: 'Error saving Note in private folder: $error',
      backgroundColor: Theme.of(context).colorScheme.onError,
      gravity: ToastGravity.TOP,
    );
  }
}

Future<List<Map<String, dynamic>>> fetchPrivateNotes(String userId) async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('privatefoldercontent')
      .select()
      .eq('userId', userId)
      .order('created_at', ascending: false);

  return response;
}

Future<void> setprivatepassword(
  BuildContext context,
  String userId,
  String password,
) async {
  final supabase = Supabase.instance.client;
  await supabase.from('privatefolder').insert({
    'userId': int.parse(userId),
    'password': password,
  });
}

Future<void> updateprivatepassword(
  BuildContext context,
  String userId,
  String newPassword,
) async {
  final supabase = Supabase.instance.client;
  await supabase
      .from('privatefolder')
      .update({'password': newPassword})
      .eq('userId', int.parse(userId));
}

Future<void> updatenormalpassword(String userId, String password) async {
  final supabase = Supabase.instance.client;
  await supabase
      .from("loginandsignup")
      .update({'password': password})
      .eq('userId', int.parse(userId));
}

Future<bool> verifyOldPassword(String userId, String oldPassword) async {
  final supabase = Supabase.instance.client;
  final result = await supabase
      .from('loginandsignup')
      .select('password')
      .eq('userId', userId)
      .maybeSingle();

  if (result != null && result['password'] == oldPassword) {
    return true;
  }
  return false;
}

Future<void> resetAccountPassword(String userId, String newPassword) async {
  final supabase = Supabase.instance.client;
  await supabase
      .from('loginandsignup')
      .update({'password': newPassword})
      .eq('userId', userId);
}

Future<bool> verifyOldPrivatePassword(String userId, String oldPassword) async {
  final supabase = Supabase.instance.client;
  final result = await supabase
      .from('privatefolder')
      .select('password')
      .eq('userId', userId)
      .maybeSingle();

  return result != null && result['password'] == oldPassword;
}

Future<void> updateNoteInSupabase(
  String userId,
  String title,
  String content,
) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('datatable')
        .update({'content': content})
        .eq('userId', int.parse(userId))
        .eq('title', title);

    Fluttertoast.showToast(
      msg: 'Notes Updated Successfully',
      backgroundColor: Colors.lightGreen,
      gravity: ToastGravity.TOP,
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: 'Error occured $e',
      backgroundColor: Colors.red[300],
      gravity: ToastGravity.TOP,
    );
  }
}

Future<void> deleteNoteFromSupabase(String noteId, title) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('datatable')
      .delete()
      .eq('userId', int.parse(noteId))
      .eq('title', title);

  if (response.error != null) {
    throw Exception('Failed to delete note: ${response.error!.message}');
  } else {
    Fluttertoast.showToast(
      msg: 'File deleted Successfully',
      backgroundColor: Colors.lightGreen,
      gravity: ToastGravity.TOP,
    );
  }
}

Future<void> updatePrivateNoteInSupabase(
  String userId,
  String title,
  String newContent,
) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase
        .from('privatefoldercontent')
        .update({'content': newContent})
        .eq('userId', int.parse(userId))
        .eq('title', title);
    Fluttertoast.showToast(
      msg: 'Private Note Updated Successfully',
      backgroundColor: Colors.lightGreen,
      gravity: ToastGravity.TOP,
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: 'Error Occured: $e',
      backgroundColor: Colors.red[300],
      gravity: ToastGravity.TOP,
    );
  }
}

Future<void> deletePrivateNoteFromSupabase(String userId, String title) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase
        .from('privatefoldercontent')
        .delete()
        .eq('userId', int.parse(userId))
        .eq('title', title);

    Fluttertoast.showToast(
      msg: 'Private Note deleted Successfully',
      backgroundColor: Colors.lightGreen,
      gravity: ToastGravity.TOP,
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: 'Error Occured: $e',
      backgroundColor: Colors.red[300],
      gravity: ToastGravity.TOP,
    );
  }
}

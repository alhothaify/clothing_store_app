import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_creation_req.dart';
import '../models/user_signin_req.dart';
import 'package:dio/dio.dart';

abstract class AuthFirebaseService {


  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSigninReq user);
  Future<Either> getAges();
  Future<Either> sendPasswordResetEmail(String email);
  Future<bool> isLoggedIn();
  Future<Either> getUser();
}


class AuthFirebaseServiceImpl extends AuthFirebaseService {

  final Dio dio = Dio();

  @override
  Future<Either> signup(UserCreationReq user) async {
    try {
      // Make a POST request to the API for sign-up
      var response = await dio.post(
        'http://10.0.2.2:8000/api/register',
        queryParameters: {
          'name': user.firstName,
          'email': user.email,
          'password': user.password,
        },
      );

      // Check if the API response is successful
      if (response.statusCode == 200) {
        return const Right('Sign up was successful');
      } else {
        return Left('Failed to sign up. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        return Left('Failed: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        return Left('Request failed: ${e.message}');
      }
    }
  }

  //
  // @override
  // Future<Either> signup(UserCreationReq user) async {
  //   try {
  //
  //     var returnedData = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: user.email!,
  //       password: user.password!
  //     );
  //
  //    await FirebaseFirestore.instance.collection('Users').doc(
  //       returnedData.user!.uid
  //     ).set(
  //       {
  //         'firstName' : user.firstName,
  //         // 'lastName' : user.lastName,
  //         'email' : user.email,
  //         // 'gender' : user.gender,
  //         // 'age' : user.age,
  //         'image' :returnedData.user!.photoURL,
  //         // 'userId': returnedData.user!.uid
  //       }
  //     );
  //
  //     return const Right(
  //       'Sign up was successfull'
  //     );
  //
  //   } on FirebaseAuthException catch(e){
  //     String message = '';
  //
  //     if(e.code == 'weak-password') {
  //       message = 'The password provided is too weak';
  //     } else if (e.code == 'email-already-in-use') {
  //       message = 'An account already exists with that email.';
  //     }
  //     return Left(message);
  //   }
  // }


  @override
  Future<Either> getAges() async {
    try {
      var returnedData = await FirebaseFirestore.instance.collection('Ages').get();
      return Right(
        returnedData.docs
      );
    } catch (e) {
      return const Left(
        'Please try again'
      );
    }
  }






  @override
  Future<Either> signin(UserSigninReq user) async {
  try {
  // Make a POST request to the API for sign-in
  var response = await dio.post(
  'http://10.0.2.2:8000/api/login',  // Replace with your API endpoint
  data: {
  'email': user.email,   // User's email
  'password': user.password,  // User's password
  },
  );

  // If the API response is successful, return a success message
  if (response.statusCode == 200) {
  return const Right('Sign in was successful');
  } else {
  return Left('Failed to sign in. Status code: ${response.statusCode}');
  }

  } on DioException catch (e) {
  // Handle Dio-specific errors
  String errorMessage = '';

  if (e.response != null && e.response?.statusCode == 401) {
  errorMessage = 'Invalid credentials. Please check your email and password.';
  } else if (e.response != null) {
  errorMessage = 'Sign in failed: ${e.response?.data['message']}';
  } else {
  errorMessage = 'Request failed: ${e.message}';
  }

  return Left(errorMessage);
  }
  }


  //
  // @override
  // Future<Either> signin(UserSigninReq user) async {
  //    try {
  //      await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: user.email!,
  //       password: user.password!
  //     );
  //     return const Right(
  //       'Sign in was successfull'
  //     );
  //
  //   } on FirebaseAuthException catch(e){
  //     String message = '';
  //
  //     if(e.code == 'invalid-email') {
  //       message = 'Not user found for this email';
  //     } else if (e.code == 'invalid-credential') {
  //       message = 'Wrong password provided for this user';
  //     }
  //
  //     return Left(message);
  //   }
  // }
  
  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right(
        'Password reset email is sent'
      );
    } catch (e){
      return const Left(
        'Please try again'
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      // Make a GET request to your API to check if the user is logged in
      var response = await dio.get('http://10.0.2.2:8000/api/check-auth',
        options: Options(
          headers: {
            'Authorization': 'Bearer YOUR_ACCESS_TOKEN',  // Include the user's token
          },
        ),
      );

      // If the API response status is 200, the user is logged in
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }

    } on DioException catch (e) {
      // If there's an error, assume the user is not logged in
      return false;
    }
  }





  // @override
  // Future<bool> isLoggedIn() async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  
  @override
  Future<Either> getUser() async {
    try {
    var currentUser = FirebaseAuth.instance.currentUser;
    var userData = await FirebaseFirestore.instance.collection('Users').doc(
      currentUser?.uid
    ).get().then((value) => value.data());
    return Right(
      userData
    );
    } catch(e) {
      return const Left(
        'Please try again'
      );
    }
  }

  
}
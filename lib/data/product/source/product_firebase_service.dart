import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ProductFirebaseService {
  Future<Either> getTopSelling();
  Future<Either> getNewIn();
  Future<Either> getProductsByCategoryId(String categoryId);
}

class ProductFirebaseServiceImpl extends ProductFirebaseService {

  final Dio dio = Dio();

  @override
  Future < Either > getTopSelling() async {
    try {
      var returnedData = await FirebaseFirestore.instance.collection(
          'Products'
      ).where(
          'salesNumber',
          isGreaterThanOrEqualTo: 20
      ).get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left(
          'Please try again'
      );
    }
  }

  @override
  Future<Either> getNewIn() async {
    try {
      var returnedData = await FirebaseFirestore.instance.collection(
          'Products'
      ).where(
          'createdDate',
          isGreaterThanOrEqualTo: DateTime(2024,07,25)
      ).get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left(
          'Please try again'
      );
    }
  }




  @override
  Future<Either> getProductsByCategoryId(String categoryId) async {
    try {
      var returnedData = await FirebaseFirestore.instance.collection(
          'Products'
      ).where(
          'categoryId',
          isEqualTo: categoryId
      ).get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left(
          'Please try again'
      );
    }
  }


}
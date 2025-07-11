// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductEntity {
  final String categoryId;
  final Timestamp createdDate;
  final num discountedPrice;
  final int gender;
  final List < String > images;
  final num price;
  final String productId;
  final int salesNumber;
  final String title;

  ProductEntity({
    required this.categoryId,
    required this.createdDate,
    required this.discountedPrice,
    required this.gender,
    required this.images,
    required this.price,
    required this.productId,
    required this.salesNumber,
    required this.title
  });

}

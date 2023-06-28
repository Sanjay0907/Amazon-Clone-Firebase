import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReviewModel {
  final List<String>? imagesURL;
  final double rating;
  final String? review;
  final String? reviewID;
  final String? userID;
  ReviewModel({
    this.imagesURL,
    required this.rating,
    this.review,
    this.reviewID,
    this.userID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagesURL': imagesURL,
      'rating': rating,
      'review': review,
      'reviewID': reviewID,
      'userID': userID,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      imagesURL: map['imagesURL'] != null
          ? List<String>.from((map['imagesURL'] as List<dynamic>)).toList()
          : null,
      rating: map['rating'] as double,
      review: map['review'] != null ? map['review'] as String : null,
      reviewID: map['reviewID'] != null ? map['reviewID'] as String : null,
      userID: map['userID'] != null ? map['userID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

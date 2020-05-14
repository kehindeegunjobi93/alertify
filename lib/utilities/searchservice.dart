import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField){
    var query = Firestore.instance.collection("users");
    query = query.where("userType", isEqualTo: "Security Personnel");
    query = query.where("searchKey", isEqualTo: searchField.substring(0,1).toUpperCase());
    return query.getDocuments();
  }
}
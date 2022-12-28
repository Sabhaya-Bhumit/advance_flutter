import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> inserttData({required Map<String, dynamic> data}) async {
    await firestore.collection("service_data").doc("${data['id']}").set(data);
  }

  Stream<QuerySnapshot> fecthchAllData({required String name}) {
    return firestore.collection(name).snapshots();
  }

//count
  Stream<QuerySnapshot> fecthchCount() {
    return firestore.collection("countert").snapshots();
  }

  Future<void> UpdateRecode(
      {required String id, required Map<String, dynamic> data}) async {
    await firestore.collection("service_data").doc(id).update(data);
  }

//count
  Future<void> UpdateCount({required Map<String, dynamic> data}) async {
    await firestore.collection("countert").doc("students_Counter").update(data);
  }

  Future<void> DeleteRecode(
      {required String id, required Map<String, dynamic> data}) async {
    await firestore.collection("service_data").doc(id).delete();
  }
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

  String _basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'rey:ils-fr-12'));
  
    Map<String, String> myheaders = {
          'authorization': _basicAuth
        };



class Curd {
  getReq(String uri) async {
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print('error code: ${response.statusCode}');
      }
    } catch (e) {
      print('error catch $e');
    }
  }

  postReq(String uri, Map data) async {
    try {
      var response = await http.  post(Uri.parse(uri), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print('error code: ${response.statusCode}');
      }
    } catch (e) {
      print('error catch $e');
    }
  }
  
postFileReq(String url, Map data, File file) async {
  var request = http.MultipartRequest("POST", Uri.parse(url));
  var length = await file.length();
  var stream = http.ByteStream(file.openRead());
  var multipartfile =
      http.MultipartFile("file", stream, length, filename: basename(file.path));
      request.headers.addAll(myheaders);
  request.files.add(multipartfile);
  data.forEach((key, value) {
    request.fields[key] = value;
  });
  var myreq = await request.send();
  var response = await http.Response.fromStream(myreq);
  if (myreq.statusCode == 200) {
    return jsonDecode(response.body);
  } else
    print(myreq.statusCode); 
}

}

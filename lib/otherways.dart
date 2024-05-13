import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart'; 

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Remove debug banner
    home: HomePageButton(),
  ));
}

class HomePageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> sendImageForClassification(File imageFile) async {
      final url = Uri.parse('http://your_server_ip:5000/classify_image');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          var jsonResponse = await response.stream.bytesToString();
          Map<String, dynamic> responseData = jsonDecode(jsonResponse);
          String predictedSkinType = responseData['predicted_skin_type'];
          print('Predicted Skin Type: $predictedSkinType');
          // You can further process the predicted skin type here
        } else {
          print('Failed to classify image: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/5.jpg'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Handle camera button press
                      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (image != null) {
                        File imageFile = File(image.path);
                        sendImageForClassification(imageFile);
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

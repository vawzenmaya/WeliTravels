import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageEditScreen extends StatefulWidget {
  final List<String> carouselImages;
  final ValueChanged<List<String>> onImageEdit;

  const ImageEditScreen({
    required this.carouselImages,
    required this.onImageEdit,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late List<String> editableImages;

  @override
  void initState() {
    super.initState();
    editableImages = List.from(widget.carouselImages); // Copy the original list
  }

  Future<void> _replaceImage(int index) async {
    final ImagePicker picker = ImagePicker();

    // Allow the user to pick an image from the gallery
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800, // Optionally resize the image
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        editableImages[index] = pickedFile.path; // Replace the image with the picked file's path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Edit Images",
        style: TextStyle(color: Colors.white),)),
      body: ListView.builder(
        itemCount: editableImages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                editableImages[index],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Image ${index + 1}'),
            subtitle: Text(editableImages[index]),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {} // Open image picker to replace the image
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          widget.onImageEdit(editableImages); // Return the updated list
          Navigator.pop(context);
        },
      ),
    );
  }
}

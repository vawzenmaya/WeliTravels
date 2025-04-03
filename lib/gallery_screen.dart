import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Map<String, dynamic>> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _addImage() async {
    final TextEditingController storyController = TextEditingController();
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      setState(() {
        _isLoading = false;
      });
      
      if (image != null) {
        // Prompt the user to add a story
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Story'),
              content: TextField(
                controller: storyController,
                decoration: const InputDecoration(
                  hintText: 'Enter a story',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    setState(() {
                      _images.insert(0, {
                        'imagePath': image.path,
                        'story': storyController.text.isEmpty
                            ? 'No story provided'
                            : storyController.text,
                        'posterName': 'You',
                        'posterImage': 'assets/images/maguy.jpg',
                        'likes': 0,
                        'liked': false,
                        'comments': [],
                        'showComments': false,
                        'time': DateTime.now(),
                      });
                    });
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick an image: $e')),
      );
    }
  }

  void _toggleLike(int index) {
    setState(() {
      _images[index]['likes'] += _images[index]['liked'] ? -1 : 1;
      _images[index]['liked'] = !_images[index]['liked'];
    });
  }

  void _toggleComments(int index) {
    setState(() {
      _images[index]['showComments'] = !_images[index]['showComments'];
    });
  }

  void _toggleCommentLike(int imageIndex, int commentIndex) {
    setState(() {
      final comment = _images[imageIndex]['comments'][commentIndex];
      comment['liked'] = !(comment['liked'] ?? false);
      comment['likes'] += comment['liked'] ? 1 : -1;
    });
  }

  void _showCommentDialog(BuildContext context, int index) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: 'Enter your comment',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  setState(() {
                    _images[index]['comments'].add({
                      'comment': commentController.text,
                      'commenterName': 'You',
                      'commenterImage': 'assets/images/maguy.jpg',
                      'time': DateTime.now(),
                      'likes': 0,
                      'liked': false,
                      'replies': [],
                      'showReplies': false,
                    });
                    // Auto-show comments when a new comment is added
                    _images[index]['showComments'] = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment cannot be empty')),
                  );
                }
              },
              child: const Text('Post', style: TextStyle(color: Colors.white70),),
            ),
          ],
        );
      },
    );
  }

  void _showReplyDialog(BuildContext context, int imageIndex, int commentIndex) {
    final TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Reply'),
          content: TextField(
            controller: replyController,
            decoration: const InputDecoration(
              hintText: 'Enter your reply',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                if (replyController.text.trim().isNotEmpty) {
                  setState(() {
                    _images[imageIndex]['comments'][commentIndex]['replies']
                        .add({
                      'reply': replyController.text,
                      'replierName': 'You',
                      'replierImage': 'assets/images/maguy.jpg',
                      'time': DateTime.now(),
                      'likes': 0,
                      'liked': false,
                    });
                    // Auto-show replies when a new reply is added
                    _images[imageIndex]['comments'][commentIndex]['showReplies'] = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply cannot be empty')),
                  );
                }
              },
              child: const Text('Post', style: TextStyle(color: Colors.white70),),
            ),
          ],
        );
      },
    );
  }

  void _toggleReplies(int imageIndex, int commentIndex) {
    setState(() {
      _images[imageIndex]['comments'][commentIndex]['showReplies'] = 
          !(_images[imageIndex]['comments'][commentIndex]['showReplies'] ?? false);
    });
  }

  String _getTimeAgo(dynamic time) {
    if (time is DateTime) {
      return timeago.format(time);
    } else if (time is String) {
      return time;
    }
    return 'Unknown time';
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
        title: const Text('Gallery', style: TextStyle(color: Colors.white),),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : _images.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_album, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No images yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: _addImage,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add Your First Image'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    // Simulate refresh
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(_images[index]['posterImage']),
                                ),
                                title: Text(
                                  _images[index]['posterName'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(_getTimeAgo(_images[index]['time'])),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.share),
                                            title: const Text('Share'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Sharing not implemented')),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.bookmark_border),
                                            title: const Text('Save'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Saved to collection')),
                                              );
                                            },
                                          ),
                                          if (_images[index]['posterName'] == 'You')
                                            ListTile(
                                              leading: const Icon(Icons.delete, color: Colors.red),
                                              title: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _images.removeAt(index);
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Post deleted')),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (_images[index]['story'] != null && 
                                  _images[index]['story'] != 'No story provided' &&
                                  _images[index]['story'] != 'Lorem ipsum')
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    _images[index]['story'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              GestureDetector(
                                onDoubleTap: () => _toggleLike(index),
                                child: Hero(
                                  tag: 'image_${_images[index]['imagePath']}',
                                  child: Container(
                                    height: 300,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: _images[index]['imagePath'].startsWith('assets')
                                        ? Image.asset(
                                            _images[index]['imagePath'],
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(_images[index]['imagePath']),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            _images[index]['liked']
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: _images[index]['liked']
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () => _toggleLike(index),
                                        ),
                                        Text(
                                          '${_images[index]['likes']}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          icon: const Icon(Icons.comment_outlined),
                                          onPressed: () => _toggleComments(index),
                                        ),
                                        Text(
                                          '${_images[index]['comments'].length}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_comment_outlined),
                                      onPressed: () => _showCommentDialog(context, index),
                                    ),
                                  ],
                                ),
                              ),
                              if (_images[index]['showComments'] && _images[index]['comments'].isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ..._images[index]['comments'].map<Widget>((comment) {
                                        final commentIndex = _images[index]['comments'].indexOf(comment);
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage(comment['commenterImage']),
                                                radius: 18,
                                              ),
                                              title: Row(
                                                children: [
                                                  Text(
                                                    comment['commenterName'],
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _getTimeAgo(comment['time']),
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Text(
                                                      comment['comment'],
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      TextButton.icon(
                                                        style: TextButton.styleFrom(
                                                          padding: EdgeInsets.zero,
                                                          minimumSize: const Size(0, 30),
                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        ),
                                                        icon: Icon(
                                                          comment['liked'] ?? false
                                                              ? Icons.favorite
                                                              : Icons.favorite_border,
                                                          size: 16,
                                                          color: comment['liked'] ?? false
                                                              ? Colors.red
                                                              : Colors.grey,
                                                        ),
                                                        label: Text(
                                                          '${comment['likes']}',
                                                          style: const TextStyle(fontSize: 12),
                                                        ),
                                                        onPressed: () => _toggleCommentLike(index, commentIndex),
                                                      ),
                                                      TextButton.icon(
                                                        style: TextButton.styleFrom(
                                                          padding: EdgeInsets.zero,
                                                          minimumSize: const Size(0, 30),
                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        ),
                                                        icon: const Icon(
                                                          Icons.reply,
                                                          size: 16,
                                                          color: Colors.grey,
                                                        ),
                                                        label: const Text(
                                                          'Reply',
                                                          style: TextStyle(fontSize: 12),
                                                        ),
                                                        onPressed: () => _showReplyDialog(
                                                            context, index, commentIndex),
                                                      ),
                                                      if ((comment['replies'] ?? []).isNotEmpty)
                                                        TextButton.icon(
                                                          style: TextButton.styleFrom(
                                                            padding: EdgeInsets.zero,
                                                            minimumSize: const Size(0, 30),
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          ),
                                                          icon: Icon(
                                                            comment['showReplies'] ?? false
                                                                ? Icons.keyboard_arrow_up
                                                                : Icons.keyboard_arrow_down,
                                                            size: 16,
                                                            color: Colors.grey,
                                                          ),
                                                          label: Text(
                                                            '${comment['replies'].length} ${comment['replies'].length == 1 ? 'reply' : 'replies'}',
                                                            style: const TextStyle(fontSize: 12),
                                                          ),
                                                          onPressed: () => _toggleReplies(index, commentIndex),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if ((comment['showReplies'] ?? false) && 
                                                (comment['replies'] ?? []).isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 56.0),
                                                child: Column(
                                                  children: [
                                                    ...comment['replies'].map<Widget>((reply) {
                                                      return ListTile(
                                                        dense: true,
                                                        leading: CircleAvatar(
                                                          backgroundImage: AssetImage(reply['replierImage']),
                                                          radius: 14,
                                                        ),
                                                        title: Row(
                                                          children: [
                                                            Text(
                                                              reply['replierName'],
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              _getTimeAgo(reply['time']),
                                                              style: TextStyle(
                                                                color: Colors.grey[600],
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                              child: Text(
                                                                reply['reply'],
                                                                style: const TextStyle(
                                                                  color: Colors.black87,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                TextButton.icon(
                                                                  style: TextButton.styleFrom(
                                                                    padding: EdgeInsets.zero,
                                                                    minimumSize: const Size(0, 24),
                                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  ),
                                                                  icon: Icon(
                                                                    reply['liked'] ?? false
                                                                        ? Icons.favorite
                                                                        : Icons.favorite_border,
                                                                    size: 14,
                                                                    color: reply['liked'] ?? false
                                                                        ? Colors.red
                                                                        : Colors.grey,
                                                                  ),
                                                                  label: Text(
                                                                    '${reply['likes']}',
                                                                    style: const TextStyle(fontSize: 11),
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      reply['liked'] = !(reply['liked'] ?? false);
                                                                      reply['likes'] += reply['liked'] ? 1 : -1;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                ),
                                              ),
                                            const Divider(),
                                          ],
                                        );
                                      }).toList(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.purple,
                                            side: const BorderSide(color: Colors.purple),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () => _showCommentDialog(context, index),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_comment),
                                              SizedBox(width: 8),
                                              Text('Add a comment'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addImage,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add_photo_alternate),
        tooltip: 'Add Image',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _images.addAll([
      {
        'imagePath': 'assets/gallery/IMG6.jpg',
        'story': 'Beautiful sunset at the beach today! #NatureLovers',
        'posterName': 'John Doe',
        'posterImage': 'assets/images/maguy.jpg',
        'likes': 10,
        'liked': false,
        'comments': [
          {
            'comment': 'Amazing view! Where was this taken?',
            'commenterName': 'Sarah',
            'commenterImage': 'assets/images/maguy.jpg',
            'time': DateTime.now().subtract(const Duration(hours: 1)),
            'likes': 2,
            'liked': false,
            'replies': [
              {
                'reply': 'This was at Malibu Beach!',
                'replierName': 'John Doe',
                'replierImage': 'assets/images/maguy.jpg',
                'time': DateTime.now().subtract(const Duration(minutes: 30)),
                'likes': 1,
                'liked': false,
              }
            ],
            'showReplies': false,
          }
        ],
        'showComments': false,
        'time': DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        'imagePath': 'assets/gallery/IMG7.jpg',
        'story': 'Exploring the mountains this weekend! The view was breathtaking.',
        'posterName': 'Vawzen',
        'posterImage': 'assets/images/maguy.jpg',
        'likes': 15,
        'liked': false,
        'comments': [],
        'showComments': false,
        'time': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'imagePath': 'assets/gallery/IMG8.jpg',
        'story': 'City lights and urban vibes. #CityLife',
        'posterName': 'Bashir',
        'posterImage': 'assets/images/maguy.jpg',
        'likes': 8,
        'liked': false,
        'comments': [
          {
            'comment': 'Great shot! Which city is this?',
            'commenterName': 'Alex',
            'commenterImage': 'assets/images/maguy.jpg',
            'time': DateTime.now().subtract(const Duration(hours: 2)),
            'likes': 3,
            'liked': false,
            'replies': [],
            'showReplies': false,
          }
        ],
        'showComments': false,
        'time': DateTime.now().subtract(const Duration(hours: 7)),
      },
      {
        'imagePath': 'assets/gallery/IMG23.jpg',
        'story': 'Art exhibition visit today. So many talented artists!',
        'posterName': 'Jane Smith',
        'posterImage': 'assets/images/maguy.jpg',
        'likes': 12,
        'liked': false,
        'comments': [],
        'showComments': false,
        'time': DateTime.now().subtract(const Duration(hours: 9)),
      },
    ]);
  }
}


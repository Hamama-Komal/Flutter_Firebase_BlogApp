import 'package:flutter/material.dart';
import 'package:for_you/ui_components/my_colors.dart';

class BlogDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String author;

  BlogDetailsScreen({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Detail",
          style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),),
        backgroundColor: myColors.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.9,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'By $author',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: myColors.dark2, fontSize: 15),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

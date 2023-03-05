import 'package:flutter/material.dart';

class ScreenGalley extends StatelessWidget {
  const ScreenGalley({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text('Photo Gallery'),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0),
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          'https://static.toiimg.com/photo/msid-80403566/80403566.jpg?240161'),
                    );
                  }),
            ),
          ),
        ],
      )),
    );
  }
}

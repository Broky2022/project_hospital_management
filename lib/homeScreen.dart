import 'package:flutter/material.dart';

class homeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Bệnh Nhân'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          for(int i=1; i <=10; i++)
            Center(
              child: Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdTZQaAmB3cBaZw5-djjmjPIFrZQO9r_fR3Q&s',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 80),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bệnh Nhân $i',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          const SizedBox(height: 4),
                          Text('Thông tin bệnh nhân $i'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
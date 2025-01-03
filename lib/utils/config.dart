import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildInfoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Shimmer effect for loading state
Widget buildShimmerEffect() {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: 6, // Number of shimmer placeholders
    itemBuilder: (context, index) {
      return Card(
        elevation: 6,
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[200]!,
                Colors.grey[100]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 18,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Đã khám':
      return Colors.green;
    case 'đã khám':
      return Colors.green;
    case 'Đang chờ...':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

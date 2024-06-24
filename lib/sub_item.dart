class SubItem {
  final String id; // Add this line
  final String title;
  final String description;
  final double rating;
  final String imageUrl;

  SubItem({
    required this.id, // Add this line
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
  });
}

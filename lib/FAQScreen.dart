import 'package:flutter/material.dart';

// Import shared widgets
import 'shared_widgets.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<FAQItem> _allFAQs = [
    FAQItem(
      question: "What causes acne and how can I treat it?",
      answer: "Acne is caused by clogged pores, bacteria, and hormonal changes. Treatment options include:\n• Gentle cleansing twice daily\n• Salicylic acid or benzoyl peroxide products\n• Retinoids for persistent acne\n• Professional treatments like chemical peels\n\nConsult a dermatologist for severe or persistent acne.",
      category: "Acne",
    ),
    FAQItem(
      question: "How do I build an effective skincare routine?",
      answer: "A basic skincare routine should include:\n\nMorning:\n• Gentle cleanser\n• Moisturizer\n• Sunscreen (SPF 30+)\n\nEvening:\n• Gentle cleanser\n• Treatment products (if needed)\n• Moisturizer\n\nStart simple and gradually add products as needed.",
      category: "Routine",
    ),
    FAQItem(
      question: "What's the difference between dry and dehydrated skin?",
      answer: "Dry skin lacks oil (sebum) and is a skin type, while dehydrated skin lacks water and is a temporary condition.\n\nDry skin signs:\n• Flaky, rough texture\n• Tight feeling\n• Fine lines\n\nDehydrated skin signs:\n• Dull appearance\n• Fine lines that disappear when moisturized\n• Oily yet tight feeling",
      category: "Skin Types",
    ),
    FAQItem(
      question: "How often should I exfoliate my skin?",
      answer: "Exfoliation frequency depends on your skin type:\n\n• Sensitive skin: 1-2 times per week\n• Normal skin: 2-3 times per week\n• Oily skin: 3-4 times per week\n\nUse chemical exfoliants (AHA/BHA) rather than physical scrubs for gentler results. Always start slowly and increase frequency gradually.",
      category: "Exfoliation",
    ),
    FAQItem(
      question: "What ingredients should I avoid in skincare products?",
      answer: "Common ingredients to be cautious with:\n\n• Alcohol denat (drying)\n• Fragrances (potential irritants)\n• Essential oils (can cause sensitivity)\n• Harsh sulfates (stripping)\n• Parabens (controversial preservatives)\n\nAlways patch test new products and choose fragrance-free options for sensitive skin.",
      category: "Ingredients",
    ),
    FAQItem(
      question: "How do I treat dark spots and hyperpigmentation?",
      answer: "Effective treatments for dark spots include:\n\n• Vitamin C serum (prevention and brightening)\n• Niacinamide (reduces melanin transfer)\n• Retinoids (cell turnover)\n• Hydroquinone (bleaching agent)\n• Chemical peels (professional treatment)\n\nAlways use sunscreen to prevent further darkening. Results take 6-12 weeks to show.",
      category: "Pigmentation",
    ),
    FAQItem(
      question: "When should I see a dermatologist?",
      answer: "Consult a dermatologist when:\n\n• Severe or cystic acne\n• Persistent skin conditions\n• Suspicious moles or skin changes\n• Rashes that don't improve\n• Hair loss or scalp issues\n• Before starting strong treatments\n\nRegular skin cancer screenings are recommended annually.",
      category: "Professional Care",
    ),
    FAQItem(
      question: "What's the proper way to apply sunscreen?",
      answer: "Sunscreen application tips:\n\n• Use 1/4 teaspoon for face and neck\n• Apply 15-30 minutes before sun exposure\n• Reapply every 2 hours\n• Don't forget ears, lips, and hands\n• Use SPF 30 or higher\n• Apply even on cloudy days\n\nMineral sunscreens are best for sensitive skin.",
      category: "Sun Protection",
    ),
  ];

  List<FAQItem> get _filteredFAQs {
    if (_searchQuery.isEmpty) {
      return _allFAQs;
    }
    return _allFAQs.where((faq) {
      return faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'FAQ'),

            // Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.blue[900]!,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search frequently asked questions...',
                  hintStyle: TextStyle(color: Colors.blue[700]),
                  prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.blue[700]),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),

            // FAQ List
            Expanded(
              child: _filteredFAQs.isEmpty
                  ? _buildNoResultsWidget()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredFAQs.length,
                itemBuilder: (context, index) {
                  return _buildFAQCard(_filteredFAQs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No FAQs found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE94057).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(faq.category),
            color: const Color(0xFFE94057),
            size: 20,
          ),
        ),
        title: Text(
          faq.question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            faq.category,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        iconColor: const Color(0xFFE94057),
        collapsedIconColor: Colors.grey[600],
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'acne':
        return Icons.face_retouching_natural;
      case 'routine':
        return Icons.schedule;
      case 'skin types':
        return Icons.person;
      case 'exfoliation':
        return Icons.cleaning_services;
      case 'ingredients':
        return Icons.science;
      case 'pigmentation':
        return Icons.palette;
      case 'professional care':
        return Icons.medical_services;
      case 'sun protection':
        return Icons.wb_sunny;
      default:
        return Icons.help_outline;
    }
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
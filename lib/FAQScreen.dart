import 'package:flutter/material.dart';

// Import shared widgets
import 'shared_widgets.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late TabController _tabController;

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

  List<String> get _categories {
    final categories = ['All'] + _allFAQs.map((faq) => faq.category).toSet().toList();
    return categories;
  }

  List<FAQItem> get _filteredFAQs {
    List<FAQItem> filtered = _allFAQs;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((faq) => faq.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((faq) {
        return faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'FAQ'),

            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common skincare questions',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modern Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search your skincare questions...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.grey[400],
                            size: 22,
                          ),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.grey[600],
                                size: 16,
                              ),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter Chips
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF667EEA).withOpacity(0.15),
                      checkmarkColor: const Color(0xFF667EEA),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF667EEA) : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF667EEA) : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      elevation: isSelected ? 2 : 0,
                      shadowColor: const Color(0xFF667EEA).withOpacity(0.3),
                    ),
                  );
                },
              ),
            ),

            // FAQ List
            Expanded(
              child: _filteredFAQs.isEmpty
                  ? _buildNoResultsWidget()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: _filteredFAQs.length,
                itemBuilder: (context, index) {
                  return _buildModernFAQCard(_filteredFAQs[index], index);
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No FAQs found',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAQCard(FAQItem faq, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getCategoryColor(faq.category),
                  _getCategoryColor(faq.category).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _getCategoryColor(faq.category).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _getCategoryIcon(faq.category),
              color: Colors.white,
              size: 22,
            ),
          ),
          title: Text(
            faq.question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(faq.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    faq.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getCategoryColor(faq.category),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          iconColor: Colors.grey[600],
          collapsedIconColor: Colors.grey[500],
          expandedAlignment: Alignment.centerLeft,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'acne':
        return const Color(0xFFEF4444);
      case 'routine':
        return const Color(0xFF8B5CF6);
      case 'skin types':
        return const Color(0xFF06B6D4);
      case 'exfoliation':
        return const Color(0xFF10B981);
      case 'ingredients':
        return const Color(0xFFF59E0B);
      case 'pigmentation':
        return const Color(0xFFEC4899);
      case 'professional care':
        return const Color(0xFF3B82F6);
      case 'sun protection':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'acne':
        return Icons.face_retouching_natural_rounded;
      case 'routine':
        return Icons.schedule_rounded;
      case 'skin types':
        return Icons.person_rounded;
      case 'exfoliation':
        return Icons.cleaning_services_rounded;
      case 'ingredients':
        return Icons.science_rounded;
      case 'pigmentation':
        return Icons.palette_rounded;
      case 'professional care':
        return Icons.medical_services_rounded;
      case 'sun protection':
        return Icons.wb_sunny_rounded;
      default:
        return Icons.help_outline_rounded;
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
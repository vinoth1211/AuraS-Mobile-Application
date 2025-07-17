import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Start animation after build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'FAQ'),

            // Header Section with Parallax Effect
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667EEA).withOpacity(0.9),
                      const Color(0xFF764BA2).withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(_fadeAnimation),
                      child: const Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _fadeController,
                        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                      )),
                      child: Text(
                        'Find answers to common skincare questions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Modern Search Bar with Animation
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _fadeController,
                        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
                      ),
                      child: Container(
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
                    ),
                  ],
                ),
              ),
            ),

            // Animated Category Filter Chips
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
              )),
              child: Container(
                height: 72,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(
                        right: 12,
                        top: isSelected ? 0 : 4,
                        bottom: isSelected ? 0 : 4,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _getCategoryColor(category)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? _getCategoryColor(category)
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: _getCategoryColor(category)
                                    .withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // FAQ List with Staggered Animations
            Expanded(
              child: _filteredFAQs.isEmpty
                  ? _buildNoResultsWidget()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: _filteredFAQs.length,
                itemBuilder: (context, index) {
                  return AnimatedFAQCard(
                    faq: _filteredFAQs[index],
                    index: index,
                    fadeController: _fadeController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _fadeController,
                curve: Curves.elasticOut,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667EEA).withOpacity(0.1),
                      const Color(0xFF764BA2).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(_fadeAnimation),
              child: const Text(
                'No FAQs found',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              )),
              child: Text(
                'Try adjusting your search or filter',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedFAQCard extends StatefulWidget {
  final FAQItem faq;
  final int index;
  final AnimationController fadeController;

  const AnimatedFAQCard({
    super.key,
    required this.faq,
    required this.index,
    required this.fadeController,
  });

  @override
  State<AnimatedFAQCard> createState() => _AnimatedFAQCardState();
}

class _AnimatedFAQCardState extends State<AnimatedFAQCard> {
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    final startDelay = 0.7 + (widget.index * 0.1);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.fadeController,
        curve: Interval(
          startDelay.clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.fadeController,
        curve: Interval(
          startDelay.clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.fadeController,
        curve: Interval(
          startDelay.clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildModernFAQCard(widget.faq),
        ),
      ),
    );
  }

  Widget _buildModernFAQCard(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
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
                      color: _getCategoryColor(faq.category).withOpacity(0.2),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getCategoryColor(faq.category).withOpacity(0.03),
                          _getCategoryColor(faq.category).withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      faq.answer,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/Trips/widgets/create_trip.dart';
import 'package:wemu_team_app/features/Trips/widgets/details_trip.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToTripDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TripDetails()),
    );
  }

  void _navigateToTripCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTrip()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildSectionTitle('On going'),
              const SizedBox(height: 8),
              _buildOngoingCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Upcoming'),
              const SizedBox(height: 8),
              _buildUpcomingList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Trips',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        GestureDetector(
          onTap: _navigateToTripCreate,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Transform.scale(
              scale: 0.8,
              child: SvgPicture.asset(AppVector.add),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildOngoingCard(BuildContext context) {
    final List<_OngoingSlideData> slides = [
      const _OngoingSlideData(
        image: AppImages.exam,
        category: 'BAR',
        title: 'Pig and Whistle',
        address: '1 Fortitude Valley, QLD, 2006',
      ),
      const _OngoingSlideData(
        image: AppImages.exam1,
        category: 'BEACH',
        title: 'Surfers Paradise',
        address: 'Gold Coast, QLD 4217',
      ),
      const _OngoingSlideData(
        image: AppImages.exam,
        category: 'CAFE',
        title: 'The Coffee Club',
        address: '123 Queen St, Brisbane City QLD 4000',
      ),
      const _OngoingSlideData(
        image: AppImages.exam1,
        category: 'PARK',
        title: 'Roma Street Parkland',
        address: '1 Parkland Blvd, Brisbane City QLD 4000',
      ),
      const _OngoingSlideData(
        image: AppImages.exam,
        category: 'MUSEUM',
        title: 'Queensland Museum',
        address: 'Grey St & Melbourne St, South Brisbane QLD 4101',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height:
                (MediaQuery.of(context).size.width - 24) *
                9 /
                16, // Aspect Ratio 16:9
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                final slide = slides[index];
                return _buildSlide(slide, slides.length);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _navigateToTripDetails,
                child: const Text(
                  'Weekend with the boyzzz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.location_on, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    '16',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: const [
            Icon(Icons.event_available, size: 14, color: AppColors.primary),
            SizedBox(width: 4),
            Text(
              'Everyday',
              style: TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide(_OngoingSlideData slide, int pageCount) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(slide.image, fit: BoxFit.cover)),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slide.category,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                slide.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      slide.address,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildPageIndicator(pageCount),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(pageCount, (index) {
        return Container(
          width: 8,
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  Widget _buildUpcomingList() {
    final items = [
      const _UpcomingTripData(
        image: AppImages.exam,
        title: 'Weekend with the...',
        dateRange: '9 Mar - 12 Mar',
      ),
      const _UpcomingTripData(
        image: AppImages.exam1,
        title: 'Noosa',
        dateRange: '9 Mar - 12 Mar',
      ),
      const _UpcomingTripData(
        image: AppImages.exam1,
        title: 'Sydney Trip',
        dateRange: '9 Mar - 12 Mar',
      ),
    ];

    return SizedBox(
      height: 240, // Increased height to fix overflow
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final trip = items[index];
          return _buildUpcomingCard(trip);
        },
      ),
    );
  }

  Widget _buildUpcomingCard(_UpcomingTripData trip) {
    return GestureDetector(
      onTap: _navigateToTripDetails,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Image.asset(trip.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              trip.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trip.dateRange,
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _OngoingSlideData {
  final String image;
  final String category;
  final String title;
  final String address;

  const _OngoingSlideData({
    required this.image,
    required this.category,
    required this.title,
    required this.address,
  });
}

class _UpcomingTripData {
  final String image;
  final String title;
  final String dateRange;

  const _UpcomingTripData({
    required this.image,
    required this.title,
    required this.dateRange,
  });
}

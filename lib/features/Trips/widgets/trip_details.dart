import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  int _selectedDateIndex = 0;

  static const double _cardHeight = 180;
  static const double _timelineGap = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Trip Details',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            _buildDateTabs(),
            const SizedBox(height: 30),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  // ---------------- DATE TABS ----------------

  Widget _buildDateTabs() {
    final dates = ['FRI, 9TH\nMAR', 'SAT, 10TH\nMAR', 'SUN, 11TH\nMAR'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(dates.length, (index) {
        final isSelected = _selectedDateIndex == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedDateIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dates[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ---------------- TIMELINE ----------------

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildTimelineItem(
          stopNumber: '1',
          time: '5:30PM',
          title: 'Pig & Whistle',
          address: '1 Fortitude Valley, QLD, 2006',
          image: AppImages.exam,
        ),
        _buildTimelineItem(
          stopNumber: '2',
          time: '7:30PM',
          title: 'Pig & Whistle',
          address: '1 Fortitude Valley, QLD, 2006',
          image: AppImages.exam1,
        ),
        _buildTimelineItem(
          stopNumber: '3',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String stopNumber,
    String? time,
    String? title,
    String? address,
    String? image,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _timelineGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------- LEFT TIMELINE --------
          Column(
            children: [
              _buildStopCircle(stopNumber),

              const SizedBox(height: 6),

              time != null
                  ? Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox(height: 14),

              const SizedBox(height: 8),

              if (!isLast)
                SizedBox(
                  height: _cardHeight - 24,
                  child: const _DashedLine(),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // -------- RIGHT CONTENT --------
          Expanded(
            child: isLast
                ? _buildAddStopButton()
                : _buildContentCard(title!, address!, image!),
          ),
        ],
      ),
    );
  }

  // ---------------- UI PARTS ----------------

  Widget _buildStopCircle(String number) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentCard(String title, String address, String image) {
    return SizedBox(
      height: _cardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStopButton() {
    return SizedBox(
      height: _cardHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'add a stop',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// ---------------- DASHED LINE ----------------

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashHeight = 5.0;
        const dashSpace = 3.0;
        final dashCount =
            (constraints.maxHeight / (dashHeight + dashSpace)).floor();

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => const SizedBox(
              width: 1.5,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/features/Trips/widgets/invite_friends.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/widgets/input/field_input.dart';
import 'package:wemu_team_app/widgets/switch/app_switch.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  bool _everydayMode = false;
  bool _isPrivate = true;
  final TextEditingController _tripNameController = TextEditingController(
    text: 'Night with the boyzz',
  );
  final TextEditingController _dateController = TextEditingController(
    text: 'Everyday Mode',
  );

  @override
  void dispose() {
    _tripNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Transform.scale(
            scale: 0.9,
            child: SvgPicture.asset(AppVector.close),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create a trip',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),

            // TRIP NAME
            FieldInput(
              label: 'TRIP NAME',
              controller: _tripNameController,
              hintText: 'Enter trip name',
            ),

            const SizedBox(height: 20),

            // DATE + SWITCH
            Row(
              children: [
                Expanded(
                  child: FieldInput(
                    label: 'DATE',
                    controller: _dateController,
                    readOnly: true,
                    onTap: () {
                      // TODO: open date picker / mode selector
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                  child: AppSwitch(
                    value: _everydayMode,
                    onChanged: (v) => setState(() => _everydayMode = v),
                    width: 64,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // PRIVATE / PUBLIC
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _privacySegment(
                      label: 'PRIVATE',
                      selected: _isPrivate,
                      onTap: () => setState(() => _isPrivate = true),
                    ),
                  ),
                  Expanded(
                    child: _privacySegment(
                      label: 'PUBLIC',
                      selected: !_isPrivate,
                      onTap: () => setState(() => _isPrivate = false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // INVITE PEOPLE
            _label('INVITE PEOPLE'),
            const SizedBox(height: 12),
            Row(
              children: [
                const UserProfile(
                  name: null,
                  showClose: true,
                  radius: 28,
                  backgroundUrl: 'https://i.pravatar.cc/150',
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const InviteFriends(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // START TRIP BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: BasicButton(onPressed: ()=>{}, title: "Start trip", backgroundColor: Colors.black,),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ===== WIDGETS =====

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _privacySegment({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF4CCBC7) : Colors.transparent,
              borderRadius: BorderRadius.circular(26),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

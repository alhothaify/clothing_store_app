import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/core/configs/assets/app_images.dart';
import 'package:ecommerce/core/configs/assets/app_vectors.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';
import 'package:ecommerce/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add Firebase Storage

import '../bloc/user_info_display_state.dart';
import '../pages/profile_image.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
        child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
          builder: (context, state) {
            // if (state is UserInfoLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            if (state is UserInfoLoading) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _profileImage(),
                  _gender(1),
                  _card(),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
  Widget _profileImage() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.profile)
          ),
          color: Colors.grey,
          shape: BoxShape.circle
      ),
    );
  }

  Future<String?> _getProfileImageUrl(String userId) async {
    try {
      // Reference to the image based on the userId in Firebase Storage
      final refStorage = FirebaseStorage.instance.ref("Users/Images/$userId.jpg");

      // Attempt to get the download URL
      final downloadUrl = await refStorage.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // If there is no image or an error occurs, return null to use the default image
      return null;
    }
  }

  Widget _gender(int gender) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          gender == 1 ? 'Men' : 'Women',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        AppVectors.bag,
        fit: BoxFit.none,
      ),
    );
  }
}

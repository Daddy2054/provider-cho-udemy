// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fb_statenf_auth/models/custom_error.dart';
import 'package:fb_statenf_auth/models/user_model.dart';
import 'package:fb_statenf_auth/providers/profile/profile_state.dart';
import 'package:fb_statenf_auth/repositories/profile_repository.dart';
import 'package:state_notifier/state_notifier.dart';

class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  ProfileProvider():super(ProfileState.initial());

  // ProfileState _state = ProfileState.initial();
  // ProfileState get state => _state;

  // final ProfileRepository profileRepository;
  // ProfileProvider({
  //   required this.profileRepository,
  // });

  Future<void> getProfile({required String uid}) async {
    state = state.copyWith(
      profileStatus: ProfileStatus.loading,
    );

    try {
      final User user = await read<ProfileRepository>().getProfile(uid: uid);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
    }
  }
}

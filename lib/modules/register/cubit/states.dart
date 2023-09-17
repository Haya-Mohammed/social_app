abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {
  final String uId;
  SocialRegisterSuccessState(this.uId);
}

class SocialRegisterErrorState extends SocialRegisterStates {
  final String error;
  SocialRegisterErrorState(this.error);
}

// create user
class SocialCreateUserSuccessState extends SocialRegisterStates {}

class SocialCreateUserErrorState extends SocialRegisterStates {
  final String error;
  SocialCreateUserErrorState(this.error);
}

// Change Password Visibility
class SocialRegisterChangePassVisibilityState extends SocialRegisterStates {}

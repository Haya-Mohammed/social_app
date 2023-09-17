abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;
  SocialGetUserErrorState(this.error);
}

class SocialBottomNavBarLoadingState extends SocialStates {}

class SocialChangeBottomNavBarSuccessState extends SocialStates {}

class SocialChangeBottomNavBarErrorState extends SocialStates {
  final String error;
  SocialChangeBottomNavBarErrorState(this.error);
}

class SocialNewPostState extends SocialStates {}

// edit profile

class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialProfileCoverPickedSuccessState extends SocialStates {}

class SocialProfileCoverPickedErrorState extends SocialStates {}

class SocialUpdateUserLoadingState extends SocialStates {}

class SocialUpdateUserSuccessState extends SocialStates {}

class SocialUpdateUserErrorState extends SocialStates {}

class SocialUploadProfileSuccessState extends SocialStates {}

class SocialUploadProfileErrorState extends SocialStates {}

class SocialUploadCoverSuccessState extends SocialStates {}

class SocialUploadCoverErrorState extends SocialStates {}

// create post

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

// get posts
class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;
  SocialGetPostsErrorState(this.error);
}

// like post
class SocialLikePostSuccessState extends SocialStates {}

class SocialLikePostErrorState extends SocialStates
{
  final String error;
  SocialLikePostErrorState(this.error);
}

// Get All Users
class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates {
  final String error;
  SocialGetAllUsersErrorState(this.error);
}
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {
  final String error;
  SocialSendMessageErrorState(this.error);
}

class SocialGetMessagesSuccessState extends SocialStates {}



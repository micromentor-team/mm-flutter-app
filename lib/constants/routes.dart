part of 'app_constants.dart';

class Route {
  final String name;
  final String path;

  Route({required this.name, required this.path});
}

class Routes {
  Routes._private();
  static Route root = Route(
    name: 'root',
    path: '/',
  );
  static Route welcome = Route(
    name: 'welcome',
    path: '/welcome',
  );
  static Route selectLanguage = Route(
    name: 'selectLanguage',
    path: '/selectLanguage',
  );
  static Route signin = Route(
    name: 'signin',
    path: '/signin',
  );
  static Route signup = Route(
    name: 'signup',
    path: '/signup',
  );
  static Route signupEmail = Route(
    name: 'signupEmail',
    path: '${signup.path}/email',
  );
  static Route signupName = Route(
    name: 'signupName',
    path: '${signup.path}/name',
  );
  static Route signupPhoneNumber = Route(
    name: 'signupPhoneNumber',
    path: '${signup.path}/phoneNumber',
  );
  static Route signupPassword = Route(
    name: 'signupPassword',
    path: '${signup.path}/password',
  );
  static Route signupVerify = Route(
    name: 'signupVerify',
    path: '${signup.path}/verify',
  );
  static Route signupWelcome = Route(
    name: 'signupWelcome',
    path: '${signup.path}/welcome',
  );
  static Route signupPermissions = Route(
    name: 'signupPermissions',
    path: '${signup.path}/permissions',
  );
  static Route signupGuidelines = Route(
    name: 'signupGuidelines',
    path: '${signup.path}/guidelines',
  );
  static Route signupYearOfBirth = Route(
    name: 'signupYearOfBirth',
    path: '${signup.path}/yearOfBirth',
  );
  static Route signupGender = Route(
    name: 'signupGender',
    path: '${signup.path}/gender',
  );
  static Route signupLocation = Route(
    name: 'signupLocation',
    path: '${signup.path}/locations',
  );
  static Route signupLanguages = Route(
    name: 'signupLanguages',
    path: '${signup.path}/languages',
  );
  static Route signupEntrepreneurOrMentor = Route(
    name: 'signupEntrepreneurOrMentor',
    path: '${signup.path}/userrole',
  );
  static Route signupBusinessStage = Route(
    name: 'signupBusinessStage',
    path: '${signup.path}/businessstage',
  );
  static Route signupBusinessHelpSelection = Route(
    name: 'signupBusinessHelpSelection',
    path: '${signup.path}/businesshelp',
  );
  static Route signupMoreInfo = Route(
    name: 'signupMoreInfo',
    path: '${signup.path}/moreinfo',
  );
  static Route addProfilePicture = Route(
    name: 'addProfilePicture',
    path: '${signup.path}/addProfilePicture',
  );
  static Route addPronouns = Route(
    name: 'addPronouns',
    path: '${signup.path}/addPronouns',
  );
  static Route addBusinessName = Route(
    name: 'addBusinessName',
    path: '${signup.path}/addBusinessName',
  );
  static Route addWebsite = Route(
    name: 'addWebsite',
    path: '${signup.path}/addWebsite',
  );
  static Route startupRationale = Route(
    name: 'startupRationale',
    path: '${signup.path}/startupRationale',
  );
  static Route industry = Route(
    name: 'industry',
    path: '${signup.path}/industry',
  );
  static Route completedEntrepreneurSignup = Route(
    name: 'completedEntrepreneurSignup',
    path: '${signup.path}/completedEntrepreneurSignup',
  );
  static Route signupMentorHelpSelection = Route(
    name: 'signupMentorHelpSelection',
    path: '${signup.path}/signupMentorHelpSelection',
  );
  static Route signupMentorMoreInfo = Route(
    name: 'signupMentorMoreInfo',
    path: '${signup.path}/signupMentorMoreInfo',
  );
  static Route signupMentorProfilePic = Route(
    name: 'signupMentorProfilePic',
    path: '${signup.path}/signupMentorProfilePic',
  );
  static Route signupMentorPronouns = Route(
    name: 'signupMentorPronouns',
    path: '${signup.path}/signupMentorPronouns',
  );
  static Route signupMentorRole = Route(
    name: 'signupMentorRole',
    path: '${signup.path}/signupMentorRole',
  );
  static Route signupMentorIndustry = Route(
    name: 'signupMentorIndustry',
    path: '${signup.path}/signupMentorIndustry',
  );
  static Route signupMentorPreferences = Route(
    name: 'signupMentorPreferences',
    path: '${signup.path}/signupMentorPreferences',
  );
  static Route signupMentorInternationally = Route(
    name: 'signupMentorInternationally',
    path: '${signup.path}/signupMentorInternationally',
  );
  static Route signupMentorCompleted = Route(
    name: 'signupMentorCompleted',
    path: '${signup.path}/signupMentorCompleted',
  );
  static Route loading = Route(
    name: 'loading',
    path: '/loading',
  );
  static Route home = Route(
    name: 'home',
    path: '/home',
  );
  static Route explore = Route(
    name: 'explore',
    path: '/explore',
  );
  static Route exploreFilters = Route(
    name: 'exploreFilters',
    path: '${explore.path}/filters',
  );
  static Route exploreFiltersAdvanced = Route(
    name: 'exploreFiltersAdvanced',
    path: '${exploreFilters.path}/advanced',
  );
  static Route inbox = Route(
    name: 'inbox',
    path: '/inbox',
  );
  static Route inboxChats = Route(
    name: 'inboxChats',
    path: '${inbox.path}/chats',
  );
  static Route inboxChatsChannelId = Route(
    name: 'inboxChatsChannelId',
    path: '${inboxChats.path}/:${RouteParams.channelId}',
  );
  static Route inboxInvites = Route(
    name: 'inboxInvites',
    path: '${inbox.path}/invites',
  );
  static Route inboxInvitesReceived = Route(
    name: 'inboxInvitesReceived',
    path: '${inboxInvites.path}/received',
  );
  static Route inboxInvitesReceivedId = Route(
    name: 'inboxInvitesReceivedId',
    path: '${inboxInvitesReceived.path}/:${RouteParams.channelInvitationId}',
  );
  static Route inboxInvitesSent = Route(
    name: 'inboxInvitesSent',
    path: '${inboxInvites.path}/sent',
  );
  static Route inboxInvitesSentId = Route(
    name: 'inboxInvitesSentId',
    path: '${inboxInvitesSent.path}/:${RouteParams.channelInvitationId}',
  );
  static Route inboxArchived = Route(
    name: 'inboxArchived',
    path: '${inbox.path}/archived',
  );
  static Route inboxArchivedChannelId = Route(
    name: 'inboxArchivedChannelId',
    path: '${inboxArchived.path}/:${RouteParams.channelId}',
  );
  static Route profile = Route(
    name: 'profile',
    path: '/profile',
  );
  static Route profileId = Route(
    name: 'profileId',
    path: '${profile.path}/:${RouteParams.userId}',
  );
  static Route profileInvite = Route(
    name: 'profileInvite',
    path: '${profile.path}/invite',
  );
  static Route profileInviteId = Route(
    name: 'profileInviteId',
    path: '${profileInvite.path}/:${RouteParams.userId}',
  );
}

class RouteParams {
  RouteParams._private();
  static const String channelId = 'channelId';
  static const String channelInvitationId = 'channelInvitationId';
  static const String userId = 'userId';
  static const String nextRouteName = 'nextRouteName';
}

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags2.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableProfileCompletion = SharedFlags3.FFlagEnableProfileCompletion

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags4.FFlagSocialEnableProfileInspectAndBuy
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)
local SharedFlags5 = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags5.FFlagFriendsCallingClientGate_DEV
local SharedFlags6 = require(parent.SharedFlags)
local FFlagUseUserCtaCommonEnums = SharedFlags6.FFlagUseUserCtaCommonEnums
local SharedFlags7 = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags7.FFlagJoinabilityCTARefactor

local UserCtaCommon = require(parent.UserCtaCommon)
local userCtaAction

if FFlagUseUserCtaCommonEnums then
	userCtaAction = UserCtaCommon.Enums.UserCtaAction
else
	userCtaAction = nil
end

local function buildSharedProfileActions()
	local clone = table.clone(userCtaAction)

	clone.Call = not FFlagFriendsCallingClientGate_DEV and "" or userCtaAction.Call
	clone.EditAppearance = not FFlagProfilePlatformEnableEditAppearanceMenu and "" or userCtaAction.EditAppearance

	clone.EditEmotes = not FFlagProfilePlatformEnableEditAppearanceMenu and "" or userCtaAction.EditEmotes
	clone.SwitchAvatar = not FFlagProfilePlatformEnableEditAppearanceMenu and "" or userCtaAction.SwitchAvatar

	clone.EditBackground = not (FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem)
		and ""
		or userCtaAction.EditBackground

	clone.CurrencyTransfer = not FFlagProfilePlatformEnableCurrencyTransfer and "" or userCtaAction.CurrencyTransfer

	clone.TradeItems = not FFlagProfilePlatformEnableTradeItems and "" or userCtaAction.TradeItems
	clone.ContextualOverflow = userCtaAction.ContextualOverflow

	clone.PlayExperience = not FFlagJoinabilityCTARefactor and "" or userCtaAction.PlayExperience
	clone.ViewProfile = not FFlagJoinabilityCTARefactor and "" or userCtaAction.ViewProfile
	clone.UnlockExperience = not FFlagJoinabilityCTARefactor and "" or userCtaAction.UnlockExperience

	return clone
end

return {
	Components = {
		About = "About",
		Actions = "Actions",
		CoverPhoto = "CoverPhoto",
		CurrentlyWearing = "CurrentlyWearing",
		FavoriteExperiences = "FavoriteExperiences",
		Store = "Store",
		SocialLinks = "SocialLinks",
		UserProfileHeader = "UserProfileHeader",
		ViewFullProfile = "ViewFullProfile",
		Inventory = "Inventory",
		CommunityProfileHeader = "CommunityProfileHeader",
		Experiences = "Experiences",
		ContactProfileHeader = "ContactProfileHeader",
		ContactDescription = "ContactDescription",
		CommunityLocked = "CommunityLocked",
		CommunityDeactivated = "CommunityDeactivated",
		ProfileBackground = "ProfileBackground",
		ProfileCompletion = FFlagEnableProfileCompletion and "ProfileCompletion" or "",
		Events = "Events",
		CurrentlyPlaying = "CurrentlyPlaying",
		Friends = "Friends",
		Moments = FFlagProfilePlatformEnableMoments and "UserMoments" or "",
		Announcements = "Announcements",
		GroupForumsDiscovery = "ForumsDiscovery"
	},
	ProfileActions = not FFlagUseUserCtaCommonEnums and {
		AcceptFriendRequest = "AcceptFriendRequest",
		AcceptOffNetworkFriendRequest = "AcceptOffNetworkFriendRequest",
		AddFriend = "AddFriend",
		AddFriendFromContacts = "AddFriendFromContacts",
		AddFriendFromContactsSent = "AddFriendFromContactsSent",
		AddTrustedConnection = "AddTrustedConnection",
		AddTrustedConnectionViaLink = "AddTrustedConnectionViaLink",
		AddIncomingTrustedConnection = "AddIncomingTrustedConnection",
		PendingTrustedConnection = "PendingTrustedConnection",
		PendingIncomingTrustedConnection = "PendingIncomingTrustedConnection",
		Block = "Block",
		CannotAddFriend = "CannotAddFriend",
		Call = FFlagFriendsCallingClientGate_DEV and "Call" or "",
		Chat = "Chat",
		EditAlias = "EditAlias",
		EditAppearance = FFlagProfilePlatformEnableEditAppearanceMenu and "EditAppearance" or "",
		EditAvatar = "EditAvatar",
		EditLook = "EditLook",
		EditEmotes = FFlagProfilePlatformEnableEditAppearanceMenu and "EditEmotes" or "",
		SwitchAvatar = FFlagProfilePlatformEnableEditAppearanceMenu and "SwitchAvatar" or "",
		EditBackground = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem and "EditBackground" or "",
		EditProfile = "EditProfile",
		IgnoreFriendRequest = "IgnoreFriendRequest",
		JoinExperience = "JoinExperience",
		PendingFriendRequest = "PendingFriendRequest",
		QrCode = "QrCode",
		Report = "Report",
		ShareProfile = "ShareProfile",
		Unblock = "Unblock",
		Unfriend = "Unfriend",
		CopyLink = "CopyLink",
		JoinCommunity = "JoinCommunity",
		CancelJoinCommunityRequest = "CancelJoinCommunityRequest",
		ViewCommunity = "ViewCommunity",
		ViewFullProfile = "ViewFullProfile",
		LeaveCommunity = "LeaveCommunity",
		MakePrimaryCommunity = "MakePrimaryCommunity",
		RemovePrimaryCommunity = "RemovePrimaryCommunity",
		Follow = "Follow",
		Unfollow = "Unfollow",
		RemoveTrustedConnection = "RemoveTrustedConnection",
		ViewPlatformProfile = "ViewPlatformProfile",
		ViewAbout = "ViewAbout",
		CurrencyTransfer = FFlagProfilePlatformEnableCurrencyTransfer and "CurrencyTransfer" or "",
		TradeItems = FFlagProfilePlatformEnableTradeItems and "TradeItems" or "",
		ContextualOverflow = "ContextualOverflow",
		UnlockChat = "UnlockChat",
		PlayExperience = FFlagJoinabilityCTARefactor and "PlayExperience" or "",
		ViewProfile = "",
		UnlockExperience = ""
	} or buildSharedProfileActions(),
	DisabledReasons = {
		BannedFromCommunity = "BannedFromCommunity",
		CommunityIsClosed = "CommunityIsClosed",
		MaxCommunitiesJoined = "MaxCommunitiesJoined",
		InsufficientVerificationLevelLow = "InsufficientVerificationLevelLow",
		InsufficientVerificationLevelMedium = "InsufficientVerificationLevelMedium",
		InsufficientVerificationLevelHigh = "InsufficientVerificationLevelHigh",
		AccountCreatedLessThanOneDay = "AccountCreatedLessThanOneDay",
		AccountCreatedLessThanThreeDays = "AccountCreatedLessThanThreeDays",
		AccountCreatedLessThanOneWeek = "AccountCreatedLessThanOneWeek",
		AccountCreatedLessThanOneMonth = "AccountCreatedLessThanOneMonth",
		AccountCreatedLessThanThreeMonths = "AccountCreatedLessThanThreeMonths"
	},
	ProfileTypes = { User = "User", Community = "Community", Contact = "Contact" },
	Sources = {
		HomepageFriendsCarousel = "HomepageFriendsCarousel",
		OffNetworkFriendRequest = "OffNetworkFriendRequest",
		PlayerSearch = "PlayerSearch",
		ProfileDeepLink = "ProfileDeepLink",
		ProfileShare = "ProfileShare",
		QrCode = "QrCode",
		HomepageAd = "HomepageAd",
		ItemDetailsPage = "ItemDetailsPage",
		MutualConnectionsList = "MutualConnectionsList",
		InExperienceProfile = FFlagAddIEMProfilePage and "InExperienceProfile" or "",
		JoinGameCard = "JoinGameCard",
		MomentsFeed = FFlagProfilePlatformEnableMoments and "MomentsFeed" or "",
		SchoolMemberList = "SchoolMemberList"
	},
	ContextualTypes = {
		AccountDeleted = "AccountDeleted",
		Presence = "Presence",
		IsYourself = "IsYourself",
		PreviousUsername = "PreviousUsername",
		YouAreFollowing = "YouAreFollowing",
		FollowsYou = "FollowsYou",
		MutualFriends = "MutualFriends",
		PlayedTogether = "PlayedTogether",
		OffNetworkFriendRequest = "OffNetworkFriendRequest",
		SentFromQrCode = "SentFromQrCode",
		SentFromExperience = "SentFromExperience"
	},
	PresenceTypes = {
		Online = "Online",
		Offline = "Offline",
		InGame = "InGame",
		InStudio = "InStudio"
	},
	Screens = {
		ProfileMain = "ProfileMain",
		ItemDetails = "ItemDetails",
		ItemOrBundleDetails = "ItemOrBundleDetails",
		EditProfilePage = "EditProfilePage",
		EditDisplayNameErrorModal = "EditDisplayNameErrorModal",
		UsernameInsufficientFundsModal = "UsernameInsufficientFundsModal",
		SetAliasModal = "SetAliasModal",
		SetNicknameModal = "SetNicknameModal",
		ContextualMenu = "ContextualMenu",
		EditProfileBackground = "EditProfileBackground",
		CommunityVerificationModal = "CommunityVerificationModal",
		TransferRobuxFlow = FFlagProfilePlatformEnableCurrencyTransfer and "TransferRobuxFlow" or "",
		PurchaseConfirmationModal = "PurchaseConfirmationModal",
		InsufficientRobuxDialog = FFlagSocialEnableProfileInspectAndBuy and "InsufficientRobuxDialog" or "",
		InspectAvatarSheet = FFlagSocialEnableProfileInspectAndBuy and "InspectAvatarSheet" or "",
		MomentsAll = FFlagProfilePlatformEnableMoments and "MomentsAll" or "",
		MomentsFeed = FFlagProfilePlatformEnableMoments and "MomentsFeed" or ""
	},
	NameTypes = { Alias = "Alias", DisplayName = "DisplayName", Username = "Username" },
	ButtonSurface = { Actions = "Actions", ContextualMenu = "ContextualMenu" },
	ItemTypes = { Asset = "Asset", Bundle = "Bundle" },
	FriendStatus = {
		Self = "self",
		NotFriends = "nonfriend",
		Friends = "friend",
		RequestSent = "requestSent",
		RequestReceived = "requestReceived",
		Ineligible = "ineligible",
		Unknown = "unknown"
	},
	PriceLineContentType = { Price = "price", Text = "text" },
	SocialMediaTypes = {
		Twitter = "twitter",
		Facebook = "facebook",
		Discord = "discord",
		YouTube = "youtube",
		Twitch = "twitch",
		Guilded = "guilded",
		X = "x"
	},
	ViewFullProfileTypes = { Profile = "Profile", Community = "Community" },
	ProfileFormFactor = { Wide = "Wide", PeekView = "PeekView" },
	ProfileTabVariants = { Default = "Default", MeTab = "MeTab" },
	ProfileAvatarLayoutVariant = { Default = "Default", MeTabMobile = "MeTabMobile" },
	LoadingState = { Failed = "Failed", Finished = "Finished", Loading = "Loading" },
	SocialCountEnableKeys = {
		IsFriendsCountEnabled = "isFriendsCountEnabled",
		IsFollowersCountEnabled = "isFollowersCountEnabled",
		IsFollowingsCountEnabled = "isFollowingsCountEnabled",
		IsMutualFriendsCountEnabled = "isMutualFriendsCountEnabled"
	}
}

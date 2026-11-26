local fFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddIEMProfilePage

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")
local fFlagEnableProfileCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableProfileCompletion

local FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")

local FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local FFlagProfilePlatformEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")
local fFlagFriendsCallingClientGate_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagFriendsCallingClientGate_DEV
local fFlagUseUserCtaCommonEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagUseUserCtaCommonEnums
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagJoinabilityCTARefactor

local UserCtaCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserCtaCommon")
local userCtaAction = if fFlagUseUserCtaCommonEnums then UserCtaCommon.Enums.UserCtaAction else nil

local function buildSharedProfileActions()
	local clone = table.clone(userCtaAction)

	clone.Call = not fFlagFriendsCallingClientGate_DEV and "" or userCtaAction.Call
	clone.EditAppearance = not FFlagProfilePlatformEnableEditAppearanceMenu and "" or userCtaAction.EditAppearance

	clone.EditEmotes = not FFlagProfilePlatformEnableEditAppearanceMenu and "" or userCtaAction.EditEmotes
	clone.SwitchAvatar = not FFlagProfilePlatformEnableEditAppearanceMenu and "" or userCtaAction.SwitchAvatar

	clone.EditBackground = not (FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem) and "" or userCtaAction.EditBackground

	clone.CurrencyTransfer = not fFlagProfilePlatformEnableCurrencyTransfer and ""
		or userCtaAction.CurrencyTransfer

	clone.TradeItems = not FFlagProfilePlatformEnableTradeItems and "" or userCtaAction.TradeItems
	clone.ContextualOverflow = userCtaAction.ContextualOverflow

	clone.PlayExperience = not fFlagJoinabilityCTARefactor and "" or userCtaAction.PlayExperience
	clone.ViewProfile = not fFlagJoinabilityCTARefactor and "" or userCtaAction.ViewProfile
	clone.UnlockExperience = not fFlagJoinabilityCTARefactor and "" or userCtaAction.UnlockExperience

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
		ProfileCompletion = fFlagEnableProfileCompletion and "ProfileCompletion" or "",
		Events = "Events",
		CurrentlyPlaying = "CurrentlyPlaying",
		Friends = "Friends",
		Moments = FFlagProfilePlatformEnableMoments and "UserMoments" or "",
		Announcements = "Announcements",
		GroupForumsDiscovery = "ForumsDiscovery"
	},
	ProfileActions = not fFlagUseUserCtaCommonEnums and {
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
		Call = fFlagFriendsCallingClientGate_DEV and "Call" or "",
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
		CurrencyTransfer = fFlagProfilePlatformEnableCurrencyTransfer and "CurrencyTransfer" or "",
		TradeItems = FFlagProfilePlatformEnableTradeItems and "TradeItems" or "",
		ContextualOverflow = "ContextualOverflow",
		UnlockChat = "UnlockChat",
		PlayExperience = fFlagJoinabilityCTARefactor and "PlayExperience" or "",
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
		InExperienceProfile = fFlagAddIEMProfilePage and "InExperienceProfile" or "",
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
		TransferRobuxFlow = fFlagProfilePlatformEnableCurrencyTransfer and "TransferRobuxFlow" or "",
		PurchaseConfirmationModal = "PurchaseConfirmationModal",
		InsufficientRobuxDialog = fFlagSocialEnableProfileInspectAndBuy and "InsufficientRobuxDialog" or "",
		InspectAvatarSheet = fFlagSocialEnableProfileInspectAndBuy and "InspectAvatarSheet" or "",
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

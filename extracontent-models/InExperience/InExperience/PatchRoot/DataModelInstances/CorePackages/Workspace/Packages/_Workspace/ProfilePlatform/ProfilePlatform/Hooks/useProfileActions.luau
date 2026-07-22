local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local GuiService = game:GetService("GuiService")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Foundation = require(ProfilePlatformParent.Foundation)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local SocialCommon = require(ProfilePlatformParent.SocialCommon)
local Navigation = require(ProfilePlatformParent.Navigation)
local SetAlias = require(ProfilePlatformParent.SetAlias)
local SocialExperienceJoin = require(ProfilePlatformParent.SocialExperienceJoin)
local RobloxAppEnums = require(ProfilePlatformParent.RobloxAppEnums)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local Http = require(ProfilePlatformParent.Http)
local UrlBuilder = require(ProfilePlatformParent.UrlBuilder).UrlBuilder
local UrlBase = require(ProfilePlatformParent.UrlBuilder).UrlBase
local Images = UIBlox.App.ImageSet.Images
local HttpService = game:GetService("HttpService")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useNavigation = Navigation.useNavigation
local CloseCentralOverlay = require(ProfilePlatformParent.CentralOverlay).Thunks.CloseCentralOverlay
local default = require(ProfilePlatformParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local Url = Http.Url
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v34 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local AppPage = RobloxAppEnums.AppPage
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local NetworkingFriends = require(ProfilePlatform.Networking.NetworkingFriends)
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local ProfileShareLinks = require(ProfilePlatformParent.ProfileShareLinks)
local Contexts = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local Sources = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Sources
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local refreshProfilePlatform = require(ProfilePlatform.Networking.refreshProfilePlatform)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local useAboutSections = require(ProfilePlatform.Hooks.useAboutSections)
local useActionsComponentRequest = require(ProfilePlatform.Hooks.useActionsComponentRequest)
local GroupsNetworking = require(ProfilePlatform.Networking.GroupsNetworking)
local myUserBlockingNetworking = require(ProfilePlatform.Networking.myUserBlockingNetworking)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local getPlatformFriendsService = require(ProfilePlatform.Utils.getPlatformFriendsService)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Enums = require(ProfilePlatform.Common.Enums)
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local useProfileShareLink = ProfileShareLinks.Hooks.useProfileShareLink
local useShortUrl = ProfileShareLinks.Hooks.useShortUrl
local useGetOrGenerateLinkUrl = ProfileShareLinks.Hooks.useGetOrGenerateLinkUrl
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local ProfileSharePolicyEnum = ProfileShareLinks.Enums.ProfileSharePolicyEnum
local DataHydration = require(ProfilePlatformParent.DataHydration)
local FFlagEnableAbuseReportRevampFlow = SharedFlags.FFlagEnableAbuseReportRevampFlow
local FFlagMoveInExperienceModeToEditProfile = require(ProfilePlatformParent.SharedFlags).FFlagMoveInExperienceModeToEditProfile
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage)
local FFlagEnablePlatformProfileContextualMenuOption = require(ProfilePlatformParent.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagPendingIncomingTrustedConnection = require(ProfilePlatform.Flags.FFlagPendingIncomingTrustedConnection)
local FFlagProfilePlatformPassPresenceToJoinUserInExperience = SharedFlags.FFlagProfilePlatformPassPresenceToJoinUserInExperience
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v76 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.FriendsCommon).Hooks.useGetPresenceByUserId
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local FFlagEnableAbuseReportRevampProfileAndGroup = require(ProfilePlatform.Flags.FFlagEnableAbuseReportRevampProfileAndGroup)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)
local v84 = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem
local ProfileActions = require(ProfilePlatform.Components.CTARow.ProfileActions)
local AbuseVector = require(ProfilePlatformParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(ProfilePlatformParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = require(ProfilePlatformParent.AppChat.EnteredChatFromEntryPoint)
local NotificationTypeList = GuiService:GetNotificationTypeList()
local FriendRequestNicknamesIXP = require(ProfilePlatformParent.FriendRequestNicknames).FriendRequestNicknamesIXP
local Enums2 = require(ProfilePlatformParent.CurrencyTransfers).Enums
local TransferDirection = Enums2.TransferDirection
local TransferOrigination = Enums2.TransferOrigination
local Constants = require(ProfilePlatform.Common.Constants)
local Presence = require(ProfilePlatform.Rodux.Presence)
local FFlagProfilePlatformEnableUnlockChat = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUnlockChat)
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local USER_BLOCKING_ERRORS = Constants.USER_BLOCKING_ERRORS
local USER_FRIENDING_ERRORS = Constants.USER_FRIENDING_ERRORS
local STATUS_CODES = Constants.STATUS_CODES
local v102 = `{ Url.BASE_URL }share/g/%s`
local str = tostring(DateTime.now().UnixTimestampMillis)

local function areFollowActionsSupportedForProfileType(s1: string) -- line: 135
	-- upvalues: Enums (copy)
	return s1 == Enums.ProfileTypes.Community
end

local v105 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
local t1 = {
	skipFetch = true
}

return function(p1) -- line: 156
	-- upvalues: useLocalUserId (copy), useDispatch (copy), useNavigation (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useShortUrl (copy), useGetOrGenerateLinkUrl (copy), useEffectOnce (copy), React (copy), str (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), useLocalization (copy), Enums (copy), FFlagProfilePlatformAddTC (copy), FFlagProfilePlatformEnableUnlockChat (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), FFlagProfilePlatformEditBackgroundMenuItem (copy), FFlagProfilePlatformEnableEditLook (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagEnablePlatformProfileContextualMenuOption (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), FFlagProfilePlatformPresenceStoreMigration (copy), v76 (copy), t1 (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), useSelector (copy), Presence (copy), useAboutSections (copy), FFlagProfileAboutDetailsUseSheet (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), useJoinUserInExperience (copy), v84 (copy), IconName (copy), EventNames (copy), FriendRequestNicknamesIXP (copy), useProfileShareLink (copy), Contexts (copy), ProfileSharePolicyEnum (copy), USER_FRIENDING_ERRORS (copy), STATUS_CODES (copy), HttpService (copy), SetCurrentToastMessage (copy), FFlagProfilePlatformCTAsRefactor (copy), ProfileActions (copy), ButtonVariant (copy), NetworkingFriends (copy), Images (copy), refreshProfilePlatformActionInfo (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy), ButtonType (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), SocialStopwatch (copy), SetAlias (copy), Foundation (copy), FFlagAXEnableProfileTab (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy), default (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), Url (copy), myUserBlockingNetworking (copy), USER_BLOCKING_ERRORS (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy), v102 (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), UrlBuilder (copy), UrlBase (copy), v105 (copy), Sources (copy), FFlagPendingIncomingTrustedConnection (copy), getPlatformFriendsService (copy), TransferDirection (copy), TransferOrigination (copy)
	local v109 = useLocalUserId()
	local v110 = useDispatch()
	local v111 = useNavigation()
	local v112 = useProfileWrapperContext()
	local v113 = v112.navigateTo and v112.navigateTo.navigateToTransfer or nil
	local v114 = useProfileAnalyticsContext()
	local v115 = useShortUrl()
	local v116 = useGetOrGenerateLinkUrl()
	local v117 = v115 ~= nil

	useEffectOnce(v116, not v117)

	local v118 = React.useMemo(function() -- line: 170
		-- upvalues: v115 (copy), str (copy)
		return string.format("%s&source=ProfileShare&stamp=%s", v115 or "", str)
	end, { v115 })
	local v119 = if not FFlagConnectionsToFriendsRename then TextKeys.AcceptConnection else TextKeys.AcceptFriend
	local v120 = if not FFlagConnectionsToFriendsRename then TextKeys.AddConnection else TextKeys.AddFriend
	local v121 = useLocalization({
		[Enums.ProfileActions.AcceptFriendRequest] = v119,
		[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = v119,
		[Enums.ProfileActions.AddFriend] = v120,
		[Enums.ProfileActions.AddFriendFromContacts] = v120,
		[Enums.ProfileActions.AddFriendFromContactsSent] = TextKeys.PendingRequest,
		[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else TextKeys.AddTrustedConnection,
		[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else TextKeys.AcceptTrustedConnection,
		[Enums.ProfileActions.Block] = TextKeys.Block,
		[Enums.ProfileActions.CannotAddFriend] = v120,
		[Enums.ProfileActions.Chat] = TextKeys.Chat,
		[Enums.ProfileActions.UnlockChat] = if not FFlagProfilePlatformEnableUnlockChat then nil else TextKeys.UnlockChat,
		[Enums.ProfileActions.EditAlias] = TextKeys.CustomizeName,
		[Enums.ProfileActions.EditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else TextKeys.EditAppearance,
		[Enums.ProfileActions.EditEmotes] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else TextKeys.EditEmotes,
		[Enums.ProfileActions.SwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else TextKeys.SwitchAvatar,
		[Enums.ProfileActions.EditBackground] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEditBackgroundMenuItem then nil else TextKeys.EditBackground,
		[Enums.ProfileActions.EditAvatar] = TextKeys.EditAvatar,
		[Enums.ProfileActions.EditLook] = if not FFlagProfilePlatformEnableEditLook then nil else TextKeys.EditLook,
		[Enums.ProfileActions.EditProfile] = TextKeys.EditProfile,
		[Enums.ProfileActions.IgnoreFriendRequest] = if not FFlagConnectionsToFriendsRename then TextKeys.IgnoreConnectionRequest else TextKeys.IgnoreFriendRequest,
		[Enums.ProfileActions.JoinExperience] = TextKeys.Join,
		[Enums.ProfileActions.PendingFriendRequest] = TextKeys.PendingRequest,
		[Enums.ProfileActions.QrCode] = TextKeys.ToQRCode,
		[Enums.ProfileActions.Report] = TextKeys.Report,
		[Enums.ProfileActions.ShareProfile] = TextKeys.ShareProfile,
		[Enums.ProfileActions.Unblock] = TextKeys.Unblock,
		[Enums.ProfileActions.Unfriend] = if not FFlagConnectionsToFriendsRename then TextKeys.RemoveConnection else TextKeys.Unfriend,
		[Enums.ProfileActions.CopyLink] = TextKeys.CopyLink,
		[Enums.ProfileActions.JoinCommunity] = TextKeys.JoinCommunity,
		[Enums.ProfileActions.CancelJoinCommunityRequest] = TextKeys.CancelJoinCommunityRequest,
		[Enums.ProfileActions.ViewCommunity] = TextKeys.ViewCommunity,
		[Enums.ProfileActions.ViewFullProfile] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else TextKeys.ViewFullProfile,
		[Enums.ProfileActions.LeaveCommunity] = TextKeys.LeaveCommunity,
		[Enums.ProfileActions.MakePrimaryCommunity] = TextKeys.MakePrimaryCommunity,
		[Enums.ProfileActions.RemovePrimaryCommunity] = TextKeys.RemovePrimaryCommunity,
		[Enums.ProfileActions.Follow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else TextKeys.Follow,
		[Enums.ProfileActions.Unfollow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else TextKeys.Unfollow,
		[Enums.ProfileActions.RemoveTrustedConnection] = TextKeys.RemoveTrustedConnection,
		[Enums.ProfileActions.ViewAbout] = if not FFlagProfilePlatformNewProfileHeader then nil else TextKeys.AboutThisProfile,
		[Enums.ProfileActions.ViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else TextKeys.ViewPlatformProfile,
		[Enums.ProfileActions.CurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else TextKeys.CurrencyTransfer,
		friendAcceptedToast = if not FFlagConnectionsToFriendsRename then TextKeys.ConnectionAdded else TextKeys.FriendAdded,
		friendRemovedToast = if not FFlagConnectionsToFriendsRename then TextKeys.ConnectionRemoved else TextKeys.FriendRemoved,
		trustedConnectionRemovedToast = TextKeys.TrustedConnectionRemoved,
		friendRequestSentToast = if not FFlagConnectionsToFriendsRename then TextKeys.ConnectionRequestSent else TextKeys.FriendRequestSent,
		friendRequestIgnoredToast = TextKeys.RequestIgnored,
		userBlockedToast = TextKeys.UserBlocked,
		blockLimitReachedToast = TextKeys.BlockLimitReached,
		blocktargetAlreadyBlockedToast = TextKeys.BlockTargetAlreadyBlocked,
		blockedOnPlatformToast = TextKeys.UnblockTargetBlockedOnPlatform,
		unblockTargetNotBlockedToast = TextKeys.UnblockTargetNotBlocked,
		unblockTargetParentManagedToast = TextKeys.UnblockTargetParentManaged,
		somethingIsWrongToast = TextKeys.SomethingIsWrong,
		alreadyFriendError = TextKeys.AlreadyFriendError,
		defaultFriendingError = TextKeys.DefaultFriendingError,
		invalidNicknameError = TextKeys.InvalidNicknameError,
		invalidTargetUserError = TextKeys.InvalidTargetUserError,
		maxFriendsError = TextKeys.MaxFriendsError,
		unauthorizedError = TextKeys.UnauthorizedError,
		userBannedError = TextKeys.UserBannedError,
		userBlockedError = TextKeys.UserBlockedError,
		userNotPassedCaptchaError = TextKeys.UserNotPassedCaptchaError,
		tooManyRequestsError = TextKeys.TooManyRequestsError
	})
	local v122 = React.useCallback(function() -- line: 284
		-- upvalues: v112 (copy)
		v112.navigateTo.previousView(true)
	end, { v112.navigateTo.previousView })
	local profileId = v112.profileId
	local v124 = if not FFlagEnablePlatformProfileContextualMenuOption then nil else v112.profilePlatformId
	local profileType = v112.profileType
	local v126 = if not FFlagProfilePlatformPresenceStoreMigration then if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then nil else useSelector(function(p2) -- line: 299
		-- upvalues: Presence (copy), profileId (copy)
		return Presence.Selectors.getUserPresenceByUserId(p2, profileId) or {
			lastLocation = "",
			userPresenceType = Presence.Enums.PresenceType.Offline
		}
	end) else v76(profileId, t1)
	local aboutSections = nil
	local u128 = nil

	if FFlagProfilePlatformNewProfileHeader then
		local v129 = useAboutSections()

		aboutSections = v129.aboutSections
		u128 = if not FFlagProfileAboutDetailsUseSheet then nil else v129.profileName
	end

	local v130 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local v131 = useJoinUserInExperience(profileId, {
		isHomePageCarousel = v112.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
		homepageCarouselAbsolutePosition = v112.sourceInfo.homepageCarouselAbsolutePosition,
		openGameDetailsPeekViewClosed = v122,
		presence = if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then nil else v126
	})
	local qRCodePage = v112.navigateTo.qRCodePage
	local editUsername = v112.navigateTo.editUsername
	local v134 = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v112.navigateTo.editEmotes
	local v135 = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v112.navigateTo.switchAvatar

	local function getEditBackgroundAction() -- line: 338
		-- upvalues: v84 (copy), v112 (copy), v121 (copy), Enums (copy), IconName (copy), v114 (copy), EventNames (copy), p1 (copy)
		if v84 then
			local editBackground = v112.navigateTo.editBackground

			return {
				text = v121[Enums.ProfileActions.EditBackground],
				icon = IconName.Image,
				onActivated = function() -- line: 344
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), editBackground (copy)
					v114.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditBackground, {
						buttonSurface = p1
					})
					editBackground()
				end
			}
		end

		return nil
	end

	local editAvatar = v112.navigateTo.editAvatar
	local v138 = FriendRequestNicknamesIXP.useFriendRequestNicknames()
	local v139 = useProfileShareLink({
		context = Contexts.ProfileCard
	})
	local v140 = v139.policy == ProfileSharePolicyEnum.Disabled
	local t2 = {
		[USER_FRIENDING_ERRORS.INVALID_TARGET_USER_ERROR] = v121.invalidTargetUserError,
		[USER_FRIENDING_ERRORS.ALREADY_FRIEND_ERROR] = v121.alreadyFriendError,
		[USER_FRIENDING_ERRORS.MAX_FRIENDS_ERROR] = v121.maxFriendsError,
		[USER_FRIENDING_ERRORS.INVALID_NICKNAME_ERROR] = v121.invalidNicknameError
	}
	local t3 = {
		[USER_FRIENDING_ERRORS.UNAUTHORIZED_ERROR] = v121.unauthorizedError
	}
	local t4 = {
		[USER_FRIENDING_ERRORS.USER_BANNED_ERROR] = v121.userBannedError,
		[USER_FRIENDING_ERRORS.USER_BLOCKED_ERROR] = v121.userBlockedError,
		[USER_FRIENDING_ERRORS.USER_NOT_PASSED_CAPTCHA_ERROR] = v121.userNotPassedCaptchaError
	}
	local t5 = {
		[USER_FRIENDING_ERRORS.TOO_MANY_REQUESTS_ERROR] = v121.tooManyRequestsError
	}

	local function getErrorToastMessage(p3, p4, p5) -- line: 382
		-- upvalues: Enums (copy), STATUS_CODES (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
		if p3 == Enums.ProfileActions.AddFriend or p3 == Enums.ProfileActions.AddFriendFromContacts then
			if p4 == STATUS_CODES.BAD_REQUEST then
				return t2[p5]
			end

			if p4 == STATUS_CODES.UNAUTHORIZED then
				return t3[p5]
			end

			if p4 == STATUS_CODES.FORBIDDEN then
				return t4[p5]
			end

			if p4 == STATUS_CODES.TOO_MANY_REQUESTS then
				return t5[p5]
			end
		end

		return nil
	end
	local function setErrorToast(p6, p7) -- line: 397
		-- upvalues: HttpService (copy), Enums (copy), STATUS_CODES (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), v121 (copy), v110 (copy), SetCurrentToastMessage (copy)
		if p7 ~= nil then
			local StatusCode = p7.StatusCode
			local v156 = if not p7.Body then nil else HttpService:JSONDecode(p7.Body)
			local v157 = if not v156 or (not v156.errors or (not v156.errors[1] or not v156.errors[1].code)) then nil else v156.errors[1].code
			local v158 = ((if p6 ~= Enums.ProfileActions.AddFriend and p6 ~= Enums.ProfileActions.AddFriendFromContacts then nil else (if StatusCode ~= STATUS_CODES.BAD_REQUEST then (if StatusCode ~= STATUS_CODES.UNAUTHORIZED then (if StatusCode ~= STATUS_CODES.FORBIDDEN then (if StatusCode ~= STATUS_CODES.TOO_MANY_REQUESTS then nil else t5[v157]) else t4[v157]) else t3[v157]) else t2[v157]))) or v121.defaultFriendingError

			v110(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v158
			}))

			return
		end

		v110(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v121.defaultFriendingError
		}))
	end

	local v147 = if not FFlagProfilePlatformCTAsRefactor then nil else {
		localized = v121,
		analytics = v114,
		buttonSurface = p1,
		profileWrapperContext = v112,
		navigateTo = v112.navigateTo,
		dispatch = v110,
		profileId = profileId,
		localUserId = v109,
		navigation = v111,
		profileType = profileType,
		experienceUtilities = v131,
		friendRequestNicknamesEnabled = v138,
		profileShareLink = v139,
		PROFILE_SHARE_LINK_URL = v118,
		aboutSections = if not FFlagProfilePlatformNewProfileHeader then nil else aboutSections,
		aboutProfileName = if not FFlagProfileAboutDetailsUseSheet then nil else u128,
		actionsComponentRequest = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v130
	}

	return (React.useMemo(function() -- line: 444
		-- upvalues: FFlagProfilePlatformCTAsRefactor (copy), ProfileActions (copy), v147 (copy), Enums (copy), v121 (copy), ButtonVariant (copy), v114 (copy), EventNames (copy), p1 (copy), v112 (copy), v110 (copy), NetworkingFriends (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy), FriendRequestNicknamesIXP (copy), v138 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy), setErrorToast (copy), ButtonType (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), profileType (copy), v111 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), SocialStopwatch (copy), SetAlias (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), IconName (copy), editAvatar (copy), FFlagProfilePlatformEnableEditLook (copy), v134 (copy), v135 (copy), getEditBackgroundAction (copy), Foundation (copy), FFlagAXEnableProfileTab (copy), editUsername (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy), v131 (copy), qRCodePage (copy), v140 (copy), default (copy), Contexts (copy), v118 (copy), TextKeys (copy), v139 (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), Url (copy), myUserBlockingNetworking (copy), USER_BLOCKING_ERRORS (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy), v102 (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), UrlBuilder (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), UrlBase (copy), v105 (copy), FFlagProfilePlatformAddTC (copy), Sources (copy), FFlagPendingIncomingTrustedConnection (copy), FFlagProfilePlatformNewProfileHeader (copy), aboutSections (ref), FFlagProfileAboutDetailsUseSheet (copy), u128 (ref), FFlagEnablePlatformProfileContextualMenuOption (copy), getPlatformFriendsService (copy), v124 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v113 (copy), TransferDirection (copy), TransferOrigination (copy)
		if FFlagProfilePlatformCTAsRefactor then
			local t6 = {}

			for v160, v161 in ProfileActions do
				local v162 = v161(v147)

				if v162 ~= nil then
					t6[v160] = v162
				end
			end

			return t6
		end

		return {
			[Enums.ProfileActions.AcceptFriendRequest] = {
				text = v121[Enums.ProfileActions.AcceptFriendRequest],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 470
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), Enums (copy), v110 (copy), NetworkingFriends (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonAcceptFriendRequest, {
						buttonSurface = p1,
						absolutePosition = v112.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = v112.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = v112.sourceInfo.isRecommendation,
						source = v112.sourceInfo.source,
						contextualInfoType = v112.sourceInfo.contextualInfoType,
						recommendationContextType = v112.sourceInfo.recommendationContextType,
						recommendationRank = v112.sourceInfo.recommendationRank,
						recommendationSessionId = v112.sourceInfo.recommendationSessionId
					})

					return v110(NetworkingFriends.AcceptFriendRequestFromUserId.API({
						targetUserId = profileId,
						currentUserId = v109
					})):andThen(function() -- line: 486
						-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						v110(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v121.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end)
				end
			},
			[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = {
				text = v121[Enums.ProfileActions.AcceptOffNetworkFriendRequest],
				onActivated = function() -- line: 498
					-- upvalues: v114 (copy), EventNames (copy), v112 (copy), v110 (copy), NetworkingFriends (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonAddFriendFromContacts, {
						shareLinkId = v112.sourceInfo.shareLinkId
					})

					return v110(NetworkingFriends.AcceptFriendRequestWithToken.API({
						targetUserId = profileId,
						currentUserId = v109,
						friendingToken = v112.offNetworkFriendRequestToken
					})):andThen(function() -- line: 506
						-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						v110(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v121.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end)
				end
			},
			[Enums.ProfileActions.AddFriend] = {
				text = v121[Enums.ProfileActions.AddFriend],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 519
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), Enums (copy), FriendRequestNicknamesIXP (copy), v138 (copy), AppPage (copy), profileId (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), v110 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), NetworkingFriends (copy), v109 (copy), refreshProfilePlatformActionInfo (copy), v130 (copy), setErrorToast (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonAddFriend, {
						buttonSurface = p1,
						absolutePosition = v112.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = v112.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = v112.sourceInfo.isRecommendation,
						source = v112.sourceInfo.source,
						contextualInfoType = v112.sourceInfo.contextualInfoType,
						recommendationContextType = v112.sourceInfo.recommendationContextType,
						recommendationRank = v112.sourceInfo.recommendationRank,
						recommendationSessionId = v112.sourceInfo.recommendationSessionId
					})

					if FriendRequestNicknamesIXP.FFlagFriendRequestNicknames and v138 then
						local t7 = {
							name = AppPage.SetNicknameModal,
							extraProps = {
								friendRequestParams = {
									targetUserId = profileId,
									source = v112.sourceInfo.friendshipOriginSourceType
								}
							}
						}

						if FFlagSignalsNavP3Dispatch then
							return v34.down(v34.fromLegacyPage(t7))
						end

						return v110(NavigateDown(t7))
					end

					v110(SetCurrentToastMessage({
						isLocalized = true,
						toastMessage = v121.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"]
					}))

					return v110(NetworkingFriends.RequestFriendshipFromUserId.API({
						targetUserId = profileId,
						currentUserId = v109,
						friendshipOriginSourceType = v112.sourceInfo.friendshipOriginSourceType
					})):andThen(function() -- line: 559
						-- upvalues: v110 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end):catch(function(p8) -- line: 564
						-- upvalues: setErrorToast (copy), Enums (copy)
						setErrorToast(Enums.ProfileActions.AddFriend, p8)
					end)
				end
			},
			[Enums.ProfileActions.AddFriendFromContacts] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				text = v121[Enums.ProfileActions.AddFriendFromContacts],
				onActivated = function() -- line: 574
					-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), NetworkingFriends (copy), v109 (copy), profileId (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy), setErrorToast (copy)
					v110(SetCurrentToastMessage({
						isLocalized = true,
						toastMessage = v121.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"]
					}))

					return v110(NetworkingFriends.RequestFriendshipFromContactId.API({
						currentUserId = v109,
						contactId = profileId,
						contextType = ContextualInfoTypes.Contacts
					})):andThen(function() -- line: 585
						-- upvalues: v110 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						return v110(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = {
								Enums.Components.ContactProfileHeader,
								Enums.Components.Actions,
								Enums.Components.ContactDescription
							}
						}))
					end):catch(function(p9) -- line: 596
						-- upvalues: setErrorToast (copy), Enums (copy)
						setErrorToast(Enums.ProfileActions.AddFriendFromContacts, p9)
					end)
				end
			},
			[Enums.ProfileActions.AddFriendFromContactsSent] = {
				isDisabled = true,
				buttonType = ButtonType.Secondary,
				variant = ButtonVariant.Subtle,
				text = v121[Enums.ProfileActions.AddFriendFromContactsSent],
				onActivated = function() -- line: 605
				end
			},
			[Enums.ProfileActions.Block] = {
				text = v121[Enums.ProfileActions.Block],
				onActivated = function() -- line: 610
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v111 (copy), AppPage (copy), profileId (copy), v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonBlock, {
						buttonSurface = p1
					})
					v111.push(AppPage.BlockingModal, {
						navProps = {
							userId = profileId,
							onBlockSuccess = function() -- line: 617
								-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
								v110(SetCurrentToastMessage({
									isLocalized = true,
									toastMessage = v121.userBlockedToast,
									toastIcon = Images["icons/actions/block"]
								}))
								v110(refreshProfilePlatformActionInfo(profileId, v130))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.CannotAddFriend] = {
				isDisabled = true,
				text = v121[Enums.ProfileActions.CannotAddFriend],
				onActivated = function() -- line: 632
				end
			},
			[Enums.ProfileActions.Chat] = {
				text = v121[Enums.ProfileActions.Chat],
				variant = ButtonVariant.Standard,
				onActivated = function() -- line: 638
					-- upvalues: p1 (copy), Enums (copy), v114 (copy), EventNames (copy), v110 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), profileId (copy), NotificationTypeList (copy)
					if p1 == Enums.ButtonSurface.ContextualMenu then
						v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonChat, {
							buttonSurface = p1
						})
					else
						v114.fireAnalyticsEvent(EventNames.CTAButtonChat, {
							buttonSurface = p1
						})
					end

					v110(EnteredChatFromEntryPoint(ChatEntryPointNames.ProfilePeekView))
					GuiService:BroadcastNotification(profileId, NotificationTypeList.LAUNCH_CONVERSATION)
				end
			},
			[Enums.ProfileActions.EditAlias] = {
				text = v121[Enums.ProfileActions.EditAlias],
				onActivated = function() -- line: 655
					-- upvalues: SocialStopwatch (copy), v114 (copy), EventNames (copy), p1 (copy), v111 (copy), Enums (copy), profileId (copy), SetAlias (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonSetAlias, {
						buttonSurface = p1
					})
					v111.navigate(Enums.Screens.SetAliasModal, {
						profileUserId = profileId,
						origin = SetAlias.Analytics.EntryPoints.ContextualMenu
					})
				end
			},
			[Enums.ProfileActions.EditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v121[Enums.ProfileActions.EditAppearance],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 670
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonEditAppearance, {
						buttonSurface = p1
					})
				end
			},
			[Enums.ProfileActions.EditAvatar] = {
				text = v121[Enums.ProfileActions.EditAvatar],
				icon = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else IconName.Person,
				onActivated = function() -- line: 680
					-- upvalues: v114 (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), EventNames (copy), p1 (copy), editAvatar (copy)
					v114.fireAnalyticsEvent(if not FFlagProfilePlatformEnableEditAppearanceMenu then EventNames.CTAButtonEditAvatar else EventNames.EditAppearanceMenuEditAvatar, {
						buttonSurface = p1
					})
					editAvatar()
				end
			},
			[Enums.ProfileActions.EditLook] = if not FFlagProfilePlatformEnableEditLook then nil else {
				text = v121[Enums.ProfileActions.EditLook],
				icon = IconName.Person,
				onActivated = function() -- line: 696
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), editAvatar (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonEditLook, {
						buttonSurface = p1
					})
					editAvatar()
				end
			},
			[Enums.ProfileActions.EditEmotes] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v121[Enums.ProfileActions.EditEmotes],
				icon = IconName.SquareFaceWavingHand,
				onActivated = function() -- line: 708
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v134 (copy)
					v114.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditEmote, {
						buttonSurface = p1
					})
					v134()
				end
			},
			[Enums.ProfileActions.SwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v121[Enums.ProfileActions.SwitchAvatar],
				icon = IconName.PersonStandingArrowReverse,
				onActivated = function() -- line: 720
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v135 (copy)
					v114.fireAnalyticsEvent(EventNames.EditAppearanceMenuSwitchAvatar, {
						buttonSurface = p1
					})
					v135()
				end
			},
			[Enums.ProfileActions.EditBackground] = getEditBackgroundAction(),
			[Enums.ProfileActions.EditProfile] = {
				component = Foundation.Button,
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v121[Enums.ProfileActions.EditProfile],
				onActivated = function() -- line: 734
					-- upvalues: SocialStopwatch (copy), v114 (copy), EventNames (copy), p1 (copy), v111 (copy), Enums (copy), FFlagAXEnableProfileTab (copy), v112 (copy), editUsername (copy), v110 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy), FFlagMoveInExperienceModeToEditProfile (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.EditProfileOpened)
					v114.fireAnalyticsEvent(EventNames.CTAButtonOpenEditProfilePage, {
						buttonSurface = p1
					})
					v111.navigate(Enums.Screens.EditProfilePage, {
						profileScreens = Enums.Screens,
						fullBleed = if not FFlagAXEnableProfileTab then nil else v112.forceFullView == true,
						navigateToEditUsername = function(p10) -- line: 746
							-- upvalues: editUsername (copy), v110 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
							editUsername({
								showToast = p10,
								onUsernameChanged = function() -- line: 749
									-- upvalues: v110 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
									v110(refreshProfilePlatformUserInfo(profileId))
								end
							})
						end,
						onIdentityChange = function() -- line: 754
							-- upvalues: v110 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
							v110(refreshProfilePlatformUserInfo(profileId))
						end,
						onToggleInExperienceMode = if not FFlagMoveInExperienceModeToEditProfile then nil else function() -- line: 758
							-- upvalues: v110 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy), v114 (copy), EventNames (copy)
							v110(refreshProfilePlatformUserInfo(profileId))
							v114.fireAnalyticsEvent(EventNames.ToggleInExperienceModeButton, {})
						end
					})
				end
			},
			[Enums.ProfileActions.IgnoreFriendRequest] = {
				text = v121[Enums.ProfileActions.IgnoreFriendRequest],
				onActivated = function() -- line: 768
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v110 (copy), NetworkingFriends (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonIgnoreFriendRequest, {
						buttonSurface = p1
					})

					return v110(NetworkingFriends.DeclineFriendRequestFromUserId.API({
						targetUserId = profileId,
						currentUserId = v109
					})):andThen(function() -- line: 775
						-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						v110(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v121.friendRequestIgnoredToast,
							toastIcon = Images["icons/actions/reject"]
						}))

						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end)
				end
			},
			[Enums.ProfileActions.JoinExperience] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				isLoading = v131.isLoading,
				isDisabled = not v131.isInExperience,
				text = v121[Enums.ProfileActions.JoinExperience],
				onActivated = function() -- line: 792
					-- upvalues: v131 (copy)
					v131.joinExperience()
				end
			},
			[Enums.ProfileActions.PendingFriendRequest] = {
				isDisabled = true,
				buttonType = ButtonType.Secondary,
				variant = ButtonVariant.Subtle,
				text = v121[Enums.ProfileActions.PendingFriendRequest],
				onActivated = function() -- line: 801
				end
			},
			[Enums.ProfileActions.QrCode] = {
				text = v121[Enums.ProfileActions.QrCode],
				icon = IconName.SquaresGridQr,
				onActivated = function() -- line: 807
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), qRCodePage (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonShareProfileQRCode, {
						buttonSurface = p1
					})
					qRCodePage()
				end
			},
			[Enums.ProfileActions.ShareProfile] = {
				component = Foundation.Button,
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v121[Enums.ProfileActions.ShareProfile],
				onActivated = function() -- line: 819
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v140 (copy), default (copy), Contexts (copy), v118 (copy), profileId (copy), v110 (copy), SetCurrentToastMessage (copy), TextKeys (copy), v139 (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonShareProfile, {
						buttonSurface = p1
					})

					if v140 then
						default:setClipboardText({
							context = Contexts.ProfileCard,
							text = string.format("%s/%s", v118, profileId)
						})
						v110(SetCurrentToastMessage({
							toastMessage = TextKeys.LinkCopied
						}))

						return
					end

					v139.onActivated()
				end
			},
			[Enums.ProfileActions.Report] = {
				text = v121[Enums.ProfileActions.Report],
				onActivated = function() -- line: 838
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), profileType (copy), Enums (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), v110 (copy), OpenDynamicAbuseReport (copy), profileId (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), v130 (copy), AppPage (copy), Url (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
						buttonSurface = p1
					})

					local s2 = nil

					if profileType == Enums.ProfileTypes.User then
						s2 = "userprofile"
					elseif profileType == Enums.ProfileTypes.Community then
						s2 = "group"
					end

					if FFlagEnableAbuseReportRevampFlow and FFlagEnableAbuseReportRevampProfileAndGroup then
						local UserProfile = AbuseVector.UserProfile

						if profileType == Enums.ProfileTypes.Community then
							UserProfile = AbuseVector.Group
						end

						v110(OpenDynamicAbuseReport({
							abuseVector = UserProfile,
							targetId = profileId,
							onClose = function() -- line: 857
								-- upvalues: v110 (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
								v110(CloseCentralOverlay())
								v110(refreshProfilePlatformActionInfo(profileId, v130))
							end
						}))

						return
					end

					local t8 = {
						name = AppPage.GenericWebPage,
						detail = `{ Url.BASE_URL }abusereport/{ s2 }?id={ profileId }`,
						extraProps = {
							titleKey = TextKeys.Report
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t8))

						return
					end

					v110(NavigateDown(t8))
				end
			},
			[Enums.ProfileActions.Unblock] = {
				text = v121[Enums.ProfileActions.Unblock],
				onActivated = function() -- line: 880
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v110 (copy), myUserBlockingNetworking (copy), profileId (copy), v109 (copy), refreshProfilePlatformActionInfo (copy), v130 (copy), USER_BLOCKING_ERRORS (copy), SetCurrentToastMessage (copy), v121 (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonUnblock, {
						buttonSurface = p1
					})

					return v110(myUserBlockingNetworking.UnblockUserById.API({
						userId = profileId,
						currentUserId = v109
					})):andThen(function() -- line: 888
						-- upvalues: v110 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end):catch(function(p11) -- line: 891
						-- upvalues: USER_BLOCKING_ERRORS (copy), v110 (copy), SetCurrentToastMessage (copy), v121 (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy)
						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.PARENT_BLOCKED_TARGET_USER_ERROR then
							v110(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v121.unblockTargetParentManagedToast
							}))

							return
						end

						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_NOT_BLOCKED_ERROR then
							v110(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v121.unblockTargetNotBlockedToast
							}))

							return
						end

						if FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage and p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_BLOCKED_ON_PLATFORM then
							v110(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v121.blockedOnPlatformToast
							}))

							return
						end

						v110(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v121.somethingIsWrongToast
						}))
					end)
				end
			},
			[Enums.ProfileActions.Unfriend] = {
				text = v121[Enums.ProfileActions.Unfriend],
				onActivated = function() -- line: 934
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v110 (copy), NetworkingFriends (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfriend, {
						buttonSurface = p1
					})

					return v110(NetworkingFriends.UnfriendTargetUserId.API({
						targetUserId = profileId,
						currentUserId = v109
					})):andThen(function() -- line: 941
						-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						v110(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v121.friendRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end)
				end
			},
			[Enums.ProfileActions.CopyLink] = {
				text = v121[Enums.ProfileActions.CopyLink],
				onActivated = function() -- line: 953
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), default (copy), Contexts (copy), v102 (copy), profileId (copy), v110 (copy), SetCurrentToastMessage (copy), TextKeys (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonCopyLink, {
						buttonSurface = p1
					})
					default:setClipboardText({
						context = Contexts.ProfileCard,
						text = string.format(v102, profileId)
					})
					v110(SetCurrentToastMessage({
						toastMessage = TextKeys.LinkCopied
					}))
				end
			},
			[Enums.ProfileActions.JoinCommunity] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				text = v121[Enums.ProfileActions.JoinCommunity],
				onActivated = function() -- line: 971
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), v110 (copy), GroupsNetworking (copy), profileId (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonJoinCommunity, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					return v110(GroupsNetworking.JoinGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 979
						-- upvalues: v110 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v110(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.CancelJoinCommunityRequest] = {
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v121[Enums.ProfileActions.CancelJoinCommunityRequest],
				onActivated = function() -- line: 993
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), v110 (copy), GroupsNetworking (copy), profileId (copy), v109 (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonCancelJoinCommunityRequest, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					return v110(GroupsNetworking.CancelJoinGroupRequest.API({
						groupId = profileId,
						userId = v109
					})):andThen(function() -- line: 1002
						-- upvalues: v110 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v110(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			},
			[Enums.ProfileActions.ViewCommunity] = {
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.SubEmphasis,
				text = v121[Enums.ProfileActions.ViewCommunity],
				onActivated = function() -- line: 1017
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), AppPage (copy), UrlBuilder (copy), profileId (copy), TextKeys (copy), v110 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonViewCommunity, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					local t9 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.user.group({
							groupId = profileId
						}),
						extraProps = {
							titleKey = TextKeys.Community,
							onClose = function() -- line: 1028
								-- upvalues: v110 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
								v110(getProfilePlatform.API({
									includeComponentOrdering = true,
									profileType = profileType,
									profileId = profileId,
									components = getAvailableCommunityComponents()
								}))
							end
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t9))

						return
					end

					v110(NavigateDown(t9))
				end
			},
			[Enums.ProfileActions.ViewFullProfile] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else {
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.SubEmphasis,
				text = v121[Enums.ProfileActions.ViewFullProfile],
				onActivated = function() -- line: 1050
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), AppPage (copy), UrlBuilder (copy), UrlBase (copy), profileId (copy), TextKeys (copy), v110 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					local t10 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.new({
							base = UrlBase.WWW,
							path = `profiles/{ profileId }`
						})(),
						extraProps = {
							titleKey = TextKeys.Profile,
							onClose = function() -- line: 1064
								-- upvalues: v110 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
								v110(getProfilePlatform.API({
									includeComponentOrdering = true,
									profileType = profileType,
									profileId = profileId,
									components = getAvailableCommunityComponents()
								}))
							end
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t10))

						return
					end

					v110(NavigateDown(t10))
				end
			},
			[Enums.ProfileActions.LeaveCommunity] = {
				text = v121[Enums.ProfileActions.LeaveCommunity],
				onActivated = function() -- line: 1084
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), v110 (copy), GroupsNetworking (copy), profileId (copy), v109 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonLeaveCommunity, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					return v110(GroupsNetworking.LeaveGroup.API({
						groupId = profileId,
						userId = v109
					})):andThen(function() -- line: 1093
						-- upvalues: v110 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v110(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.MakePrimaryCommunity] = {
				text = v121[Enums.ProfileActions.MakePrimaryCommunity],
				onActivated = function() -- line: 1105
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), v110 (copy), GroupsNetworking (copy), profileId (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonMakePrimaryCommunity, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					return v110(GroupsNetworking.MakePrimaryGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 1113
						-- upvalues: v110 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v110(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			},
			[Enums.ProfileActions.RemovePrimaryCommunity] = {
				text = v121[Enums.ProfileActions.RemovePrimaryCommunity],
				onActivated = function() -- line: 1126
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), v110 (copy), GroupsNetworking (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemovePrimaryCommunity, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					return v110(GroupsNetworking.RemovePrimaryGroup.API()):andThen(function() -- line: 1132
						-- upvalues: v110 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v110(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			},
			[Enums.ProfileActions.Follow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities or profileType ~= Enums.ProfileTypes.Community then nil else {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Standard,
				text = v121[Enums.ProfileActions.Follow],
				onActivated = function() -- line: 1149
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v110 (copy), GroupsNetworking (copy), profileId (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = p1
					})

					return v110(GroupsNetworking.JoinGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 1155
						-- upvalues: v110 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v110(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.Unfollow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities or profileType ~= Enums.ProfileTypes.Community then nil else {
				text = v121[Enums.ProfileActions.Unfollow],
				onActivated = function() -- line: 1170
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v110 (copy), GroupsNetworking (copy), profileId (copy), v109 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = p1
					})

					return v110(GroupsNetworking.LeaveGroup.API({
						groupId = profileId,
						userId = v109
					})):andThen(function() -- line: 1178
						-- upvalues: v110 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v110(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.RemoveTrustedConnection] = {
				text = v121[Enums.ProfileActions.RemoveTrustedConnection],
				onActivated = function() -- line: 1191
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v105 (copy), profileId (copy), v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemoveTrustedConnection, {
						buttonSurface = p1
					})

					return v105.removeTrustedConnectionRequest(profileId):andThen(function() -- line: 1195
						-- upvalues: v110 (copy), SetCurrentToastMessage (copy), v121 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
						v110(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v121.trustedConnectionRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return v110(refreshProfilePlatformActionInfo(profileId, v130))
					end)
				end
			},
			[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				text = v121[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1208
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v111 (copy), AppPage (copy), profileId (copy), Sources (copy), v110 (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p1
					})
					v111.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							source = Sources.ProfilePlatform,
							onRequestSent = function() -- line: 1216
								-- upvalues: v110 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
								return v110(refreshProfilePlatformActionInfo(profileId, v130))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.AddTrustedConnectionViaLink] = {
				text = v121[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1228
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), Sources (copy), v111 (copy), AppPage (copy), profileId (copy), v110 (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p1,
						modalVariantOverride = Sources.ShareLinkSender
					})
					v111.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							source = Sources.ProfilePlatform,
							modalVariantOverride = Sources.ShareLinkSender,
							onRequestSent = function() -- line: 1238
								-- upvalues: v110 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
								return v110(refreshProfilePlatformActionInfo(profileId, v130))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				text = v121[Enums.ProfileActions.AddIncomingTrustedConnection],
				onActivated = function() -- line: 1250
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v111 (copy), AppPage (copy), profileId (copy), v110 (copy), refreshProfilePlatformActionInfo (copy), v130 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddIncomingTrustedConnection, {
						buttonSurface = p1
					})
					v111.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							onRequestAccepted = function() -- line: 1257
								-- upvalues: v110 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v130 (copy)
								return v110(refreshProfilePlatformActionInfo(profileId, v130))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.PendingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				isDisabled = true,
				text = v121[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1271
				end
			},
			[Enums.ProfileActions.PendingIncomingTrustedConnection] = if not FFlagPendingIncomingTrustedConnection then nil else {
				isDisabled = true,
				text = v121[Enums.ProfileActions.AddIncomingTrustedConnection],
				onActivated = function() -- line: 1278
				end
			},
			[Enums.ProfileActions.ViewAbout] = if not FFlagProfilePlatformNewProfileHeader then nil else {
				text = v121[Enums.ProfileActions.ViewAbout],
				onActivated = function() -- line: 1284
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), v112 (copy), AppPage (copy), aboutSections (ref), FFlagProfileAboutDetailsUseSheet (copy), u128 (ref), FFlagSignalsNavP3Dispatch (copy), v34 (copy), v110 (copy), NavigateDown (copy)
					v114.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1,
						btnContext = v112.sourceInfo.source
					})

					local t11 = {
						name = AppPage.AboutDetailsSheet,
						extraProps = {
							sections = aboutSections,
							profileName = if not FFlagProfileAboutDetailsUseSheet then nil else u128
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t11))

						return
					end

					v110(NavigateDown(t11))
				end
			},
			[Enums.ProfileActions.ViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else {
				text = v121[Enums.ProfileActions.ViewPlatformProfile],
				onActivated = function() -- line: 1310
					-- upvalues: v114 (copy), EventNames (copy), p1 (copy), getPlatformFriendsService (copy), v124 (copy)
					v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonViewPlatformProfile, {
						buttonSurface = p1
					})
					getPlatformFriendsService:ShowProfile(v124)
				end
			},
			[Enums.ProfileActions.CurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
				text = v121[Enums.ProfileActions.CurrencyTransfer],
				onActivated = function() -- line: 1321
					-- upvalues: p1 (copy), Enums (copy), v114 (copy), EventNames (copy), v113 (copy), profileId (copy), TransferDirection (copy), TransferOrigination (copy)
					if p1 == Enums.ButtonSurface.ContextualMenu then
						v114.fireAnalyticsEvent(EventNames.ContextualMenuButtonCurrencyTransfer, {
							buttonSurface = p1
						})
					else
						v114.fireAnalyticsEvent(EventNames.CTAButtonCurrencyTransfer, {
							buttonSurface = p1
						})
					end

					if v113 then
						v113({
							recipientUserId = profileId,
							direction = TransferDirection.Send,
							transferOrigination = TransferOrigination.Profile
						})
					end
				end
			}
		}
	end, {
		v110,
		profileId,
		v112,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v113,
		qRCodePage,
		v121,
		v109,
		v111,
		editUsername,
		v131.joinExperience,
		v131.isLoading,
		v114,
		v138,
		p1,
		if not FFlagProfilePlatformNewProfileHeader then nil else aboutSections,
		if not FFlagProfileAboutDetailsUseSheet then nil else u128,
		profileType,
		editAvatar,
		if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v134,
		if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v135,
		if not FFlagProfilePlatformCTAsRefactor then nil else v118,
		if not FFlagProfilePlatformCTAsRefactor then nil else v131.isInExperience,
		if not FFlagProfilePlatformCTAsRefactor then nil else v147,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v130
	}))
end

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
local FFlagEnablePlatformProfileContextualMenuOption = require(ProfilePlatformParent.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagPendingIncomingTrustedConnection = require(ProfilePlatform.Flags.FFlagPendingIncomingTrustedConnection)
local FFlagProfilePlatformPassPresenceToJoinUserInExperience = SharedFlags.FFlagProfilePlatformPassPresenceToJoinUserInExperience
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v75 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.FriendsCommon).Hooks.useGetPresenceByUserId
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local FFlagEnableAbuseReportRevampProfileAndGroup = require(ProfilePlatform.Flags.FFlagEnableAbuseReportRevampProfileAndGroup)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)
local v83 = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem
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
local v101 = `{ Url.BASE_URL }share/g/%s`
local str = tostring(DateTime.now().UnixTimestampMillis)

local function areFollowActionsSupportedForProfileType(s1: string) -- line: 133
	-- upvalues: Enums (copy)
	return s1 == Enums.ProfileTypes.Community
end

local v104 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
local t1 = {
	skipFetch = true
}

return function(p1) -- line: 154
	-- upvalues: useLocalUserId (copy), useDispatch (copy), useNavigation (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useShortUrl (copy), useGetOrGenerateLinkUrl (copy), useEffectOnce (copy), React (copy), str (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), useLocalization (copy), Enums (copy), FFlagProfilePlatformAddTC (copy), FFlagProfilePlatformEnableUnlockChat (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), FFlagProfilePlatformEditBackgroundMenuItem (copy), FFlagProfilePlatformEnableEditLook (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagEnablePlatformProfileContextualMenuOption (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), FFlagProfilePlatformPresenceStoreMigration (copy), v75 (copy), t1 (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), useSelector (copy), Presence (copy), useAboutSections (copy), FFlagProfileAboutDetailsUseSheet (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), useJoinUserInExperience (copy), v83 (copy), IconName (copy), EventNames (copy), FriendRequestNicknamesIXP (copy), useProfileShareLink (copy), Contexts (copy), ProfileSharePolicyEnum (copy), USER_FRIENDING_ERRORS (copy), STATUS_CODES (copy), HttpService (copy), SetCurrentToastMessage (copy), FFlagProfilePlatformCTAsRefactor (copy), ProfileActions (copy), ButtonVariant (copy), NetworkingFriends (copy), Images (copy), refreshProfilePlatformActionInfo (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy), ButtonType (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), SocialStopwatch (copy), SetAlias (copy), Foundation (copy), FFlagAXEnableProfileTab (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy), default (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), Url (copy), myUserBlockingNetworking (copy), USER_BLOCKING_ERRORS (copy), v101 (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), UrlBuilder (copy), UrlBase (copy), v104 (copy), Sources (copy), FFlagPendingIncomingTrustedConnection (copy), getPlatformFriendsService (copy), TransferDirection (copy), TransferOrigination (copy)
	local v108 = useLocalUserId()
	local v109 = useDispatch()
	local v110 = useNavigation()
	local v111 = useProfileWrapperContext()
	local v112 = v111.navigateTo and v111.navigateTo.navigateToTransfer or nil
	local v113 = useProfileAnalyticsContext()
	local v114 = useShortUrl()
	local v115 = useGetOrGenerateLinkUrl()
	local v116 = v114 ~= nil

	useEffectOnce(v115, not v116)

	local v117 = React.useMemo(function() -- line: 168
		-- upvalues: v114 (copy), str (copy)
		return string.format("%s&source=ProfileShare&stamp=%s", v114 or "", str)
	end, { v114 })
	local v118 = if not FFlagConnectionsToFriendsRename then TextKeys.AcceptConnection else TextKeys.AcceptFriend
	local v119 = if not FFlagConnectionsToFriendsRename then TextKeys.AddConnection else TextKeys.AddFriend
	local v120 = useLocalization({
		[Enums.ProfileActions.AcceptFriendRequest] = v118,
		[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = v118,
		[Enums.ProfileActions.AddFriend] = v119,
		[Enums.ProfileActions.AddFriendFromContacts] = v119,
		[Enums.ProfileActions.AddFriendFromContactsSent] = TextKeys.PendingRequest,
		[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else TextKeys.AddTrustedConnection,
		[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else TextKeys.AcceptTrustedConnection,
		[Enums.ProfileActions.Block] = TextKeys.Block,
		[Enums.ProfileActions.CannotAddFriend] = v119,
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
	local v121 = React.useCallback(function() -- line: 282
		-- upvalues: v111 (copy)
		v111.navigateTo.previousView(true)
	end, { v111.navigateTo.previousView })
	local profileId = v111.profileId
	local v123 = if not FFlagEnablePlatformProfileContextualMenuOption then nil else v111.profilePlatformId
	local profileType = v111.profileType
	local v125 = if not FFlagProfilePlatformPresenceStoreMigration then if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then nil else useSelector(function(p2) -- line: 297
		-- upvalues: Presence (copy), profileId (copy)
		return Presence.Selectors.getUserPresenceByUserId(p2, profileId) or {
			lastLocation = "",
			userPresenceType = Presence.Enums.PresenceType.Offline
		}
	end) else v75(profileId, t1)
	local aboutSections = nil
	local u127 = nil

	if FFlagProfilePlatformNewProfileHeader then
		local v128 = useAboutSections()

		aboutSections = v128.aboutSections
		u127 = if not FFlagProfileAboutDetailsUseSheet then nil else v128.profileName
	end

	local v129 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local v130 = useJoinUserInExperience(profileId, {
		isHomePageCarousel = v111.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
		homepageCarouselAbsolutePosition = v111.sourceInfo.homepageCarouselAbsolutePosition,
		openGameDetailsPeekViewClosed = v121,
		presence = if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then nil else v125
	})
	local qRCodePage = v111.navigateTo.qRCodePage
	local editUsername = v111.navigateTo.editUsername
	local v133 = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v111.navigateTo.editEmotes
	local v134 = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v111.navigateTo.switchAvatar

	local function getEditBackgroundAction() -- line: 336
		-- upvalues: v83 (copy), v111 (copy), v120 (copy), Enums (copy), IconName (copy), v113 (copy), EventNames (copy), p1 (copy)
		if v83 then
			local editBackground = v111.navigateTo.editBackground

			return {
				text = v120[Enums.ProfileActions.EditBackground],
				icon = IconName.Image,
				onActivated = function() -- line: 342
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), editBackground (copy)
					v113.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditBackground, {
						buttonSurface = p1
					})
					editBackground()
				end
			}
		end

		return nil
	end

	local editAvatar = v111.navigateTo.editAvatar
	local v137 = FriendRequestNicknamesIXP.useFriendRequestNicknames()
	local v138 = useProfileShareLink({
		context = Contexts.ProfileCard
	})
	local v139 = v138.policy == ProfileSharePolicyEnum.Disabled
	local t2 = {
		[USER_FRIENDING_ERRORS.INVALID_TARGET_USER_ERROR] = v120.invalidTargetUserError,
		[USER_FRIENDING_ERRORS.ALREADY_FRIEND_ERROR] = v120.alreadyFriendError,
		[USER_FRIENDING_ERRORS.MAX_FRIENDS_ERROR] = v120.maxFriendsError,
		[USER_FRIENDING_ERRORS.INVALID_NICKNAME_ERROR] = v120.invalidNicknameError
	}
	local t3 = {
		[USER_FRIENDING_ERRORS.UNAUTHORIZED_ERROR] = v120.unauthorizedError
	}
	local t4 = {
		[USER_FRIENDING_ERRORS.USER_BANNED_ERROR] = v120.userBannedError,
		[USER_FRIENDING_ERRORS.USER_BLOCKED_ERROR] = v120.userBlockedError,
		[USER_FRIENDING_ERRORS.USER_NOT_PASSED_CAPTCHA_ERROR] = v120.userNotPassedCaptchaError
	}
	local t5 = {
		[USER_FRIENDING_ERRORS.TOO_MANY_REQUESTS_ERROR] = v120.tooManyRequestsError
	}

	local function getErrorToastMessage(p3, p4, p5) -- line: 380
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
	local function setErrorToast(p6, p7) -- line: 395
		-- upvalues: HttpService (copy), Enums (copy), STATUS_CODES (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), v120 (copy), v109 (copy), SetCurrentToastMessage (copy)
		if p7 ~= nil then
			local StatusCode = p7.StatusCode
			local v155 = if not p7.Body then nil else HttpService:JSONDecode(p7.Body)
			local v156 = if not v155 or (not v155.errors or (not v155.errors[1] or not v155.errors[1].code)) then nil else v155.errors[1].code
			local v157 = ((if p6 ~= Enums.ProfileActions.AddFriend and p6 ~= Enums.ProfileActions.AddFriendFromContacts then nil else (if StatusCode ~= STATUS_CODES.BAD_REQUEST then (if StatusCode ~= STATUS_CODES.UNAUTHORIZED then (if StatusCode ~= STATUS_CODES.FORBIDDEN then (if StatusCode ~= STATUS_CODES.TOO_MANY_REQUESTS then nil else t5[v156]) else t4[v156]) else t3[v156]) else t2[v156]))) or v120.defaultFriendingError

			v109(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v157
			}))

			return
		end

		v109(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v120.defaultFriendingError
		}))
	end

	local v146 = if not FFlagProfilePlatformCTAsRefactor then nil else {
		localized = v120,
		analytics = v113,
		buttonSurface = p1,
		profileWrapperContext = v111,
		navigateTo = v111.navigateTo,
		dispatch = v109,
		profileId = profileId,
		localUserId = v108,
		navigation = v110,
		profileType = profileType,
		experienceUtilities = v130,
		friendRequestNicknamesEnabled = v137,
		profileShareLink = v138,
		PROFILE_SHARE_LINK_URL = v117,
		aboutSections = if not FFlagProfilePlatformNewProfileHeader then nil else aboutSections,
		aboutProfileName = if not FFlagProfileAboutDetailsUseSheet then nil else u127,
		actionsComponentRequest = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v129
	}

	return (React.useMemo(function() -- line: 442
		-- upvalues: FFlagProfilePlatformCTAsRefactor (copy), ProfileActions (copy), v146 (copy), Enums (copy), v120 (copy), ButtonVariant (copy), v113 (copy), EventNames (copy), p1 (copy), v111 (copy), v109 (copy), NetworkingFriends (copy), profileId (copy), v108 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy), FriendRequestNicknamesIXP (copy), v137 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy), setErrorToast (copy), ButtonType (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), profileType (copy), v110 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), SocialStopwatch (copy), SetAlias (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), IconName (copy), editAvatar (copy), FFlagProfilePlatformEnableEditLook (copy), v133 (copy), v134 (copy), getEditBackgroundAction (copy), Foundation (copy), FFlagAXEnableProfileTab (copy), editUsername (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy), v130 (copy), qRCodePage (copy), v139 (copy), default (copy), Contexts (copy), v117 (copy), TextKeys (copy), v138 (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), Url (copy), myUserBlockingNetworking (copy), USER_BLOCKING_ERRORS (copy), v101 (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), UrlBuilder (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), UrlBase (copy), v104 (copy), FFlagProfilePlatformAddTC (copy), Sources (copy), FFlagPendingIncomingTrustedConnection (copy), FFlagProfilePlatformNewProfileHeader (copy), aboutSections (ref), FFlagProfileAboutDetailsUseSheet (copy), u127 (ref), FFlagEnablePlatformProfileContextualMenuOption (copy), getPlatformFriendsService (copy), v123 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v112 (copy), TransferDirection (copy), TransferOrigination (copy)
		if FFlagProfilePlatformCTAsRefactor then
			local t6 = {}

			for v159, v160 in ProfileActions do
				local v161 = v160(v146)

				if v161 ~= nil then
					t6[v159] = v161
				end
			end

			return t6
		end

		return {
			[Enums.ProfileActions.AcceptFriendRequest] = {
				text = v120[Enums.ProfileActions.AcceptFriendRequest],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 468
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), Enums (copy), v109 (copy), NetworkingFriends (copy), profileId (copy), v108 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonAcceptFriendRequest, {
						buttonSurface = p1,
						absolutePosition = v111.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = v111.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = v111.sourceInfo.isRecommendation,
						source = v111.sourceInfo.source,
						contextualInfoType = v111.sourceInfo.contextualInfoType,
						recommendationContextType = v111.sourceInfo.recommendationContextType,
						recommendationRank = v111.sourceInfo.recommendationRank,
						recommendationSessionId = v111.sourceInfo.recommendationSessionId
					})

					return v109(NetworkingFriends.AcceptFriendRequestFromUserId.API({
						targetUserId = profileId,
						currentUserId = v108
					})):andThen(function() -- line: 484
						-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						v109(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v120.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end)
				end
			},
			[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = {
				text = v120[Enums.ProfileActions.AcceptOffNetworkFriendRequest],
				onActivated = function() -- line: 496
					-- upvalues: v113 (copy), EventNames (copy), v111 (copy), v109 (copy), NetworkingFriends (copy), profileId (copy), v108 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonAddFriendFromContacts, {
						shareLinkId = v111.sourceInfo.shareLinkId
					})

					return v109(NetworkingFriends.AcceptFriendRequestWithToken.API({
						targetUserId = profileId,
						currentUserId = v108,
						friendingToken = v111.offNetworkFriendRequestToken
					})):andThen(function() -- line: 504
						-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						v109(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v120.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end)
				end
			},
			[Enums.ProfileActions.AddFriend] = {
				text = v120[Enums.ProfileActions.AddFriend],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 517
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), Enums (copy), FriendRequestNicknamesIXP (copy), v137 (copy), AppPage (copy), profileId (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), v109 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), NetworkingFriends (copy), v108 (copy), refreshProfilePlatformActionInfo (copy), v129 (copy), setErrorToast (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonAddFriend, {
						buttonSurface = p1,
						absolutePosition = v111.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = v111.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = v111.sourceInfo.isRecommendation,
						source = v111.sourceInfo.source,
						contextualInfoType = v111.sourceInfo.contextualInfoType,
						recommendationContextType = v111.sourceInfo.recommendationContextType,
						recommendationRank = v111.sourceInfo.recommendationRank,
						recommendationSessionId = v111.sourceInfo.recommendationSessionId
					})

					if FriendRequestNicknamesIXP.FFlagFriendRequestNicknames and v137 then
						local t7 = {
							name = AppPage.SetNicknameModal,
							extraProps = {
								friendRequestParams = {
									targetUserId = profileId,
									source = v111.sourceInfo.friendshipOriginSourceType
								}
							}
						}

						if FFlagSignalsNavP3Dispatch then
							return v34.down(v34.fromLegacyPage(t7))
						end

						return v109(NavigateDown(t7))
					end

					v109(SetCurrentToastMessage({
						isLocalized = true,
						toastMessage = v120.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"]
					}))

					return v109(NetworkingFriends.RequestFriendshipFromUserId.API({
						targetUserId = profileId,
						currentUserId = v108,
						friendshipOriginSourceType = v111.sourceInfo.friendshipOriginSourceType
					})):andThen(function() -- line: 557
						-- upvalues: v109 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end):catch(function(p8) -- line: 562
						-- upvalues: setErrorToast (copy), Enums (copy)
						setErrorToast(Enums.ProfileActions.AddFriend, p8)
					end)
				end
			},
			[Enums.ProfileActions.AddFriendFromContacts] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				text = v120[Enums.ProfileActions.AddFriendFromContacts],
				onActivated = function() -- line: 572
					-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), NetworkingFriends (copy), v108 (copy), profileId (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy), setErrorToast (copy)
					v109(SetCurrentToastMessage({
						isLocalized = true,
						toastMessage = v120.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"]
					}))

					return v109(NetworkingFriends.RequestFriendshipFromContactId.API({
						currentUserId = v108,
						contactId = profileId,
						contextType = ContextualInfoTypes.Contacts
					})):andThen(function() -- line: 583
						-- upvalues: v109 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						return v109(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = {
								Enums.Components.ContactProfileHeader,
								Enums.Components.Actions,
								Enums.Components.ContactDescription
							}
						}))
					end):catch(function(p9) -- line: 594
						-- upvalues: setErrorToast (copy), Enums (copy)
						setErrorToast(Enums.ProfileActions.AddFriendFromContacts, p9)
					end)
				end
			},
			[Enums.ProfileActions.AddFriendFromContactsSent] = {
				isDisabled = true,
				buttonType = ButtonType.Secondary,
				variant = ButtonVariant.Subtle,
				text = v120[Enums.ProfileActions.AddFriendFromContactsSent],
				onActivated = function() -- line: 603
				end
			},
			[Enums.ProfileActions.Block] = {
				text = v120[Enums.ProfileActions.Block],
				onActivated = function() -- line: 608
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v110 (copy), AppPage (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonBlock, {
						buttonSurface = p1
					})
					v110.push(AppPage.BlockingModal, {
						navProps = {
							userId = profileId,
							onBlockSuccess = function() -- line: 615
								-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
								v109(SetCurrentToastMessage({
									isLocalized = true,
									toastMessage = v120.userBlockedToast,
									toastIcon = Images["icons/actions/block"]
								}))
								v109(refreshProfilePlatformActionInfo(profileId, v129))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.CannotAddFriend] = {
				isDisabled = true,
				text = v120[Enums.ProfileActions.CannotAddFriend],
				onActivated = function() -- line: 630
				end
			},
			[Enums.ProfileActions.Chat] = {
				text = v120[Enums.ProfileActions.Chat],
				variant = ButtonVariant.Standard,
				onActivated = function() -- line: 636
					-- upvalues: p1 (copy), Enums (copy), v113 (copy), EventNames (copy), v109 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), profileId (copy), NotificationTypeList (copy)
					if p1 == Enums.ButtonSurface.ContextualMenu then
						v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonChat, {
							buttonSurface = p1
						})
					else
						v113.fireAnalyticsEvent(EventNames.CTAButtonChat, {
							buttonSurface = p1
						})
					end

					v109(EnteredChatFromEntryPoint(ChatEntryPointNames.ProfilePeekView))
					GuiService:BroadcastNotification(profileId, NotificationTypeList.LAUNCH_CONVERSATION)
				end
			},
			[Enums.ProfileActions.EditAlias] = {
				text = v120[Enums.ProfileActions.EditAlias],
				onActivated = function() -- line: 653
					-- upvalues: SocialStopwatch (copy), v113 (copy), EventNames (copy), p1 (copy), v110 (copy), Enums (copy), profileId (copy), SetAlias (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonSetAlias, {
						buttonSurface = p1
					})
					v110.navigate(Enums.Screens.SetAliasModal, {
						profileUserId = profileId,
						origin = SetAlias.Analytics.EntryPoints.ContextualMenu
					})
				end
			},
			[Enums.ProfileActions.EditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v120[Enums.ProfileActions.EditAppearance],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 668
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonEditAppearance, {
						buttonSurface = p1
					})
				end
			},
			[Enums.ProfileActions.EditAvatar] = {
				text = v120[Enums.ProfileActions.EditAvatar],
				icon = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else IconName.Person,
				onActivated = function() -- line: 678
					-- upvalues: v113 (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), EventNames (copy), p1 (copy), editAvatar (copy)
					v113.fireAnalyticsEvent(if not FFlagProfilePlatformEnableEditAppearanceMenu then EventNames.CTAButtonEditAvatar else EventNames.EditAppearanceMenuEditAvatar, {
						buttonSurface = p1
					})
					editAvatar()
				end
			},
			[Enums.ProfileActions.EditLook] = if not FFlagProfilePlatformEnableEditLook then nil else {
				text = v120[Enums.ProfileActions.EditLook],
				icon = IconName.Person,
				onActivated = function() -- line: 694
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), editAvatar (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonEditLook, {
						buttonSurface = p1
					})
					editAvatar()
				end
			},
			[Enums.ProfileActions.EditEmotes] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v120[Enums.ProfileActions.EditEmotes],
				icon = IconName.SquareFaceWavingHand,
				onActivated = function() -- line: 706
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v133 (copy)
					v113.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditEmote, {
						buttonSurface = p1
					})
					v133()
				end
			},
			[Enums.ProfileActions.SwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v120[Enums.ProfileActions.SwitchAvatar],
				icon = IconName.PersonStandingArrowReverse,
				onActivated = function() -- line: 718
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v134 (copy)
					v113.fireAnalyticsEvent(EventNames.EditAppearanceMenuSwitchAvatar, {
						buttonSurface = p1
					})
					v134()
				end
			},
			[Enums.ProfileActions.EditBackground] = getEditBackgroundAction(),
			[Enums.ProfileActions.EditProfile] = {
				component = Foundation.Button,
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v120[Enums.ProfileActions.EditProfile],
				onActivated = function() -- line: 732
					-- upvalues: SocialStopwatch (copy), v113 (copy), EventNames (copy), p1 (copy), v110 (copy), Enums (copy), FFlagAXEnableProfileTab (copy), v111 (copy), editUsername (copy), v109 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy), FFlagMoveInExperienceModeToEditProfile (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.EditProfileOpened)
					v113.fireAnalyticsEvent(EventNames.CTAButtonOpenEditProfilePage, {
						buttonSurface = p1
					})
					v110.navigate(Enums.Screens.EditProfilePage, {
						profileScreens = Enums.Screens,
						fullBleed = if not FFlagAXEnableProfileTab then nil else v111.forceFullView == true,
						navigateToEditUsername = function(p10) -- line: 744
							-- upvalues: editUsername (copy), v109 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
							editUsername({
								showToast = p10,
								onUsernameChanged = function() -- line: 747
									-- upvalues: v109 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
									v109(refreshProfilePlatformUserInfo(profileId))
								end
							})
						end,
						onIdentityChange = function() -- line: 752
							-- upvalues: v109 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
							v109(refreshProfilePlatformUserInfo(profileId))
						end,
						onToggleInExperienceMode = if not FFlagMoveInExperienceModeToEditProfile then nil else function() -- line: 756
							-- upvalues: v109 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy), v113 (copy), EventNames (copy)
							v109(refreshProfilePlatformUserInfo(profileId))
							v113.fireAnalyticsEvent(EventNames.ToggleInExperienceModeButton, {})
						end
					})
				end
			},
			[Enums.ProfileActions.IgnoreFriendRequest] = {
				text = v120[Enums.ProfileActions.IgnoreFriendRequest],
				onActivated = function() -- line: 766
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v109 (copy), NetworkingFriends (copy), profileId (copy), v108 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonIgnoreFriendRequest, {
						buttonSurface = p1
					})

					return v109(NetworkingFriends.DeclineFriendRequestFromUserId.API({
						targetUserId = profileId,
						currentUserId = v108
					})):andThen(function() -- line: 773
						-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						v109(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v120.friendRequestIgnoredToast,
							toastIcon = Images["icons/actions/reject"]
						}))

						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end)
				end
			},
			[Enums.ProfileActions.JoinExperience] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				isLoading = v130.isLoading,
				isDisabled = not v130.isInExperience,
				text = v120[Enums.ProfileActions.JoinExperience],
				onActivated = function() -- line: 790
					-- upvalues: v130 (copy)
					v130.joinExperience()
				end
			},
			[Enums.ProfileActions.PendingFriendRequest] = {
				isDisabled = true,
				buttonType = ButtonType.Secondary,
				variant = ButtonVariant.Subtle,
				text = v120[Enums.ProfileActions.PendingFriendRequest],
				onActivated = function() -- line: 799
				end
			},
			[Enums.ProfileActions.QrCode] = {
				text = v120[Enums.ProfileActions.QrCode],
				icon = IconName.SquaresGridQr,
				onActivated = function() -- line: 805
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), qRCodePage (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonShareProfileQRCode, {
						buttonSurface = p1
					})
					qRCodePage()
				end
			},
			[Enums.ProfileActions.ShareProfile] = {
				component = Foundation.Button,
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v120[Enums.ProfileActions.ShareProfile],
				onActivated = function() -- line: 817
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v139 (copy), default (copy), Contexts (copy), v117 (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), TextKeys (copy), v138 (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonShareProfile, {
						buttonSurface = p1
					})

					if v139 then
						default:setClipboardText({
							context = Contexts.ProfileCard,
							text = string.format("%s/%s", v117, profileId)
						})
						v109(SetCurrentToastMessage({
							toastMessage = TextKeys.LinkCopied
						}))

						return
					end

					v138.onActivated()
				end
			},
			[Enums.ProfileActions.Report] = {
				text = v120[Enums.ProfileActions.Report],
				onActivated = function() -- line: 836
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), profileType (copy), Enums (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), v109 (copy), OpenDynamicAbuseReport (copy), profileId (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), v129 (copy), AppPage (copy), Url (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
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

						v109(OpenDynamicAbuseReport({
							abuseVector = UserProfile,
							targetId = profileId,
							onClose = function() -- line: 855
								-- upvalues: v109 (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
								v109(CloseCentralOverlay())
								v109(refreshProfilePlatformActionInfo(profileId, v129))
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

					v109(NavigateDown(t8))
				end
			},
			[Enums.ProfileActions.Unblock] = {
				text = v120[Enums.ProfileActions.Unblock],
				onActivated = function() -- line: 878
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v109 (copy), myUserBlockingNetworking (copy), profileId (copy), v108 (copy), refreshProfilePlatformActionInfo (copy), v129 (copy), USER_BLOCKING_ERRORS (copy), SetCurrentToastMessage (copy), v120 (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonUnblock, {
						buttonSurface = p1
					})

					return v109(myUserBlockingNetworking.UnblockUserById.API({
						userId = profileId,
						currentUserId = v108
					})):andThen(function() -- line: 886
						-- upvalues: v109 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end):catch(function(p11) -- line: 889
						-- upvalues: USER_BLOCKING_ERRORS (copy), v109 (copy), SetCurrentToastMessage (copy), v120 (copy)
						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.PARENT_BLOCKED_TARGET_USER_ERROR then
							v109(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v120.unblockTargetParentManagedToast
							}))

							return
						end

						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_NOT_BLOCKED_ERROR then
							v109(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v120.unblockTargetNotBlockedToast
							}))

							return
						end

						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_BLOCKED_ON_PLATFORM then
							v109(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v120.blockedOnPlatformToast
							}))

							return
						end

						v109(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v120.somethingIsWrongToast
						}))
					end)
				end
			},
			[Enums.ProfileActions.Unfriend] = {
				text = v120[Enums.ProfileActions.Unfriend],
				onActivated = function() -- line: 931
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v109 (copy), NetworkingFriends (copy), profileId (copy), v108 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfriend, {
						buttonSurface = p1
					})

					return v109(NetworkingFriends.UnfriendTargetUserId.API({
						targetUserId = profileId,
						currentUserId = v108
					})):andThen(function() -- line: 938
						-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						v109(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v120.friendRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end)
				end
			},
			[Enums.ProfileActions.CopyLink] = {
				text = v120[Enums.ProfileActions.CopyLink],
				onActivated = function() -- line: 950
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), default (copy), Contexts (copy), v101 (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), TextKeys (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonCopyLink, {
						buttonSurface = p1
					})
					default:setClipboardText({
						context = Contexts.ProfileCard,
						text = string.format(v101, profileId)
					})
					v109(SetCurrentToastMessage({
						toastMessage = TextKeys.LinkCopied
					}))
				end
			},
			[Enums.ProfileActions.JoinCommunity] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				text = v120[Enums.ProfileActions.JoinCommunity],
				onActivated = function() -- line: 968
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), v109 (copy), GroupsNetworking (copy), profileId (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonJoinCommunity, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					return v109(GroupsNetworking.JoinGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 976
						-- upvalues: v109 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v109(getProfilePlatform.API({
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
				text = v120[Enums.ProfileActions.CancelJoinCommunityRequest],
				onActivated = function() -- line: 990
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), v109 (copy), GroupsNetworking (copy), profileId (copy), v108 (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonCancelJoinCommunityRequest, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					return v109(GroupsNetworking.CancelJoinGroupRequest.API({
						groupId = profileId,
						userId = v108
					})):andThen(function() -- line: 999
						-- upvalues: v109 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v109(refreshProfilePlatform({
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
				text = v120[Enums.ProfileActions.ViewCommunity],
				onActivated = function() -- line: 1014
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), AppPage (copy), UrlBuilder (copy), profileId (copy), TextKeys (copy), v109 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonViewCommunity, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					local t9 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.user.group({
							groupId = profileId
						}),
						extraProps = {
							titleKey = TextKeys.Community,
							onClose = function() -- line: 1025
								-- upvalues: v109 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
								v109(getProfilePlatform.API({
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

					v109(NavigateDown(t9))
				end
			},
			[Enums.ProfileActions.ViewFullProfile] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else {
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.SubEmphasis,
				text = v120[Enums.ProfileActions.ViewFullProfile],
				onActivated = function() -- line: 1047
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), AppPage (copy), UrlBuilder (copy), UrlBase (copy), profileId (copy), TextKeys (copy), v109 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					local t10 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.new({
							base = UrlBase.WWW,
							path = `profiles/{ profileId }`
						})(),
						extraProps = {
							titleKey = TextKeys.Profile,
							onClose = function() -- line: 1061
								-- upvalues: v109 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
								v109(getProfilePlatform.API({
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

					v109(NavigateDown(t10))
				end
			},
			[Enums.ProfileActions.LeaveCommunity] = {
				text = v120[Enums.ProfileActions.LeaveCommunity],
				onActivated = function() -- line: 1081
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), v109 (copy), GroupsNetworking (copy), profileId (copy), v108 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonLeaveCommunity, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					return v109(GroupsNetworking.LeaveGroup.API({
						groupId = profileId,
						userId = v108
					})):andThen(function() -- line: 1090
						-- upvalues: v109 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v109(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.MakePrimaryCommunity] = {
				text = v120[Enums.ProfileActions.MakePrimaryCommunity],
				onActivated = function() -- line: 1102
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), v109 (copy), GroupsNetworking (copy), profileId (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonMakePrimaryCommunity, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					return v109(GroupsNetworking.MakePrimaryGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 1110
						-- upvalues: v109 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v109(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			},
			[Enums.ProfileActions.RemovePrimaryCommunity] = {
				text = v120[Enums.ProfileActions.RemovePrimaryCommunity],
				onActivated = function() -- line: 1123
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), v109 (copy), GroupsNetworking (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemovePrimaryCommunity, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					return v109(GroupsNetworking.RemovePrimaryGroup.API()):andThen(function() -- line: 1129
						-- upvalues: v109 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v109(refreshProfilePlatform({
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
				text = v120[Enums.ProfileActions.Follow],
				onActivated = function() -- line: 1146
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v109 (copy), GroupsNetworking (copy), profileId (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = p1
					})

					return v109(GroupsNetworking.JoinGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 1152
						-- upvalues: v109 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v109(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.Unfollow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities or profileType ~= Enums.ProfileTypes.Community then nil else {
				text = v120[Enums.ProfileActions.Unfollow],
				onActivated = function() -- line: 1167
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v109 (copy), GroupsNetworking (copy), profileId (copy), v108 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = p1
					})

					return v109(GroupsNetworking.LeaveGroup.API({
						groupId = profileId,
						userId = v108
					})):andThen(function() -- line: 1175
						-- upvalues: v109 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v109(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.RemoveTrustedConnection] = {
				text = v120[Enums.ProfileActions.RemoveTrustedConnection],
				onActivated = function() -- line: 1188
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v104 (copy), profileId (copy), v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemoveTrustedConnection, {
						buttonSurface = p1
					})

					return v104.removeTrustedConnectionRequest(profileId):andThen(function() -- line: 1192
						-- upvalues: v109 (copy), SetCurrentToastMessage (copy), v120 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
						v109(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v120.trustedConnectionRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return v109(refreshProfilePlatformActionInfo(profileId, v129))
					end)
				end
			},
			[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				text = v120[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1205
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v110 (copy), AppPage (copy), profileId (copy), Sources (copy), v109 (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p1
					})
					v110.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							source = Sources.ProfilePlatform,
							onRequestSent = function() -- line: 1213
								-- upvalues: v109 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
								return v109(refreshProfilePlatformActionInfo(profileId, v129))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.AddTrustedConnectionViaLink] = {
				text = v120[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1225
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), Sources (copy), v110 (copy), AppPage (copy), profileId (copy), v109 (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p1,
						modalVariantOverride = Sources.ShareLinkSender
					})
					v110.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							source = Sources.ProfilePlatform,
							modalVariantOverride = Sources.ShareLinkSender,
							onRequestSent = function() -- line: 1235
								-- upvalues: v109 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
								return v109(refreshProfilePlatformActionInfo(profileId, v129))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				text = v120[Enums.ProfileActions.AddIncomingTrustedConnection],
				onActivated = function() -- line: 1247
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v110 (copy), AppPage (copy), profileId (copy), v109 (copy), refreshProfilePlatformActionInfo (copy), v129 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddIncomingTrustedConnection, {
						buttonSurface = p1
					})
					v110.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							onRequestAccepted = function() -- line: 1254
								-- upvalues: v109 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v129 (copy)
								return v109(refreshProfilePlatformActionInfo(profileId, v129))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.PendingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				isDisabled = true,
				text = v120[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1268
				end
			},
			[Enums.ProfileActions.PendingIncomingTrustedConnection] = if not FFlagPendingIncomingTrustedConnection then nil else {
				isDisabled = true,
				text = v120[Enums.ProfileActions.AddIncomingTrustedConnection],
				onActivated = function() -- line: 1275
				end
			},
			[Enums.ProfileActions.ViewAbout] = if not FFlagProfilePlatformNewProfileHeader then nil else {
				text = v120[Enums.ProfileActions.ViewAbout],
				onActivated = function() -- line: 1281
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), v111 (copy), AppPage (copy), aboutSections (ref), FFlagProfileAboutDetailsUseSheet (copy), u127 (ref), FFlagSignalsNavP3Dispatch (copy), v34 (copy), v109 (copy), NavigateDown (copy)
					v113.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1,
						btnContext = v111.sourceInfo.source
					})

					local t11 = {
						name = AppPage.AboutDetailsSheet,
						extraProps = {
							sections = aboutSections,
							profileName = if not FFlagProfileAboutDetailsUseSheet then nil else u127
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t11))

						return
					end

					v109(NavigateDown(t11))
				end
			},
			[Enums.ProfileActions.ViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else {
				text = v120[Enums.ProfileActions.ViewPlatformProfile],
				onActivated = function() -- line: 1307
					-- upvalues: v113 (copy), EventNames (copy), p1 (copy), getPlatformFriendsService (copy), v123 (copy)
					v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonViewPlatformProfile, {
						buttonSurface = p1
					})
					getPlatformFriendsService:ShowProfile(v123)
				end
			},
			[Enums.ProfileActions.CurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
				text = v120[Enums.ProfileActions.CurrencyTransfer],
				onActivated = function() -- line: 1318
					-- upvalues: p1 (copy), Enums (copy), v113 (copy), EventNames (copy), v112 (copy), profileId (copy), TransferDirection (copy), TransferOrigination (copy)
					if p1 == Enums.ButtonSurface.ContextualMenu then
						v113.fireAnalyticsEvent(EventNames.ContextualMenuButtonCurrencyTransfer, {
							buttonSurface = p1
						})
					else
						v113.fireAnalyticsEvent(EventNames.CTAButtonCurrencyTransfer, {
							buttonSurface = p1
						})
					end

					if v112 then
						v112({
							recipientUserId = profileId,
							direction = TransferDirection.Send,
							transferOrigination = TransferOrigination.Profile
						})
					end
				end
			}
		}
	end, {
		v109,
		profileId,
		v111,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v112,
		qRCodePage,
		v120,
		v108,
		v110,
		editUsername,
		v130.joinExperience,
		v130.isLoading,
		v113,
		v137,
		p1,
		if not FFlagProfilePlatformNewProfileHeader then nil else aboutSections,
		if not FFlagProfileAboutDetailsUseSheet then nil else u127,
		profileType,
		editAvatar,
		if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v133,
		if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v134,
		if not FFlagProfilePlatformCTAsRefactor then nil else v117,
		if not FFlagProfilePlatformCTAsRefactor then nil else v130.isInExperience,
		if not FFlagProfilePlatformCTAsRefactor then nil else v146,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v129
	}))
end

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
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local FFlagEnableAbuseReportRevampProfileAndGroup = require(ProfilePlatform.Flags.FFlagEnableAbuseReportRevampProfileAndGroup)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)
local v82 = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem
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
local v100 = `{ Url.BASE_URL }share/g/%s`
local str = tostring(DateTime.now().UnixTimestampMillis)

local function areFollowActionsSupportedForProfileType(s1: string) -- line: 130
	-- upvalues: Enums (copy)
	return s1 == Enums.ProfileTypes.Community
end

local v103 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

return function(p1) -- line: 149
	-- upvalues: useLocalUserId (copy), useDispatch (copy), useNavigation (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useShortUrl (copy), useGetOrGenerateLinkUrl (copy), useEffectOnce (copy), React (copy), str (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), useLocalization (copy), Enums (copy), FFlagProfilePlatformAddTC (copy), FFlagProfilePlatformEnableUnlockChat (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), FFlagProfilePlatformEditBackgroundMenuItem (copy), FFlagProfilePlatformEnableEditLook (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagEnablePlatformProfileContextualMenuOption (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), useSelector (copy), Presence (copy), useAboutSections (copy), FFlagProfileAboutDetailsUseSheet (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), useJoinUserInExperience (copy), v82 (copy), IconName (copy), EventNames (copy), FriendRequestNicknamesIXP (copy), useProfileShareLink (copy), Contexts (copy), ProfileSharePolicyEnum (copy), USER_FRIENDING_ERRORS (copy), STATUS_CODES (copy), HttpService (copy), SetCurrentToastMessage (copy), FFlagProfilePlatformCTAsRefactor (copy), ProfileActions (copy), ButtonVariant (copy), NetworkingFriends (copy), Images (copy), refreshProfilePlatformActionInfo (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy), ButtonType (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), SocialStopwatch (copy), SetAlias (copy), Foundation (copy), FFlagAXEnableProfileTab (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy), default (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), Url (copy), myUserBlockingNetworking (copy), USER_BLOCKING_ERRORS (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy), v100 (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), UrlBuilder (copy), UrlBase (copy), v103 (copy), Sources (copy), FFlagPendingIncomingTrustedConnection (copy), getPlatformFriendsService (copy), TransferDirection (copy), TransferOrigination (copy)
	local v106 = useLocalUserId()
	local v107 = useDispatch()
	local v108 = useNavigation()
	local v109 = useProfileWrapperContext()
	local v110 = v109.navigateTo and v109.navigateTo.navigateToTransfer or nil
	local v111 = useProfileAnalyticsContext()
	local v112 = useShortUrl()
	local v113 = useGetOrGenerateLinkUrl()
	local v114 = v112 ~= nil

	useEffectOnce(v113, not v114)

	local v115 = React.useMemo(function() -- line: 163
		-- upvalues: v112 (copy), str (copy)
		return string.format("%s&source=ProfileShare&stamp=%s", v112 or "", str)
	end, { v112 })
	local v116 = if not FFlagConnectionsToFriendsRename then TextKeys.AcceptConnection else TextKeys.AcceptFriend
	local v117 = if not FFlagConnectionsToFriendsRename then TextKeys.AddConnection else TextKeys.AddFriend
	local v118 = useLocalization({
		[Enums.ProfileActions.AcceptFriendRequest] = v116,
		[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = v116,
		[Enums.ProfileActions.AddFriend] = v117,
		[Enums.ProfileActions.AddFriendFromContacts] = v117,
		[Enums.ProfileActions.AddFriendFromContactsSent] = TextKeys.PendingRequest,
		[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else TextKeys.AddTrustedConnection,
		[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else TextKeys.AcceptTrustedConnection,
		[Enums.ProfileActions.Block] = TextKeys.Block,
		[Enums.ProfileActions.CannotAddFriend] = v117,
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
	local v119 = React.useCallback(function() -- line: 277
		-- upvalues: v109 (copy)
		v109.navigateTo.previousView(true)
	end, { v109.navigateTo.previousView })
	local profileId = v109.profileId
	local v121 = if not FFlagEnablePlatformProfileContextualMenuOption then nil else v109.profilePlatformId
	local profileType = v109.profileType
	local v123 = if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then nil else useSelector(function(p2) -- line: 287
		-- upvalues: Presence (copy), profileId (copy)
		return Presence.Selectors.getUserPresenceByUserId(p2, profileId) or {
			lastLocation = "",
			userPresenceType = Presence.Enums.PresenceType.Offline
		}
	end)
	local aboutSections = nil
	local u125 = nil

	if FFlagProfilePlatformNewProfileHeader then
		local v126 = useAboutSections()

		aboutSections = v126.aboutSections
		u125 = if not FFlagProfileAboutDetailsUseSheet then nil else v126.profileName
	end

	local v127 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local v128 = useJoinUserInExperience(profileId, {
		isHomePageCarousel = v109.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
		homepageCarouselAbsolutePosition = v109.sourceInfo.homepageCarouselAbsolutePosition,
		openGameDetailsPeekViewClosed = v119,
		presence = if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then nil else v123
	})
	local qRCodePage = v109.navigateTo.qRCodePage
	local editUsername = v109.navigateTo.editUsername
	local v131 = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v109.navigateTo.editEmotes
	local v132 = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v109.navigateTo.switchAvatar

	local function getEditBackgroundAction() -- line: 325
		-- upvalues: v82 (copy), v109 (copy), v118 (copy), Enums (copy), IconName (copy), v111 (copy), EventNames (copy), p1 (copy)
		if v82 then
			local editBackground = v109.navigateTo.editBackground

			return {
				text = v118[Enums.ProfileActions.EditBackground],
				icon = IconName.Image,
				onActivated = function() -- line: 331
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), editBackground (copy)
					v111.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditBackground, {
						buttonSurface = p1
					})
					editBackground()
				end
			}
		end

		return nil
	end

	local editAvatar = v109.navigateTo.editAvatar
	local v135 = FriendRequestNicknamesIXP.useFriendRequestNicknames()
	local v136 = useProfileShareLink({
		context = Contexts.ProfileCard
	})
	local v137 = v136.policy == ProfileSharePolicyEnum.Disabled
	local t1 = {
		[USER_FRIENDING_ERRORS.INVALID_TARGET_USER_ERROR] = v118.invalidTargetUserError,
		[USER_FRIENDING_ERRORS.ALREADY_FRIEND_ERROR] = v118.alreadyFriendError,
		[USER_FRIENDING_ERRORS.MAX_FRIENDS_ERROR] = v118.maxFriendsError,
		[USER_FRIENDING_ERRORS.INVALID_NICKNAME_ERROR] = v118.invalidNicknameError
	}
	local t2 = {
		[USER_FRIENDING_ERRORS.UNAUTHORIZED_ERROR] = v118.unauthorizedError
	}
	local t3 = {
		[USER_FRIENDING_ERRORS.USER_BANNED_ERROR] = v118.userBannedError,
		[USER_FRIENDING_ERRORS.USER_BLOCKED_ERROR] = v118.userBlockedError,
		[USER_FRIENDING_ERRORS.USER_NOT_PASSED_CAPTCHA_ERROR] = v118.userNotPassedCaptchaError
	}
	local t4 = {
		[USER_FRIENDING_ERRORS.TOO_MANY_REQUESTS_ERROR] = v118.tooManyRequestsError
	}

	local function getErrorToastMessage(p3, p4, p5) -- line: 369
		-- upvalues: Enums (copy), STATUS_CODES (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy)
		if p3 == Enums.ProfileActions.AddFriend or p3 == Enums.ProfileActions.AddFriendFromContacts then
			if p4 == STATUS_CODES.BAD_REQUEST then
				return t1[p5]
			end

			if p4 == STATUS_CODES.UNAUTHORIZED then
				return t2[p5]
			end

			if p4 == STATUS_CODES.FORBIDDEN then
				return t3[p5]
			end

			if p4 == STATUS_CODES.TOO_MANY_REQUESTS then
				return t4[p5]
			end
		end

		return nil
	end
	local function setErrorToast(p6, p7) -- line: 384
		-- upvalues: HttpService (copy), Enums (copy), STATUS_CODES (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), v118 (copy), v107 (copy), SetCurrentToastMessage (copy)
		if p7 ~= nil then
			local StatusCode = p7.StatusCode
			local v153 = if not p7.Body then nil else HttpService:JSONDecode(p7.Body)
			local v154 = if not v153 or (not v153.errors or (not v153.errors[1] or not v153.errors[1].code)) then nil else v153.errors[1].code
			local v155 = ((if p6 ~= Enums.ProfileActions.AddFriend and p6 ~= Enums.ProfileActions.AddFriendFromContacts then nil else (if StatusCode ~= STATUS_CODES.BAD_REQUEST then (if StatusCode ~= STATUS_CODES.UNAUTHORIZED then (if StatusCode ~= STATUS_CODES.FORBIDDEN then (if StatusCode ~= STATUS_CODES.TOO_MANY_REQUESTS then nil else t4[v154]) else t3[v154]) else t2[v154]) else t1[v154]))) or v118.defaultFriendingError

			v107(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v155
			}))

			return
		end

		v107(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v118.defaultFriendingError
		}))
	end

	local v144 = if not FFlagProfilePlatformCTAsRefactor then nil else {
		localized = v118,
		analytics = v111,
		buttonSurface = p1,
		profileWrapperContext = v109,
		navigateTo = v109.navigateTo,
		dispatch = v107,
		profileId = profileId,
		localUserId = v106,
		navigation = v108,
		profileType = profileType,
		experienceUtilities = v128,
		friendRequestNicknamesEnabled = v135,
		profileShareLink = v136,
		PROFILE_SHARE_LINK_URL = v115,
		aboutSections = if not FFlagProfilePlatformNewProfileHeader then nil else aboutSections,
		aboutProfileName = if not FFlagProfileAboutDetailsUseSheet then nil else u125,
		actionsComponentRequest = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v127
	}

	return (React.useMemo(function() -- line: 431
		-- upvalues: FFlagProfilePlatformCTAsRefactor (copy), ProfileActions (copy), v144 (copy), Enums (copy), v118 (copy), ButtonVariant (copy), v111 (copy), EventNames (copy), p1 (copy), v109 (copy), v107 (copy), NetworkingFriends (copy), profileId (copy), v106 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy), FriendRequestNicknamesIXP (copy), v135 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy), setErrorToast (copy), ButtonType (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), profileType (copy), v108 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), SocialStopwatch (copy), SetAlias (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), IconName (copy), editAvatar (copy), FFlagProfilePlatformEnableEditLook (copy), v131 (copy), v132 (copy), getEditBackgroundAction (copy), Foundation (copy), FFlagAXEnableProfileTab (copy), editUsername (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy), v128 (copy), qRCodePage (copy), v137 (copy), default (copy), Contexts (copy), v115 (copy), TextKeys (copy), v136 (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), Url (copy), myUserBlockingNetworking (copy), USER_BLOCKING_ERRORS (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy), v100 (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), UrlBuilder (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), UrlBase (copy), v103 (copy), FFlagProfilePlatformAddTC (copy), Sources (copy), FFlagPendingIncomingTrustedConnection (copy), FFlagProfilePlatformNewProfileHeader (copy), aboutSections (ref), FFlagProfileAboutDetailsUseSheet (copy), u125 (ref), FFlagEnablePlatformProfileContextualMenuOption (copy), getPlatformFriendsService (copy), v121 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v110 (copy), TransferDirection (copy), TransferOrigination (copy)
		if FFlagProfilePlatformCTAsRefactor then
			local t5 = {}

			for v157, v158 in ProfileActions do
				local v159 = v158(v144)

				if v159 ~= nil then
					t5[v157] = v159
				end
			end

			return t5
		end

		return {
			[Enums.ProfileActions.AcceptFriendRequest] = {
				text = v118[Enums.ProfileActions.AcceptFriendRequest],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 457
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), Enums (copy), v107 (copy), NetworkingFriends (copy), profileId (copy), v106 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonAcceptFriendRequest, {
						buttonSurface = p1,
						absolutePosition = v109.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = v109.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = v109.sourceInfo.isRecommendation,
						source = v109.sourceInfo.source,
						contextualInfoType = v109.sourceInfo.contextualInfoType,
						recommendationContextType = v109.sourceInfo.recommendationContextType,
						recommendationRank = v109.sourceInfo.recommendationRank,
						recommendationSessionId = v109.sourceInfo.recommendationSessionId
					})

					return v107(NetworkingFriends.AcceptFriendRequestFromUserId.API({
						targetUserId = profileId,
						currentUserId = v106
					})):andThen(function() -- line: 473
						-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						v107(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v118.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end)
				end
			},
			[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = {
				text = v118[Enums.ProfileActions.AcceptOffNetworkFriendRequest],
				onActivated = function() -- line: 485
					-- upvalues: v111 (copy), EventNames (copy), v109 (copy), v107 (copy), NetworkingFriends (copy), profileId (copy), v106 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonAddFriendFromContacts, {
						shareLinkId = v109.sourceInfo.shareLinkId
					})

					return v107(NetworkingFriends.AcceptFriendRequestWithToken.API({
						targetUserId = profileId,
						currentUserId = v106,
						friendingToken = v109.offNetworkFriendRequestToken
					})):andThen(function() -- line: 493
						-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						v107(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v118.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end)
				end
			},
			[Enums.ProfileActions.AddFriend] = {
				text = v118[Enums.ProfileActions.AddFriend],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 506
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), Enums (copy), FriendRequestNicknamesIXP (copy), v135 (copy), AppPage (copy), profileId (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), v107 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), NetworkingFriends (copy), v106 (copy), refreshProfilePlatformActionInfo (copy), v127 (copy), setErrorToast (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonAddFriend, {
						buttonSurface = p1,
						absolutePosition = v109.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = v109.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = v109.sourceInfo.isRecommendation,
						source = v109.sourceInfo.source,
						contextualInfoType = v109.sourceInfo.contextualInfoType,
						recommendationContextType = v109.sourceInfo.recommendationContextType,
						recommendationRank = v109.sourceInfo.recommendationRank,
						recommendationSessionId = v109.sourceInfo.recommendationSessionId
					})

					if FriendRequestNicknamesIXP.FFlagFriendRequestNicknames and v135 then
						local t6 = {
							name = AppPage.SetNicknameModal,
							extraProps = {
								friendRequestParams = {
									targetUserId = profileId,
									source = v109.sourceInfo.friendshipOriginSourceType
								}
							}
						}

						if FFlagSignalsNavP3Dispatch then
							return v34.down(v34.fromLegacyPage(t6))
						end

						return v107(NavigateDown(t6))
					end

					v107(SetCurrentToastMessage({
						isLocalized = true,
						toastMessage = v118.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"]
					}))

					return v107(NetworkingFriends.RequestFriendshipFromUserId.API({
						targetUserId = profileId,
						currentUserId = v106,
						friendshipOriginSourceType = v109.sourceInfo.friendshipOriginSourceType
					})):andThen(function() -- line: 546
						-- upvalues: v107 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end):catch(function(p8) -- line: 551
						-- upvalues: setErrorToast (copy), Enums (copy)
						setErrorToast(Enums.ProfileActions.AddFriend, p8)
					end)
				end
			},
			[Enums.ProfileActions.AddFriendFromContacts] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				text = v118[Enums.ProfileActions.AddFriendFromContacts],
				onActivated = function() -- line: 561
					-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), NetworkingFriends (copy), v106 (copy), profileId (copy), ContextualInfoTypes (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy), setErrorToast (copy)
					v107(SetCurrentToastMessage({
						isLocalized = true,
						toastMessage = v118.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"]
					}))

					return v107(NetworkingFriends.RequestFriendshipFromContactId.API({
						currentUserId = v106,
						contactId = profileId,
						contextType = ContextualInfoTypes.Contacts
					})):andThen(function() -- line: 572
						-- upvalues: v107 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						return v107(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = {
								Enums.Components.ContactProfileHeader,
								Enums.Components.Actions,
								Enums.Components.ContactDescription
							}
						}))
					end):catch(function(p9) -- line: 583
						-- upvalues: setErrorToast (copy), Enums (copy)
						setErrorToast(Enums.ProfileActions.AddFriendFromContacts, p9)
					end)
				end
			},
			[Enums.ProfileActions.AddFriendFromContactsSent] = {
				isDisabled = true,
				buttonType = ButtonType.Secondary,
				variant = ButtonVariant.Subtle,
				text = v118[Enums.ProfileActions.AddFriendFromContactsSent],
				onActivated = function() -- line: 592
				end
			},
			[Enums.ProfileActions.Block] = {
				text = v118[Enums.ProfileActions.Block],
				onActivated = function() -- line: 597
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v108 (copy), AppPage (copy), profileId (copy), v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonBlock, {
						buttonSurface = p1
					})
					v108.push(AppPage.BlockingModal, {
						navProps = {
							userId = profileId,
							onBlockSuccess = function() -- line: 604
								-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
								v107(SetCurrentToastMessage({
									isLocalized = true,
									toastMessage = v118.userBlockedToast,
									toastIcon = Images["icons/actions/block"]
								}))
								v107(refreshProfilePlatformActionInfo(profileId, v127))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.CannotAddFriend] = {
				isDisabled = true,
				text = v118[Enums.ProfileActions.CannotAddFriend],
				onActivated = function() -- line: 619
				end
			},
			[Enums.ProfileActions.Chat] = {
				text = v118[Enums.ProfileActions.Chat],
				variant = ButtonVariant.Standard,
				onActivated = function() -- line: 625
					-- upvalues: p1 (copy), Enums (copy), v111 (copy), EventNames (copy), v107 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), profileId (copy), NotificationTypeList (copy)
					if p1 == Enums.ButtonSurface.ContextualMenu then
						v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonChat, {
							buttonSurface = p1
						})
					else
						v111.fireAnalyticsEvent(EventNames.CTAButtonChat, {
							buttonSurface = p1
						})
					end

					v107(EnteredChatFromEntryPoint(ChatEntryPointNames.ProfilePeekView))
					GuiService:BroadcastNotification(profileId, NotificationTypeList.LAUNCH_CONVERSATION)
				end
			},
			[Enums.ProfileActions.EditAlias] = {
				text = v118[Enums.ProfileActions.EditAlias],
				onActivated = function() -- line: 642
					-- upvalues: SocialStopwatch (copy), v111 (copy), EventNames (copy), p1 (copy), v108 (copy), Enums (copy), profileId (copy), SetAlias (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CustomizeNameOpened)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonSetAlias, {
						buttonSurface = p1
					})
					v108.navigate(Enums.Screens.SetAliasModal, {
						profileUserId = profileId,
						origin = SetAlias.Analytics.EntryPoints.ContextualMenu
					})
				end
			},
			[Enums.ProfileActions.EditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v118[Enums.ProfileActions.EditAppearance],
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 657
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonEditAppearance, {
						buttonSurface = p1
					})
				end
			},
			[Enums.ProfileActions.EditAvatar] = {
				text = v118[Enums.ProfileActions.EditAvatar],
				icon = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else IconName.Person,
				onActivated = function() -- line: 667
					-- upvalues: v111 (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), EventNames (copy), p1 (copy), editAvatar (copy)
					v111.fireAnalyticsEvent(if not FFlagProfilePlatformEnableEditAppearanceMenu then EventNames.CTAButtonEditAvatar else EventNames.EditAppearanceMenuEditAvatar, {
						buttonSurface = p1
					})
					editAvatar()
				end
			},
			[Enums.ProfileActions.EditLook] = if not FFlagProfilePlatformEnableEditLook then nil else {
				text = v118[Enums.ProfileActions.EditLook],
				icon = IconName.Person,
				onActivated = function() -- line: 683
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), editAvatar (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonEditLook, {
						buttonSurface = p1
					})
					editAvatar()
				end
			},
			[Enums.ProfileActions.EditEmotes] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v118[Enums.ProfileActions.EditEmotes],
				icon = IconName.SquareFaceWavingHand,
				onActivated = function() -- line: 695
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v131 (copy)
					v111.fireAnalyticsEvent(EventNames.EditAppearanceMenuEditEmote, {
						buttonSurface = p1
					})
					v131()
				end
			},
			[Enums.ProfileActions.SwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
				text = v118[Enums.ProfileActions.SwitchAvatar],
				icon = IconName.PersonStandingArrowReverse,
				onActivated = function() -- line: 707
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v132 (copy)
					v111.fireAnalyticsEvent(EventNames.EditAppearanceMenuSwitchAvatar, {
						buttonSurface = p1
					})
					v132()
				end
			},
			[Enums.ProfileActions.EditBackground] = getEditBackgroundAction(),
			[Enums.ProfileActions.EditProfile] = {
				component = Foundation.Button,
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v118[Enums.ProfileActions.EditProfile],
				onActivated = function() -- line: 721
					-- upvalues: SocialStopwatch (copy), v111 (copy), EventNames (copy), p1 (copy), v108 (copy), Enums (copy), FFlagAXEnableProfileTab (copy), v109 (copy), editUsername (copy), v107 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy), FFlagMoveInExperienceModeToEditProfile (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.EditProfileOpened)
					v111.fireAnalyticsEvent(EventNames.CTAButtonOpenEditProfilePage, {
						buttonSurface = p1
					})
					v108.navigate(Enums.Screens.EditProfilePage, {
						profileScreens = Enums.Screens,
						fullBleed = if not FFlagAXEnableProfileTab then nil else v109.forceFullView == true,
						navigateToEditUsername = function(p10) -- line: 733
							-- upvalues: editUsername (copy), v107 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
							editUsername({
								showToast = p10,
								onUsernameChanged = function() -- line: 736
									-- upvalues: v107 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
									v107(refreshProfilePlatformUserInfo(profileId))
								end
							})
						end,
						onIdentityChange = function() -- line: 741
							-- upvalues: v107 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy)
							v107(refreshProfilePlatformUserInfo(profileId))
						end,
						onToggleInExperienceMode = if not FFlagMoveInExperienceModeToEditProfile then nil else function() -- line: 745
							-- upvalues: v107 (copy), refreshProfilePlatformUserInfo (copy), profileId (copy), v111 (copy), EventNames (copy)
							v107(refreshProfilePlatformUserInfo(profileId))
							v111.fireAnalyticsEvent(EventNames.ToggleInExperienceModeButton, {})
						end
					})
				end
			},
			[Enums.ProfileActions.IgnoreFriendRequest] = {
				text = v118[Enums.ProfileActions.IgnoreFriendRequest],
				onActivated = function() -- line: 755
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v107 (copy), NetworkingFriends (copy), profileId (copy), v106 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonIgnoreFriendRequest, {
						buttonSurface = p1
					})

					return v107(NetworkingFriends.DeclineFriendRequestFromUserId.API({
						targetUserId = profileId,
						currentUserId = v106
					})):andThen(function() -- line: 762
						-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						v107(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v118.friendRequestIgnoredToast,
							toastIcon = Images["icons/actions/reject"]
						}))

						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end)
				end
			},
			[Enums.ProfileActions.JoinExperience] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				isLoading = v128.isLoading,
				isDisabled = not v128.isInExperience,
				text = v118[Enums.ProfileActions.JoinExperience],
				onActivated = function() -- line: 779
					-- upvalues: v128 (copy)
					v128.joinExperience()
				end
			},
			[Enums.ProfileActions.PendingFriendRequest] = {
				isDisabled = true,
				buttonType = ButtonType.Secondary,
				variant = ButtonVariant.Subtle,
				text = v118[Enums.ProfileActions.PendingFriendRequest],
				onActivated = function() -- line: 788
				end
			},
			[Enums.ProfileActions.QrCode] = {
				text = v118[Enums.ProfileActions.QrCode],
				icon = IconName.SquaresGridQr,
				onActivated = function() -- line: 794
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), qRCodePage (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonShareProfileQRCode, {
						buttonSurface = p1
					})
					qRCodePage()
				end
			},
			[Enums.ProfileActions.ShareProfile] = {
				component = Foundation.Button,
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.Standard,
				text = v118[Enums.ProfileActions.ShareProfile],
				onActivated = function() -- line: 806
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v137 (copy), default (copy), Contexts (copy), v115 (copy), profileId (copy), v107 (copy), SetCurrentToastMessage (copy), TextKeys (copy), v136 (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonShareProfile, {
						buttonSurface = p1
					})

					if v137 then
						default:setClipboardText({
							context = Contexts.ProfileCard,
							text = string.format("%s/%s", v115, profileId)
						})
						v107(SetCurrentToastMessage({
							toastMessage = TextKeys.LinkCopied
						}))

						return
					end

					v136.onActivated()
				end
			},
			[Enums.ProfileActions.Report] = {
				text = v118[Enums.ProfileActions.Report],
				onActivated = function() -- line: 825
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), profileType (copy), Enums (copy), FFlagEnableAbuseReportRevampFlow (copy), FFlagEnableAbuseReportRevampProfileAndGroup (copy), AbuseVector (copy), v107 (copy), OpenDynamicAbuseReport (copy), profileId (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), v127 (copy), AppPage (copy), Url (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonReport, {
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

						v107(OpenDynamicAbuseReport({
							abuseVector = UserProfile,
							targetId = profileId,
							onClose = function() -- line: 844
								-- upvalues: v107 (copy), CloseCentralOverlay (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
								v107(CloseCentralOverlay())
								v107(refreshProfilePlatformActionInfo(profileId, v127))
							end
						}))

						return
					end

					local t7 = {
						name = AppPage.GenericWebPage,
						detail = `{ Url.BASE_URL }abusereport/{ s2 }?id={ profileId }`,
						extraProps = {
							titleKey = TextKeys.Report
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t7))

						return
					end

					v107(NavigateDown(t7))
				end
			},
			[Enums.ProfileActions.Unblock] = {
				text = v118[Enums.ProfileActions.Unblock],
				onActivated = function() -- line: 867
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v107 (copy), myUserBlockingNetworking (copy), profileId (copy), v106 (copy), refreshProfilePlatformActionInfo (copy), v127 (copy), USER_BLOCKING_ERRORS (copy), SetCurrentToastMessage (copy), v118 (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonUnblock, {
						buttonSurface = p1
					})

					return v107(myUserBlockingNetworking.UnblockUserById.API({
						userId = profileId,
						currentUserId = v106
					})):andThen(function() -- line: 875
						-- upvalues: v107 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end):catch(function(p11) -- line: 878
						-- upvalues: USER_BLOCKING_ERRORS (copy), v107 (copy), SetCurrentToastMessage (copy), v118 (copy), FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage (copy)
						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.PARENT_BLOCKED_TARGET_USER_ERROR then
							v107(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v118.unblockTargetParentManagedToast
							}))

							return
						end

						if p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_NOT_BLOCKED_ERROR then
							v107(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v118.unblockTargetNotBlockedToast
							}))

							return
						end

						if FFlagProfilePlatformEnableBlockedOnPlatformUnblockErrorMessage and p11 ~= nil and tonumber(p11.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_BLOCKED_ON_PLATFORM then
							v107(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v118.blockedOnPlatformToast
							}))

							return
						end

						v107(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v118.somethingIsWrongToast
						}))
					end)
				end
			},
			[Enums.ProfileActions.Unfriend] = {
				text = v118[Enums.ProfileActions.Unfriend],
				onActivated = function() -- line: 921
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v107 (copy), NetworkingFriends (copy), profileId (copy), v106 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfriend, {
						buttonSurface = p1
					})

					return v107(NetworkingFriends.UnfriendTargetUserId.API({
						targetUserId = profileId,
						currentUserId = v106
					})):andThen(function() -- line: 928
						-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						v107(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v118.friendRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end)
				end
			},
			[Enums.ProfileActions.CopyLink] = {
				text = v118[Enums.ProfileActions.CopyLink],
				onActivated = function() -- line: 940
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), default (copy), Contexts (copy), v100 (copy), profileId (copy), v107 (copy), SetCurrentToastMessage (copy), TextKeys (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonCopyLink, {
						buttonSurface = p1
					})
					default:setClipboardText({
						context = Contexts.ProfileCard,
						text = string.format(v100, profileId)
					})
					v107(SetCurrentToastMessage({
						toastMessage = TextKeys.LinkCopied
					}))
				end
			},
			[Enums.ProfileActions.JoinCommunity] = {
				buttonType = ButtonType.PrimaryContextual,
				variant = ButtonVariant.Emphasis,
				text = v118[Enums.ProfileActions.JoinCommunity],
				onActivated = function() -- line: 958
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), v107 (copy), GroupsNetworking (copy), profileId (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonJoinCommunity, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					return v107(GroupsNetworking.JoinGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 966
						-- upvalues: v107 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v107(getProfilePlatform.API({
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
				text = v118[Enums.ProfileActions.CancelJoinCommunityRequest],
				onActivated = function() -- line: 980
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), v107 (copy), GroupsNetworking (copy), profileId (copy), v106 (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonCancelJoinCommunityRequest, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					return v107(GroupsNetworking.CancelJoinGroupRequest.API({
						groupId = profileId,
						userId = v106
					})):andThen(function() -- line: 989
						-- upvalues: v107 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v107(refreshProfilePlatform({
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
				text = v118[Enums.ProfileActions.ViewCommunity],
				onActivated = function() -- line: 1004
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), AppPage (copy), UrlBuilder (copy), profileId (copy), TextKeys (copy), v107 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonViewCommunity, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					local t8 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.user.group({
							groupId = profileId
						}),
						extraProps = {
							titleKey = TextKeys.Community,
							onClose = function() -- line: 1015
								-- upvalues: v107 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
								v107(getProfilePlatform.API({
									includeComponentOrdering = true,
									profileType = profileType,
									profileId = profileId,
									components = getAvailableCommunityComponents()
								}))
							end
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t8))

						return
					end

					v107(NavigateDown(t8))
				end
			},
			[Enums.ProfileActions.ViewFullProfile] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else {
				buttonType = ButtonType.PrimarySystem,
				variant = ButtonVariant.SubEmphasis,
				text = v118[Enums.ProfileActions.ViewFullProfile],
				onActivated = function() -- line: 1037
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), AppPage (copy), UrlBuilder (copy), UrlBase (copy), profileId (copy), TextKeys (copy), v107 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v34 (copy), NavigateDown (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					local t9 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.new({
							base = UrlBase.WWW,
							path = `profiles/{ profileId }`
						})(),
						extraProps = {
							titleKey = TextKeys.Profile,
							onClose = function() -- line: 1051
								-- upvalues: v107 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
								v107(getProfilePlatform.API({
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

					v107(NavigateDown(t9))
				end
			},
			[Enums.ProfileActions.LeaveCommunity] = {
				text = v118[Enums.ProfileActions.LeaveCommunity],
				onActivated = function() -- line: 1071
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), v107 (copy), GroupsNetworking (copy), profileId (copy), v106 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonLeaveCommunity, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					return v107(GroupsNetworking.LeaveGroup.API({
						groupId = profileId,
						userId = v106
					})):andThen(function() -- line: 1080
						-- upvalues: v107 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v107(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.MakePrimaryCommunity] = {
				text = v118[Enums.ProfileActions.MakePrimaryCommunity],
				onActivated = function() -- line: 1092
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), v107 (copy), GroupsNetworking (copy), profileId (copy), refreshProfilePlatform (copy), profileType (copy), Enums (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonMakePrimaryCommunity, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					return v107(GroupsNetworking.MakePrimaryGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 1100
						-- upvalues: v107 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v107(refreshProfilePlatform({
							profileType = profileType,
							profileId = profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			},
			[Enums.ProfileActions.RemovePrimaryCommunity] = {
				text = v118[Enums.ProfileActions.RemovePrimaryCommunity],
				onActivated = function() -- line: 1113
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), v107 (copy), GroupsNetworking (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemovePrimaryCommunity, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					return v107(GroupsNetworking.RemovePrimaryGroup.API()):andThen(function() -- line: 1119
						-- upvalues: v107 (copy), refreshProfilePlatform (copy), profileType (copy), profileId (copy), Enums (copy)
						v107(refreshProfilePlatform({
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
				text = v118[Enums.ProfileActions.Follow],
				onActivated = function() -- line: 1136
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v107 (copy), GroupsNetworking (copy), profileId (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = p1
					})

					return v107(GroupsNetworking.JoinGroup.API({
						groupId = profileId
					})):andThen(function() -- line: 1142
						-- upvalues: v107 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v107(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.Unfollow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities or profileType ~= Enums.ProfileTypes.Community then nil else {
				text = v118[Enums.ProfileActions.Unfollow],
				onActivated = function() -- line: 1157
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v107 (copy), GroupsNetworking (copy), profileId (copy), v106 (copy), getProfilePlatform (copy), profileType (copy), getAvailableCommunityComponents (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = p1
					})

					return v107(GroupsNetworking.LeaveGroup.API({
						groupId = profileId,
						userId = v106
					})):andThen(function() -- line: 1165
						-- upvalues: v107 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
						v107(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = profileType,
							profileId = profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			},
			[Enums.ProfileActions.RemoveTrustedConnection] = {
				text = v118[Enums.ProfileActions.RemoveTrustedConnection],
				onActivated = function() -- line: 1178
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v103 (copy), profileId (copy), v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemoveTrustedConnection, {
						buttonSurface = p1
					})

					return v103.removeTrustedConnectionRequest(profileId):andThen(function() -- line: 1182
						-- upvalues: v107 (copy), SetCurrentToastMessage (copy), v118 (copy), Images (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
						v107(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v118.trustedConnectionRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return v107(refreshProfilePlatformActionInfo(profileId, v127))
					end)
				end
			},
			[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				text = v118[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1195
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v108 (copy), AppPage (copy), profileId (copy), Sources (copy), v107 (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p1
					})
					v108.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							source = Sources.ProfilePlatform,
							onRequestSent = function() -- line: 1203
								-- upvalues: v107 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
								return v107(refreshProfilePlatformActionInfo(profileId, v127))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.AddTrustedConnectionViaLink] = {
				text = v118[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1215
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), Sources (copy), v108 (copy), AppPage (copy), profileId (copy), v107 (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p1,
						modalVariantOverride = Sources.ShareLinkSender
					})
					v108.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							source = Sources.ProfilePlatform,
							modalVariantOverride = Sources.ShareLinkSender,
							onRequestSent = function() -- line: 1225
								-- upvalues: v107 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
								return v107(refreshProfilePlatformActionInfo(profileId, v127))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				text = v118[Enums.ProfileActions.AddIncomingTrustedConnection],
				onActivated = function() -- line: 1237
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v108 (copy), AppPage (copy), profileId (copy), v107 (copy), refreshProfilePlatformActionInfo (copy), v127 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddIncomingTrustedConnection, {
						buttonSurface = p1
					})
					v108.push(AppPage.TrustedContactsModal, {
						props = {
							userId = profileId,
							onRequestAccepted = function() -- line: 1244
								-- upvalues: v107 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v127 (copy)
								return v107(refreshProfilePlatformActionInfo(profileId, v127))
							end
						}
					})
				end
			},
			[Enums.ProfileActions.PendingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else {
				isDisabled = true,
				text = v118[Enums.ProfileActions.AddTrustedConnection],
				onActivated = function() -- line: 1258
				end
			},
			[Enums.ProfileActions.PendingIncomingTrustedConnection] = if not FFlagPendingIncomingTrustedConnection then nil else {
				isDisabled = true,
				text = v118[Enums.ProfileActions.AddIncomingTrustedConnection],
				onActivated = function() -- line: 1265
				end
			},
			[Enums.ProfileActions.ViewAbout] = if not FFlagProfilePlatformNewProfileHeader then nil else {
				text = v118[Enums.ProfileActions.ViewAbout],
				onActivated = function() -- line: 1271
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), v109 (copy), AppPage (copy), aboutSections (ref), FFlagProfileAboutDetailsUseSheet (copy), u125 (ref), FFlagSignalsNavP3Dispatch (copy), v34 (copy), v107 (copy), NavigateDown (copy)
					v111.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p1,
						btnContext = v109.sourceInfo.source
					})

					local t10 = {
						name = AppPage.AboutDetailsSheet,
						extraProps = {
							sections = aboutSections,
							profileName = if not FFlagProfileAboutDetailsUseSheet then nil else u125
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v34.down(v34.fromLegacyPage(t10))

						return
					end

					v107(NavigateDown(t10))
				end
			},
			[Enums.ProfileActions.ViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else {
				text = v118[Enums.ProfileActions.ViewPlatformProfile],
				onActivated = function() -- line: 1297
					-- upvalues: v111 (copy), EventNames (copy), p1 (copy), getPlatformFriendsService (copy), v121 (copy)
					v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonViewPlatformProfile, {
						buttonSurface = p1
					})
					getPlatformFriendsService:ShowProfile(v121)
				end
			},
			[Enums.ProfileActions.CurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
				text = v118[Enums.ProfileActions.CurrencyTransfer],
				onActivated = function() -- line: 1308
					-- upvalues: p1 (copy), Enums (copy), v111 (copy), EventNames (copy), v110 (copy), profileId (copy), TransferDirection (copy), TransferOrigination (copy)
					if p1 == Enums.ButtonSurface.ContextualMenu then
						v111.fireAnalyticsEvent(EventNames.ContextualMenuButtonCurrencyTransfer, {
							buttonSurface = p1
						})
					else
						v111.fireAnalyticsEvent(EventNames.CTAButtonCurrencyTransfer, {
							buttonSurface = p1
						})
					end

					if v110 then
						v110({
							recipientUserId = profileId,
							direction = TransferDirection.Send,
							transferOrigination = TransferOrigination.Profile
						})
					end
				end
			}
		}
	end, {
		v107,
		profileId,
		v109,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v110,
		qRCodePage,
		v118,
		v106,
		v108,
		editUsername,
		v128.joinExperience,
		v128.isLoading,
		v111,
		v135,
		p1,
		if not FFlagProfilePlatformNewProfileHeader then nil else aboutSections,
		if not FFlagProfileAboutDetailsUseSheet then nil else u125,
		profileType,
		editAvatar,
		if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v131,
		if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else v132,
		if not FFlagProfilePlatformCTAsRefactor then nil else v115,
		if not FFlagProfilePlatformCTAsRefactor then nil else v128.isInExperience,
		if not FFlagProfilePlatformCTAsRefactor then nil else v144,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v127
	}))
end

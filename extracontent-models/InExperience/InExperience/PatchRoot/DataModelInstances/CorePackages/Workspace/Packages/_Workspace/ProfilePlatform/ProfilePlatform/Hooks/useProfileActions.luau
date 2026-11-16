local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Navigation = require(parent.Navigation)
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
local SharedFlags = require(parent.SharedFlags)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useNavigation = Navigation.useNavigation

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local ProfileShareLinks = require(parent.ProfileShareLinks)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local TextKeys = require(ProfilePlatform.Common.TextKeys)

local useAboutSections = require(ProfilePlatform.Hooks.useAboutSections)
local useActionsComponentRequest = require(ProfilePlatform.Hooks.useActionsComponentRequest)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileJson = require(ProfilePlatform.Hooks.useProfileJson)
local viewerOwnsOpenCommunity = require(ProfilePlatform.Utils.viewerOwnsOpenCommunity)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileShareLink = ProfileShareLinks.Hooks.useProfileShareLink
local useShortUrl = ProfileShareLinks.Hooks.useShortUrl
local useGetOrGenerateLinkUrl = ProfileShareLinks.Hooks.useGetOrGenerateLinkUrl
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags2.FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet

local FFlagProfilePlatformPassPresenceToJoinUserInExperience = SharedFlags.FFlagProfilePlatformPassPresenceToJoinUserInExperience

local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagProfilePlatformPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)

local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagHideLeaveFromOpenCommunityOwner = require(ProfilePlatform.Flags.FFlagHideLeaveFromOpenCommunityOwner)
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local FFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy

local ProfileActions = require(ProfilePlatform.Components.CTARow.ProfileActions)
require(parent.GenericAbuseReporting.AbuseVector)

local Presence = require(ProfilePlatform.Rodux.Presence)
local FFlagProfilePlatformEnableUserFollow = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUserFollow)

local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)

local v = { skipFetch = true }

return function(buttonSurface)
	local localUserId = useLocalUserId()
	local dispatch = useDispatch()
	local navigation = useNavigation()
	local profileWrapperContext = useProfileWrapperContext()
	local navigateToTransfer

	if profileWrapperContext.navigateTo then
		navigateToTransfer = profileWrapperContext.navigateTo.navigateToTransfer or nil
	end

	local analytics = useProfileAnalyticsContext()
	local v2 = useShortUrl()
	useEffectOnce(useGetOrGenerateLinkUrl(), v2 == nil)

	local v3 = React.useMemo(function()
		return string.format("%s&source=ProfileShare&stamp=%s", v2 or "", unixTimestampMillis)
	end, { v2 })

	local acceptFriend = TextKeys.AcceptFriend
	local addFriend = TextKeys.AddFriend

	local v4 = {
		[Enums.ProfileActions.AcceptFriendRequest] = acceptFriend,
		[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = acceptFriend,
		[Enums.ProfileActions.AddFriend] = addFriend,
		[Enums.ProfileActions.AddFriendFromContacts] = addFriend,
		[Enums.ProfileActions.AddFriendFromContactsSent] = TextKeys.PendingRequest
	}
	local addTrustedConnection = Enums.ProfileActions.AddTrustedConnection
	local v5

	if FFlagProfilePlatformAddTC then
		v5 = TextKeys.AddTrustedConnection
	end

	v4[addTrustedConnection] = v5

	local addIncomingTrustedConnection = Enums.ProfileActions.AddIncomingTrustedConnection
	local v6

	if FFlagProfilePlatformAddTC then
		v6 = TextKeys.AcceptTrustedConnection
	end

	v4[addIncomingTrustedConnection] = v6

	v4[Enums.ProfileActions.Block] = TextKeys.Block
	v4[Enums.ProfileActions.CannotAddFriend] = addFriend
	v4[Enums.ProfileActions.Chat] = TextKeys.Chat
	v4[Enums.ProfileActions.UnlockChat] = TextKeys.UnlockChat
	v4[Enums.ProfileActions.EditAlias] = TextKeys.CustomizeName
	local editAppearance = Enums.ProfileActions.EditAppearance
	local v7

	if FFlagProfilePlatformEnableEditAppearanceMenu then
		v7 = TextKeys.EditAppearance
	end

	v4[editAppearance] = v7

	local editEmotes = Enums.ProfileActions.EditEmotes
	local v8

	if FFlagProfilePlatformEnableEditAppearanceMenu then
		v8 = TextKeys.EditEmotes
	end

	v4[editEmotes] = v8

	local switchAvatar = Enums.ProfileActions.SwitchAvatar
	local v9

	if FFlagProfilePlatformEnableEditAppearanceMenu then
		v9 = TextKeys.SwitchAvatar
	end

	v4[switchAvatar] = v9

	local editBackground = Enums.ProfileActions.EditBackground
	local v10

	if FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem then
		v10 = TextKeys.EditBackground
	end

	v4[editBackground] = v10

	v4[Enums.ProfileActions.EditAvatar] = TextKeys.EditAvatar
	local editLook = Enums.ProfileActions.EditLook
	local v11

	if FFlagProfilePlatformEnableEditLook then
		v11 = TextKeys.EditLook
	end

	v4[editLook] = v11

	v4[Enums.ProfileActions.EditProfile] = TextKeys.EditProfile
	v4[Enums.ProfileActions.IgnoreFriendRequest] = TextKeys.IgnoreFriendRequest
	v4[Enums.ProfileActions.JoinExperience] = TextKeys.Join
	local playExperience = Enums.ProfileActions.PlayExperience
	local v12

	if FFlagJoinabilityCTAContextCopy then
		v12 = TextKeys.Play
	elseif FFlagJoinabilityCTARefactor then
		v12 = TextKeys.Join
	end

	v4[playExperience] = v12

	v4[Enums.ProfileActions.PendingFriendRequest] = TextKeys.PendingRequest
	v4[Enums.ProfileActions.QrCode] = TextKeys.ToQRCode
	v4[Enums.ProfileActions.Report] = TextKeys.Report
	v4[Enums.ProfileActions.ShareProfile] = TextKeys.ShareProfile
	v4[Enums.ProfileActions.Unblock] = TextKeys.Unblock
	v4[Enums.ProfileActions.Unfriend] = TextKeys.Unfriend
	v4[Enums.ProfileActions.CopyLink] = TextKeys.CopyLink
	v4[Enums.ProfileActions.JoinCommunity] = TextKeys.JoinCommunity
	v4[Enums.ProfileActions.CancelJoinCommunityRequest] = TextKeys.CancelJoinCommunityRequest
	v4[Enums.ProfileActions.ViewCommunity] = TextKeys.ViewCommunity
	v4[Enums.ProfileActions.ViewFullProfile] = TextKeys.ViewFullProfile
	v4[Enums.ProfileActions.LeaveCommunity] = TextKeys.LeaveCommunity
	v4[Enums.ProfileActions.MakePrimaryCommunity] = TextKeys.MakePrimaryCommunity
	v4[Enums.ProfileActions.RemovePrimaryCommunity] = TextKeys.RemovePrimaryCommunity
	v4[Enums.ProfileActions.Follow] = TextKeys.Follow
	v4[Enums.ProfileActions.Unfollow] = TextKeys.Unfollow
	v4[Enums.ProfileActions.RemoveTrustedConnection] = TextKeys.RemoveTrustedConnection
	local viewAbout = Enums.ProfileActions.ViewAbout
	local v13

	if FFlagProfilePlatformNewProfileHeader then
		v13 = TextKeys.AboutThisProfile
	end

	v4[viewAbout] = v13

	local viewPlatformProfile = Enums.ProfileActions.ViewPlatformProfile
	local v14

	if FFlagEnablePlatformProfileContextualMenuOption then
		v14 = TextKeys.ViewPlatformProfile
	end

	v4[viewPlatformProfile] = v14

	local currencyTransfer = Enums.ProfileActions.CurrencyTransfer
	local v15

	if FFlagProfilePlatformEnableCurrencyTransfer then
		v15 = TextKeys.CurrencyTransfer
	end

	v4[currencyTransfer] = v15

	local tradeItems = Enums.ProfileActions.TradeItems
	local v16

	if FFlagProfilePlatformEnableTradeItems then
		v16 = TextKeys.TradeItems
	end

	v4[tradeItems] = v16
	v4.friendAcceptedToast = TextKeys.FriendAdded
	v4.friendRemovedToast = TextKeys.FriendRemoved
	v4.trustedConnectionRemovedToast = TextKeys.TrustedConnectionRemoved
	v4.friendRequestSentToast = TextKeys.FriendRequestSent
	v4.friendRequestIgnoredToast = TextKeys.RequestIgnored
	local followedToast

	if FFlagProfilePlatformEnableUserFollow then
		followedToast = TextKeys.Followed
	end

	v4.followedToast = followedToast
	local unfollowedToast

	if FFlagProfilePlatformEnableUserFollow then
		unfollowedToast = TextKeys.Unfollowed
	end

	v4.unfollowedToast = unfollowedToast
	v4.userBlockedToast = TextKeys.UserBlocked
	v4.blockLimitReachedToast = TextKeys.BlockLimitReached
	v4.blocktargetAlreadyBlockedToast = TextKeys.BlockTargetAlreadyBlocked
	v4.blockedOnPlatformToast = TextKeys.UnblockTargetBlockedOnPlatform
	v4.unblockTargetNotBlockedToast = TextKeys.UnblockTargetNotBlocked
	v4.unblockTargetParentManagedToast = TextKeys.UnblockTargetParentManaged
	v4.somethingIsWrongToast = TextKeys.SomethingIsWrong

	v4.alreadyFriendError = TextKeys.AlreadyFriendError
	v4.defaultFriendingError = TextKeys.DefaultFriendingError
	v4.invalidNicknameError = TextKeys.InvalidNicknameError
	v4.invalidTargetUserError = TextKeys.InvalidTargetUserError
	v4.maxFriendsError = TextKeys.MaxFriendsError
	v4.unauthorizedError = TextKeys.UnauthorizedError
	v4.userBannedError = TextKeys.UserBannedError
	v4.userBlockedError = TextKeys.UserBlockedError
	v4.userNotPassedCaptchaError = TextKeys.UserNotPassedCaptchaError
	v4.tooManyRequestsError = TextKeys.TooManyRequestsError
	local localized = useLocalization(v4)

	local openGameDetailsPeekViewClosed = React.useCallback(function()
		profileWrapperContext.navigateTo.previousView(true)
	end, { profileWrapperContext.navigateTo.previousView })
	local profileId = profileWrapperContext.profileId
	local profileType = profileWrapperContext.profileType
	local presence

	if FFlagProfilePlatformPresenceStoreMigration then
		presence = useGetPresenceByUserId(profileId, v)
	elseif FFlagProfilePlatformPassPresenceToJoinUserInExperience then
		presence = useSelector(function(p)
			return Presence.Selectors.getUserPresenceByUserId(p, profileId)
				or { userPresenceType = Presence.Enums.PresenceType.Offline, lastLocation = "" }
		end)
	end

	local aboutSections, profileName

	if FFlagProfilePlatformNewProfileHeader then
		local v17 = useAboutSections()
		aboutSections = v17.aboutSections

		if FFlagProfileAboutDetailsUseSheet then
			profileName = v17.profileName
		end
	end

	local v17

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		v17 = useActionsComponentRequest()
	end

	local v18

	if FFlagHideLeaveFromOpenCommunityOwner then
		v18 = useProfileJson()
	end

	local viewerOwnsOpenCommunity2

	if FFlagHideLeaveFromOpenCommunityOwner and profileType == Enums.ProfileTypes.Community then
		viewerOwnsOpenCommunity2 = viewerOwnsOpenCommunity(v18, localUserId)
	else
		viewerOwnsOpenCommunity2 = false
	end

	local v19 = {
		isHomePageCarousel = profileWrapperContext.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
		homepageCarouselAbsolutePosition = profileWrapperContext.sourceInfo.homepageCarouselAbsolutePosition,
		openGameDetailsPeekViewClosed = openGameDetailsPeekViewClosed,
		presence = 0
	}

	if not FFlagProfilePlatformPassPresenceToJoinUserInExperience then
		presence = nil
	end

	v19.presence = presence
	local experienceUtilities = useJoinUserInExperience(profileId, v19)

	local qRCodePage = profileWrapperContext.navigateTo.qRCodePage
	local editUsername = profileWrapperContext.navigateTo.editUsername
	local editEmotes2

	if FFlagProfilePlatformEnableEditAppearanceMenu then
		editEmotes2 = profileWrapperContext.navigateTo.editEmotes
	end

	local switchAvatar2

	if FFlagProfilePlatformEnableEditAppearanceMenu then
		switchAvatar2 = profileWrapperContext.navigateTo.switchAvatar
	end

	local editAvatar = profileWrapperContext.navigateTo.editAvatar

	local profileShareLink = useProfileShareLink({ context = Contexts.ProfileCard })

	local v20 = {
		localized = localized,
		analytics = analytics,
		buttonSurface = buttonSurface,
		profileWrapperContext = profileWrapperContext,
		navigateTo = profileWrapperContext.navigateTo,
		dispatch = dispatch,
		profileId = profileId,
		localUserId = localUserId,
		navigation = navigation,
		profileType = profileType,
		experienceUtilities = experienceUtilities,
		profileShareLink = profileShareLink,
		PROFILE_SHARE_LINK_URL = v3,
		aboutSections = 0,
		aboutProfileName = 0,
		actionsComponentRequest = 0,
		viewerOwnsOpenCommunity = 0
	}
	local aboutSections2

	if FFlagProfilePlatformNewProfileHeader then
		aboutSections2 = aboutSections
	end

	v20.aboutSections = aboutSections2
	local aboutProfileName

	if FFlagProfileAboutDetailsUseSheet then
		aboutProfileName = profileName
	end

	v20.aboutProfileName = aboutProfileName
	local actionsComponentRequest

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		actionsComponentRequest = v17
	end

	v20.actionsComponentRequest = actionsComponentRequest

	v20.viewerOwnsOpenCommunity = viewerOwnsOpenCommunity2

	local useMemo = React.useMemo
	local function fn()
		local result = {}

		for k, profileAction in ProfileActions do
			local v21 = profileAction(v20)

			if v21 ~= nil then
				result[k] = v21
			end
		end

		return result
	end

	if not FFlagProfilePlatformEnableCurrencyTransfer then
		navigateToTransfer = nil
	end

	local joinExperience = experienceUtilities.joinExperience
	local playExperience2

	if FFlagJoinabilityCTARefactor then
		playExperience2 = experienceUtilities.playExperience
	end

	local isLoading = experienceUtilities.isLoading

	if not FFlagProfilePlatformNewProfileHeader then
		aboutSections = nil
	end

	if not FFlagProfileAboutDetailsUseSheet then
		profileName = nil
	end

	local v21 = {
		dispatch,
		profileId,
		profileWrapperContext,
		navigateToTransfer,
		qRCodePage,
		localized,
		localUserId,
		navigation,
		editUsername,
		joinExperience,
		playExperience2,
		isLoading,
		analytics,
		buttonSurface,
		aboutSections,
		profileName,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	if not FFlagProfilePlatformEnableEditAppearanceMenu then
		editEmotes2 = nil
	end

	if not FFlagProfilePlatformEnableEditAppearanceMenu then
		switchAvatar2 = nil
	end

	local isInExperience = experienceUtilities.isInExperience

	if not FFlagProfilePlatformRefreshActionsRespectPolicies then
		v17 = nil
	end

	v21[17], v21[18], v21[19], v21[20], v21[21], v21[22], v21[23], v21[24], v21[25] = profileType, editAvatar, editEmotes2, switchAvatar2, v3, isInExperience, v20, v17, viewerOwnsOpenCommunity2
	return (useMemo(fn, v21))
end

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local SocialExperienceJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialExperienceJoin")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useNavigation = Navigation.useNavigation

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId
local ProfileShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfileShareLinks")
local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.Contexts

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local useAboutSections = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAboutSections")
local useActionsComponentRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useActionsComponentRequest")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useProfileJson = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJson")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/viewerOwnsOpenCommunity")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileShareLink = ProfileShareLinks.Hooks.useProfileShareLink
local useShortUrl = ProfileShareLinks.Hooks.useShortUrl
local useGetOrGenerateLinkUrl = ProfileShareLinks.Hooks.useGetOrGenerateLinkUrl
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local fFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC

local fFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnablePlatformProfileContextualMenuOption
local fFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local fFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet

local fFlagProfilePlatformPassPresenceToJoinUserInExperience = SharedFlags.FFlagProfilePlatformPassPresenceToJoinUserInExperience

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local FFlagProfilePlatformRefreshActionsRespectPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformRefreshActionsRespectPolicies")

local fFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")

local FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")

local FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")
local FFlagProfilePlatformEnableEditLook = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditLook")
local FFlagHideLeaveFromOpenCommunityOwner = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagHideLeaveFromOpenCommunityOwner")
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local fFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy

local ProfileActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GenericAbuseReporting/AbuseVector")

local Presence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")
local FFlagProfilePlatformEnableUserFollow = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableUserFollow")

local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)

local v5 = { skipFetch = true }

return function(p2)
	local v6 = useLocalUserId()
	local v7 = useDispatch()
	local v8 = useNavigation()
	local v9 = useProfileWrapperContext()
	local navigateToTransfer = if v9.navigateTo then v9.navigateTo.navigateToTransfer or nil else nil

	local v10 = useProfileAnalyticsContext()
	local v11 = useShortUrl()
	useEffectOnce(useGetOrGenerateLinkUrl(), v11 == nil)

	local v13 = React.useMemo(function()
		return string.format("%s&source=ProfileShare&stamp=%s", v11 or "", unixTimestampMillis)
	end, { v11 })

	local acceptFriend = TextKeys.AcceptFriend
	local addFriend = TextKeys.AddFriend

	local v15 = {
		[Enums.ProfileActions.AcceptFriendRequest] = acceptFriend,
		[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = acceptFriend,
		[Enums.ProfileActions.AddFriend] = addFriend,
		[Enums.ProfileActions.AddFriendFromContacts] = addFriend,
		[Enums.ProfileActions.AddFriendFromContactsSent] = TextKeys.PendingRequest
	}
	local addTrustedConnection = Enums.ProfileActions.AddTrustedConnection
	local v16 = if fFlagProfilePlatformAddTC then TextKeys.AddTrustedConnection else nil
	v15[addTrustedConnection] = v16

	local addIncomingTrustedConnection = Enums.ProfileActions.AddIncomingTrustedConnection
	local v17 = if fFlagProfilePlatformAddTC then TextKeys.AcceptTrustedConnection else nil
	v15[addIncomingTrustedConnection] = v17

	v15[Enums.ProfileActions.Block] = TextKeys.Block
	v15[Enums.ProfileActions.CannotAddFriend] = addFriend
	v15[Enums.ProfileActions.Chat] = TextKeys.Chat
	v15[Enums.ProfileActions.UnlockChat] = TextKeys.UnlockChat
	v15[Enums.ProfileActions.EditAlias] = TextKeys.CustomizeName
	local editAppearance = Enums.ProfileActions.EditAppearance
	local v18 = if FFlagProfilePlatformEnableEditAppearanceMenu then TextKeys.EditAppearance else nil
	v15[editAppearance] = v18

	local editEmotes = Enums.ProfileActions.EditEmotes
	local v19 = if FFlagProfilePlatformEnableEditAppearanceMenu then TextKeys.EditEmotes else nil
	v15[editEmotes] = v19

	local switchAvatar = Enums.ProfileActions.SwitchAvatar
	local v20 = if FFlagProfilePlatformEnableEditAppearanceMenu then TextKeys.SwitchAvatar else nil
	v15[switchAvatar] = v20

	local editBackground = Enums.ProfileActions.EditBackground

	local v21 = if FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem then TextKeys.EditBackground else nil
	v15[editBackground] = v21

	v15[Enums.ProfileActions.EditAvatar] = TextKeys.EditAvatar
	local editLook = Enums.ProfileActions.EditLook
	local v22 = if FFlagProfilePlatformEnableEditLook then TextKeys.EditLook else nil
	v15[editLook] = v22

	v15[Enums.ProfileActions.EditProfile] = TextKeys.EditProfile
	v15[Enums.ProfileActions.IgnoreFriendRequest] = TextKeys.IgnoreFriendRequest
	v15[Enums.ProfileActions.JoinExperience] = TextKeys.Join
	local playExperience = Enums.ProfileActions.PlayExperience
	local v23

	if fFlagJoinabilityCTAContextCopy then
		v23 = TextKeys.Play
	elseif fFlagJoinabilityCTARefactor then
		v23 = TextKeys.Join
	end

	v15[playExperience] = v23

	v15[Enums.ProfileActions.PendingFriendRequest] = TextKeys.PendingRequest
	v15[Enums.ProfileActions.QrCode] = TextKeys.ToQRCode
	v15[Enums.ProfileActions.Report] = TextKeys.Report
	v15[Enums.ProfileActions.ShareProfile] = TextKeys.ShareProfile
	v15[Enums.ProfileActions.Unblock] = TextKeys.Unblock
	v15[Enums.ProfileActions.Unfriend] = TextKeys.Unfriend
	v15[Enums.ProfileActions.CopyLink] = TextKeys.CopyLink
	v15[Enums.ProfileActions.JoinCommunity] = TextKeys.JoinCommunity
	v15[Enums.ProfileActions.CancelJoinCommunityRequest] = TextKeys.CancelJoinCommunityRequest
	v15[Enums.ProfileActions.ViewCommunity] = TextKeys.ViewCommunity
	v15[Enums.ProfileActions.ViewFullProfile] = TextKeys.ViewFullProfile
	v15[Enums.ProfileActions.LeaveCommunity] = TextKeys.LeaveCommunity
	v15[Enums.ProfileActions.MakePrimaryCommunity] = TextKeys.MakePrimaryCommunity
	v15[Enums.ProfileActions.RemovePrimaryCommunity] = TextKeys.RemovePrimaryCommunity
	v15[Enums.ProfileActions.Follow] = TextKeys.Follow
	v15[Enums.ProfileActions.Unfollow] = TextKeys.Unfollow
	v15[Enums.ProfileActions.RemoveTrustedConnection] = TextKeys.RemoveTrustedConnection
	local viewAbout = Enums.ProfileActions.ViewAbout
	local v24 = if fFlagProfilePlatformNewProfileHeader then TextKeys.AboutThisProfile else nil
	v15[viewAbout] = v24

	local viewPlatformProfile = Enums.ProfileActions.ViewPlatformProfile
	local v25 = if fFlagEnablePlatformProfileContextualMenuOption then TextKeys.ViewPlatformProfile else nil
	v15[viewPlatformProfile] = v25

	local currencyTransfer = Enums.ProfileActions.CurrencyTransfer
	local v26 = if fFlagProfilePlatformEnableCurrencyTransfer then TextKeys.CurrencyTransfer else nil
	v15[currencyTransfer] = v26

	local tradeItems = Enums.ProfileActions.TradeItems
	local v27 = if FFlagProfilePlatformEnableTradeItems then TextKeys.TradeItems else nil
	v15[tradeItems] = v27
	v15.friendAcceptedToast = TextKeys.FriendAdded
	v15.friendRemovedToast = TextKeys.FriendRemoved
	v15.trustedConnectionRemovedToast = TextKeys.TrustedConnectionRemoved
	v15.friendRequestSentToast = TextKeys.FriendRequestSent
	v15.friendRequestIgnoredToast = TextKeys.RequestIgnored
	local v28 = if FFlagProfilePlatformEnableUserFollow then TextKeys.Followed else nil
	v15.followedToast = v28
	local v29 = if FFlagProfilePlatformEnableUserFollow then TextKeys.Unfollowed else nil
	v15.unfollowedToast = v29
	v15.userBlockedToast = TextKeys.UserBlocked
	v15.blockLimitReachedToast = TextKeys.BlockLimitReached
	v15.blocktargetAlreadyBlockedToast = TextKeys.BlockTargetAlreadyBlocked
	v15.blockedOnPlatformToast = TextKeys.UnblockTargetBlockedOnPlatform
	v15.unblockTargetNotBlockedToast = TextKeys.UnblockTargetNotBlocked
	v15.unblockTargetParentManagedToast = TextKeys.UnblockTargetParentManaged
	v15.somethingIsWrongToast = TextKeys.SomethingIsWrong

	v15.alreadyFriendError = TextKeys.AlreadyFriendError
	v15.defaultFriendingError = TextKeys.DefaultFriendingError
	v15.invalidNicknameError = TextKeys.InvalidNicknameError
	v15.invalidTargetUserError = TextKeys.InvalidTargetUserError
	v15.maxFriendsError = TextKeys.MaxFriendsError
	v15.unauthorizedError = TextKeys.UnauthorizedError
	v15.userBannedError = TextKeys.UserBannedError
	v15.userBlockedError = TextKeys.UserBlockedError
	v15.userNotPassedCaptchaError = TextKeys.UserNotPassedCaptchaError
	v15.tooManyRequestsError = TextKeys.TooManyRequestsError
	local v30 = useLocalization(v15)

	local v31 = React.useCallback(function()
		v9.navigateTo.previousView(true)
	end, { v9.navigateTo.previousView })
	local profileId = v9.profileId
	local profileType = v9.profileType
	local v32

	if FFlagProfilePlatformPresenceStoreMigration then
		v32 = useGetPresenceByUserId(profileId, v5)
	elseif fFlagProfilePlatformPassPresenceToJoinUserInExperience then
		v32 = useSelector(function(p3)
			return Presence.Selectors.getUserPresenceByUserId(p3, profileId)
				or {
					userPresenceType = Presence.Enums.PresenceType.Offline,
					lastLocation = ""
				}
		end)
	end

	local aboutSections, profileName

	if fFlagProfilePlatformNewProfileHeader then
		local v33 = useAboutSections()
		aboutSections = v33.aboutSections

		if fFlagProfileAboutDetailsUseSheet then
			profileName = v33.profileName
		end
	end

	local v33 = if FFlagProfilePlatformRefreshActionsRespectPolicies then useActionsComponentRequest() else nil

	local v34 = if FFlagHideLeaveFromOpenCommunityOwner then useProfileJson() else nil
	local v35

	if FFlagHideLeaveFromOpenCommunityOwner and profileType == Enums.ProfileTypes.Community then
		v35 = module13(v34, v6)
	else
		v35 = false
	end

	local v37 = {
		isHomePageCarousel = v9.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
		homepageCarouselAbsolutePosition = v9.sourceInfo.homepageCarouselAbsolutePosition,
		openGameDetailsPeekViewClosed = v31,
		presence = 0
	}

	if not fFlagProfilePlatformPassPresenceToJoinUserInExperience then
		v32 = nil
	end

	v37.presence = v32
	local v38 = useJoinUserInExperience(profileId, v37)

	local qRCodePage = v9.navigateTo.qRCodePage
	local editUsername = v9.navigateTo.editUsername

	local editEmotes2 = if FFlagProfilePlatformEnableEditAppearanceMenu then v9.navigateTo.editEmotes else nil

	local switchAvatar2 = if FFlagProfilePlatformEnableEditAppearanceMenu then v9.navigateTo.switchAvatar else nil

	local editAvatar = v9.navigateTo.editAvatar

	local v39 = useProfileShareLink({ context = contexts.ProfileCard })

	local v40 = {
		localized = v30,
		analytics = v10,
		buttonSurface = p2,
		profileWrapperContext = v9,
		navigateTo = v9.navigateTo,
		dispatch = v7,
		profileId = profileId,
		localUserId = v6,
		navigation = v8,
		profileType = profileType,
		experienceUtilities = v38,
		profileShareLink = v39,
		PROFILE_SHARE_LINK_URL = v13,
		aboutSections = if fFlagProfilePlatformNewProfileHeader then aboutSections else nil,
		aboutProfileName = if fFlagProfileAboutDetailsUseSheet then profileName else nil,
		actionsComponentRequest = if FFlagProfilePlatformRefreshActionsRespectPolicies then v33 else nil,
		viewerOwnsOpenCommunity = v35
	}

	local useMemo = React.useMemo
	local function fn()
		local result = {}

		for k, v44 in ProfileActions do
			local v45 = v44(v40)

			if v45 ~= nil then
				result[k] = v45
			end
		end

		return result
	end

	if not fFlagProfilePlatformEnableCurrencyTransfer then
		navigateToTransfer = nil
	end

	local joinExperience = v38.joinExperience
	local playExperience2 = if fFlagJoinabilityCTARefactor then v38.playExperience else nil
	local isLoading = v38.isLoading

	if not fFlagProfilePlatformNewProfileHeader then
		aboutSections = nil
	end

	if not fFlagProfileAboutDetailsUseSheet then
		profileName = nil
	end

	local v44 = {
		v7,
		profileId,
		v9,
		navigateToTransfer,
		qRCodePage,
		v30,
		v6,
		v8,
		editUsername,
		joinExperience,
		playExperience2,
		isLoading,
		v10,
		p2,
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

	local isInExperience = v38.isInExperience

	if not FFlagProfilePlatformRefreshActionsRespectPolicies then
		v33 = nil
	end

	v44[17], v44[18], v44[19], v44[20], v44[21], v44[22], v44[23], v44[24], v44[25] = profileType, editAvatar, editEmotes2, switchAvatar2, v13, isInExperience, v40, v33, v35
	return (useMemo(fn, v44))
end

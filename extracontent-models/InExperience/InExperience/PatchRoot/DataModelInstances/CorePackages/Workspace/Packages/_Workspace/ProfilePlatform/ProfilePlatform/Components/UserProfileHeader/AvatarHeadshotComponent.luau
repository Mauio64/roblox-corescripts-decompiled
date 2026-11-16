local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local FoundationImages = require(parent.FoundationImages)
local iconsactionseditcopy = FoundationImages.Images["icons/actions/edit/copy"]
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local useCurrentProfileFriendStatus = require(ProfilePlatform.Hooks.useCurrentProfileFriendStatus)
local SocialCommon = require(parent.SocialCommon)
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFontStylisticAlternativesOnSocialScreens = SharedFlags.FFlagEnableFontStylisticAlternativesOnSocialScreens
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddPlatformNameToProfileHeader = SharedFlags2.FFlagAddPlatformNameToProfileHeader
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags3.FFlagEnableBlackbirdCheck
local SharedFlags4 = require(parent.SharedFlags)
local FFlagDisableCopyUsernameOnConsole = SharedFlags4.FFlagDisableCopyUsernameOnConsole
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableUserRecentActivityEntryPoint = SharedFlags5.FFlagEnableUserRecentActivityEntryPoint
local Responsive = require(parent.Responsive)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform

local function AvatarHeadshotComponent(props)
	local v = useTokens()
	local v2, v3 = useDynamicSizeMargin()
	local v4 = useLocalUserId()

	local userId = props.userId
	local v5 = userId == tostring(v4)
	local userPresenceType

	if not (v5 or not props.userPresenceType) then
		userPresenceType = convertToFoundationPresenceEnum(props.userPresenceType)
	end

	local subtitle

	if props.username and props.username ~= "" then
		if FFlagEnableFontStylisticAlternativesOnSocialScreens then
			subtitle = `<font features="zero, ss03">@{props.username}</font>`
		else
			subtitle = "@" .. props.username
		end
	else
		subtitle = ""
	end

	local v6 = useDispatch()
	local v7 = useLocalization({
		usernameCopied = TextKeys.UsernameCopied,
		viewRecentActivity = TextKeys.ViewRecentActivity
	})

	local contextualInfoIcon = React.useMemo(function()
		if FFlagAddPlatformNameToProfileHeader then
			return (getBuilderIconForCurrentPlatform())
		end

		return nil
	end, {})
	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = useIsRobloxSubscriber(userId)
	end

	local v8

	if FFlagDisableCopyUsernameOnConsole then
		v8 = Responsive.usePreferredInput() == Responsive.Input.Directional
	else
		v8 = false
	end

	local v9

	if FFlagEnableUserRecentActivityEntryPoint then
		v9 = useCurrentProfileFriendStatus()
	end

	local v10

	if FFlagEnableUserRecentActivityEntryPoint then
		v10 = v5 or v9 == Enums.FriendStatus.Friends
	else
		v10 = false
	end

	local v11

	if FFlagEnableUserRecentActivityEntryPoint then
		v11 = useNavigation()
	else
		v11 = nil
	end

	local onExtraInfoClicked

	if FFlagEnableUserRecentActivityEntryPoint then
		onExtraInfoClicked = React.useCallback(function()
			v11.navigate(AppPage.UserRecentActivity, {
				userId = props.userId,
				primaryName = props.primaryName
			})
		end, { v11, props.userId, props.primaryName })
	end

	local onSubtitleClicked = React.useCallback(function()
		default:setClipboardText({ context = Contexts.ProfileCard, text = props.username })

		v6(SetCurrentToastMessage({
			toastMessage = v7.usernameCopied,
			isLocalized = true,
			toastIcon = iconsactionseditcopy
		}))
	end)

	local createElement = React.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 0, Constants.AVATAR_HEADSHOT_HEIGHT),
		Position = UDim2.new(0, 0, 0, -(Constants.AVATAR_HEADSHOT_HEIGHT / 2) - v.Gap.Large),
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v3
	}
	local v13 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v2),
			PaddingRight = UDim.new(0, v2)
		}),
		UserTile = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		layoutOrder = 1,
		userId = props.userId,
		title = props.primaryName,
		isVerified = props.isVerified,
		isPremium = props.isPremium,
		isRobloxAdmin = props.isRobloxAdmin,
		subtitle = subtitle,
		contextualInfo = 0,
		contextualInfoIcon = 0,
		layoutMode = 0,
		userPresenceType = 0,
		titleStyle = 0,
		subtitleStyle = 0,
		onSubtitleClicked = 0,
		trustedConnectionIndicatorEnabled = true,
		isRobloxSubscriber = 0,
		extraInfo = 0,
		onExtraInfoClicked = 0
	}
	local contextualInfo

	if FFlagAddPlatformNameToProfileHeader then
		contextualInfo = props.platformName
	end

	v14.contextualInfo = contextualInfo

	if not FFlagAddPlatformNameToProfileHeader then
		contextualInfoIcon = nil
	end

	v14.contextualInfoIcon = contextualInfoIcon
	v14.layoutMode = LayoutMode.wide
	v14.userPresenceType = userPresenceType
	v14.titleStyle = v.Typography.HeadingSmall
	v14.subtitleStyle = v.Typography.BodyMedium

	if v8 then
		onSubtitleClicked = nil
	end

	v14.onSubtitleClicked = onSubtitleClicked

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	v14.isRobloxSubscriber = isRobloxSubscriber
	local extraInfo

	if v10 then
		extraInfo = v7.viewRecentActivity
	end

	v14.extraInfo = extraInfo

	if not v10 then
		onExtraInfoClicked = nil
	end

	v14.onExtraInfoClicked = onExtraInfoClicked
	v13.UserTile = createElement2(userTile, v14)
	return createElement("Frame", v12, v13)
end

return AvatarHeadshotComponent

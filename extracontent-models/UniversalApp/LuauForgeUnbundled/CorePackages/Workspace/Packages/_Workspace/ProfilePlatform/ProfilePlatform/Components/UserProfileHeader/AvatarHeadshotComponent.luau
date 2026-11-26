local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserTile").LayoutMode
local iconsactionseditcopy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FoundationImages").Images["icons/actions/edit/copy"]
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useCurrentProfileFriendStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useCurrentProfileFriendStatus")
local convertToFoundationPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon").Utils.convertToFoundationPresenceEnum
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.Contexts
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local fFlagEnableFontStylisticAlternativesOnSocialScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableFontStylisticAlternativesOnSocialScreens
local fFlagAddPlatformNameToProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddPlatformNameToProfileHeader
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagDisableCopyUsernameOnConsole = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagDisableCopyUsernameOnConsole
local fFlagEnableUserRecentActivityEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableUserRecentActivityEntryPoint
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation

local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfiles").Hooks.useIsRobloxSubscriber

local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform

local function AvatarHeadshotComponent(props)
	local v5 = useTokens()
	local v6, v7 = useDynamicSizeMargin()
	local v8 = useLocalUserId()

	local userId = props.userId
	local v9 = userId == tostring(v8)
	local v10

	if not (v9 or not props.userPresenceType) then
		v10 = convertToFoundationPresenceEnum(props.userPresenceType)
	end

	local v11

	if props.username and props.username ~= "" then
		if fFlagEnableFontStylisticAlternativesOnSocialScreens then
			v11 = `<font features="zero, ss03">@{props.username}</font>`
		else
			v11 = "@" .. props.username
		end
	else
		v11 = ""
	end

	local v12 = useDispatch()
	local v13 = useLocalization({
		usernameCopied = TextKeys.UsernameCopied,
		viewRecentActivity = TextKeys.ViewRecentActivity
	})

	local v14 = React.useMemo(function()
		if fFlagAddPlatformNameToProfileHeader then
			return (getBuilderIconForCurrentPlatform())
		end

		return nil
	end, {})

	local v15 = if fFlagEnableBlackbirdCheck then useIsRobloxSubscriber(userId) else nil
	local v16

	if fFlagDisableCopyUsernameOnConsole then
		v16 = Responsive.usePreferredInput() == Responsive.Input.Directional
	else
		v16 = false
	end

	local v17 = if fFlagEnableUserRecentActivityEntryPoint then useCurrentProfileFriendStatus() else nil
	local v18

	if fFlagEnableUserRecentActivityEntryPoint then
		v18 = v9 or v17 == Enums.FriendStatus.Friends
	else
		v18 = false
	end

	local v19 = if fFlagEnableUserRecentActivityEntryPoint then useNavigation() else nil
	local v20

	if fFlagEnableUserRecentActivityEntryPoint then
		v20 = React.useCallback(function()
			v19.navigate(appPage.UserRecentActivity, {
				userId = props.userId,
				primaryName = props.primaryName
			})
		end, { v19, props.userId, props.primaryName })
	end

	local v21 = React.useCallback(function()
		default:setClipboardText({
			context = contexts.ProfileCard,
			text = props.username
		})

		v12(setCurrentToastMessage({
			toastMessage = v13.usernameCopied,
			isLocalized = true,
			toastIcon = iconsactionseditcopy
		}))
	end)

	local createElement = React.createElement
	local v23 = {
		Size = UDim2.new(1, 0, 0, Constants.AVATAR_HEADSHOT_HEIGHT),
		Position = UDim2.new(0, 0, 0, -(Constants.AVATAR_HEADSHOT_HEIGHT / 2) - v5.Gap.Large),
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v7
	}
	local v24 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v6),
			PaddingRight = UDim.new(0, v6)
		}),
		UserTile = 0
	}

	local createElement2 = React.createElement
	local v26 = {
		layoutOrder = 1,
		userId = props.userId,
		title = props.primaryName,
		isVerified = props.isVerified,
		isPremium = props.isPremium,
		isRobloxAdmin = props.isRobloxAdmin,
		subtitle = v11,
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

	local v27 = if fFlagAddPlatformNameToProfileHeader then props.platformName else nil
	v26.contextualInfo = v27

	if not fFlagAddPlatformNameToProfileHeader then
		v14 = nil
	end

	v26.contextualInfoIcon = v14
	v26.layoutMode = layoutMode.wide
	v26.userPresenceType = v10
	v26.titleStyle = v5.Typography.HeadingSmall
	v26.subtitleStyle = v5.Typography.BodyMedium

	if v16 then
		v21 = nil
	end

	v26.onSubtitleClicked = v21

	if not fFlagEnableBlackbirdCheck then
		v15 = nil
	end

	v26.isRobloxSubscriber = v15
	local v28 = if v18 then v13.viewRecentActivity else nil
	v26.extraInfo = v28

	if not v18 then
		v20 = nil
	end

	v26.onExtraInfoClicked = v20
	v24.UserTile = createElement2(userTile, v26)
	return createElement("Frame", v23, v24)
end

return AvatarHeadshotComponent

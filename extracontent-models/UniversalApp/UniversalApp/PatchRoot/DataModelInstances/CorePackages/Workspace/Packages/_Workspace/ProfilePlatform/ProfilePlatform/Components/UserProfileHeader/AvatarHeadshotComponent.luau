local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local UserTile = require(ProfilePlatformParent.UserTile).UserTile
local LayoutMode = require(ProfilePlatformParent.UserTile).LayoutMode
local v7 = require(ProfilePlatformParent.FoundationImages).Images["icons/actions/edit/copy"]
local Constants = require(ProfilePlatform.Common.Constants)
local convertToFoundationPresenceEnum = require(ProfilePlatformParent.SocialCommon).Utils.convertToFoundationPresenceEnum
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local default = require(ProfilePlatformParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Contexts = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FFlagEnableFontStylisticAlternativesOnSocialScreens = require(ProfilePlatformParent.SharedFlags).FFlagEnableFontStylisticAlternativesOnSocialScreens
local FFlagUserTileTextTCIndicator = require(ProfilePlatformParent.SharedFlags).FFlagUserTileTextTCIndicator
local FFlagAddPlatformNameToProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagAddPlatformNameToProfileHeader
local FFlagEnableBlackbirdCheck = require(ProfilePlatformParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagDisableCopyUsernameOnConsole = require(ProfilePlatformParent.SharedFlags).FFlagDisableCopyUsernameOnConsole
local Responsive = require(ProfilePlatformParent.Responsive)
local useIsRobloxSubscriber = require(ProfilePlatformParent.UserProfiles).Hooks.useIsRobloxSubscriber
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform

local function AvatarHeadshotComponent(t1: {[any]: any}) -- line: 49
	-- upvalues: useTokens (copy), useDynamicSizeMargin (copy), useLocalUserId (copy), convertToFoundationPresenceEnum (copy), FFlagEnableFontStylisticAlternativesOnSocialScreens (copy), useDispatch (copy), useLocalization (copy), TextKeys (copy), React (copy), FFlagAddPlatformNameToProfileHeader (copy), getBuilderIconForCurrentPlatform (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), FFlagDisableCopyUsernameOnConsole (copy), Responsive (copy), default (copy), Contexts (copy), SetCurrentToastMessage (copy), v7 (copy), Constants (copy), UserTile (copy), LayoutMode (copy), FFlagUserTileTextTCIndicator (copy)
	local v29 = useTokens()
	local v30, v31 = useDynamicSizeMargin()
	local v32 = useLocalUserId()
	local userId = t1.userId
	local v34 = if userId ~= tostring(v32) and t1.userPresenceType then convertToFoundationPresenceEnum(t1.userPresenceType) else nil
	local v35 = (not t1.username or t1.username == "") and "" or if not FFlagEnableFontStylisticAlternativesOnSocialScreens then "@" .. t1.username else `<font features="zero, ss03">@{ t1.username }</font>`
	local v36 = useDispatch()
	local v37 = useLocalization({
		usernameCopied = TextKeys.UsernameCopied
	})
	local v38 = React.useMemo(function() -- line: 72
		-- upvalues: FFlagAddPlatformNameToProfileHeader (copy), getBuilderIconForCurrentPlatform (copy)
		if FFlagAddPlatformNameToProfileHeader then
			return (getBuilderIconForCurrentPlatform())
		end

		return nil
	end, {})
	local v39 = nil

	if FFlagEnableBlackbirdCheck then
		v39 = useIsRobloxSubscriber(userId)
	end

	local v40 = not not FFlagDisableCopyUsernameOnConsole and Responsive.usePreferredInput() == Responsive.Input.Directional
	local v41 = React.useCallback(function() -- line: 85
		-- upvalues: default (copy), Contexts (copy), t1 (copy), v36 (copy), SetCurrentToastMessage (copy), v37 (copy), v7 (copy)
		default:setClipboardText({
			context = Contexts.ProfileCard,
			text = t1.username
		})
		v36(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v37.usernameCopied,
			toastIcon = v7
		}))
	end)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, Constants.AVATAR_HEADSHOT_HEIGHT),
		Position = UDim2.new(0, 0, 0, -(Constants.AVATAR_HEADSHOT_HEIGHT / 2) - v29.Gap.Large),
		LayoutOrder = t1.layoutOrder,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v31
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v30),
			PaddingRight = UDim.new(0, v30)
		}),
		UserTile = React.createElement(UserTile, {
			layoutOrder = 1,
			userId = t1.userId,
			title = t1.primaryName,
			isVerified = t1.isVerified,
			isPremium = t1.isPremium,
			isRobloxAdmin = t1.isRobloxAdmin,
			subtitle = v35,
			contextualInfo = if not FFlagAddPlatformNameToProfileHeader then nil else t1.platformName,
			contextualInfoIcon = if not FFlagAddPlatformNameToProfileHeader then nil else v38,
			layoutMode = LayoutMode.wide,
			userPresenceType = v34,
			titleStyle = v29.Typography.HeadingSmall,
			subtitleStyle = v29.Typography.BodyMedium,
			onSubtitleClicked = if not v40 then v41 else nil,
			trustedConnectionIndicatorEnabled = not not FFlagUserTileTextTCIndicator or nil,
			isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v39
		})
	})
end

return AvatarHeadshotComponent

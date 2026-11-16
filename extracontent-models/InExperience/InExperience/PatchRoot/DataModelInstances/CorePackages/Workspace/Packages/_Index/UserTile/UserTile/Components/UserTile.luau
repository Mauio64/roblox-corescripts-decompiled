local userTile = script:FindFirstAncestor("UserTile")
local parent = userTile.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local TitleStack = require(userTile.Components.TitleStack)
local Avatar = require(userTile.Components.Avatar)
local AvatarPile = require(userTile.Components.AvatarPile)
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local Enums = Foundation.Enums

local LayoutMode = require(script.Parent.Parent.Enums.LayoutMode)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagUserTileShowShimmerWhenLoading = require(userTile.Flags.FFlagUserTileShowShimmerWhenLoading)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags2.FFlagEnableBlackbirdCheck
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserTileShowBadges = SharedFlags3.FFlagUserTileShowBadges
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableMobileGameJoinCard = SharedFlags4.FFlagEnableMobileGameJoinCard
local SharedFlags5 = require(parent.SharedFlags)
local FFlagUserTileAddContextualInfoIcon = SharedFlags5.FFlagUserTileAddContextualInfoIcon
local SharedFlags6 = require(parent.SharedFlags)
local FFlagUserTileTitleStackAddExtraInfo = SharedFlags6.FFlagUserTileTitleStackAddExtraInfo
local SharedFlags7 = require(parent.SharedFlags)
local FFlagUserTileUnfilteredChatIndicator = SharedFlags7.FFlagUserTileUnfilteredChatIndicator

local function UserTile(props)
	local state, setState = React.useState(false)
	local v = props.onActivated ~= nil
	local onStateChanged = React.useCallback(function(p)
		setState(v and (p == ControlState.Hover or p == ControlState.Pressed))

		if props.onStateChanged then
			props.onStateChanged(p)
		end
	end, { props.onActivated, props.onStateChanged })

	local createElement = React.createElement
	local v2 = {
		tag = {
			["size-full"] = true,
			["col align-x-center gap-small"] = props.layoutMode == LayoutMode.compact,
			["row align-y-center gap-medium"] = props.layoutMode == LayoutMode.wide
		},
		selection = { Selectable = props.selectable },
		onStateChanged = onStateChanged,
		onActivated = props.onActivated,
		stateLayer = { affordance = Enums.StateLayerAffordance.None }
	}

	local createElement2 = React.createElement
	local v3 = { tag = "size-full aspect-1-1", Size = props.avatarSize, LayoutOrder = 1 }
	local avatarComponent

	if props.facePileSecondUserId then
		avatarComponent = React.createElement(AvatarPile, {
			layoutOrder = 1,
			primaryUserId = props.userId,
			secondUserId = props.facePileSecondUserId,
			userPresenceType = props.userPresenceType,
			ZIndex = 2,
			hover = state
		})
	else
		local createElement3 = React.createElement
		local avatarThumbnailUrl

		if FFlagUserTileShowShimmerWhenLoading then
			avatarThumbnailUrl = props.avatarThumbnailUrl
		end

		avatarComponent = createElement3(Avatar, {
			avatarThumbnailUrl = avatarThumbnailUrl,
			layoutOrder = 1,
			userId = props.userId,
			userPresenceType = props.userPresenceType,
			ZIndex = 2,
			hover = state,
			backplateStyle = props.backplateStyle,
			includeProfileFrame = props.includeProfileFrame,
			overlayIcon = props.overlayIcon
		})
	end

	local children = {
		AvatarThumbnail = createElement2(View, v3, { AvatarComponent = avatarComponent }),
		TitleStack = 0
	}

	local createElement3 = React.createElement
	local v4 = {
		layoutOrder = 2,
		title = props.title,
		isVerified = 0,
		isPremium = 0,
		isRobloxAdmin = 0,
		subtitle = 0,
		contextualInfo = 0,
		contextualInfoIcon = 0,
		layoutMode = 0,
		titleStyle = 0,
		subtitleStyle = 0,
		contextualInfoStyle = 0,
		ZIndex = 1,
		titleIcon = 0,
		onSubtitleClicked = 0,
		isTitleLoading = 0,
		isSubtitleLoading = 0,
		isContextualInfoLoading = 0,
		customTextTruncation = 0,
		isTrustedConnection = 0,
		trustedConnectionIndicatorEnabled = 0,
		shouldShowUnfilteredChatIndicator = 0,
		isRobloxSubscriber = 0,
		extraInfo = 0,
		isExtraInfoLoading = 0,
		extraInfoStyle = 0,
		onExtraInfoClicked = 0
	}
	local isVerified

	if FFlagUserTileShowBadges then
		isVerified = props.isVerified
	end

	v4.isVerified = isVerified
	local isPremium

	if FFlagUserTileShowBadges then
		isPremium = props.isPremium
	end

	v4.isPremium = isPremium
	local isRobloxAdmin

	if FFlagUserTileShowBadges then
		isRobloxAdmin = props.isRobloxAdmin
	end

	v4.isRobloxAdmin = isRobloxAdmin
	v4.subtitle = props.subtitle
	v4.contextualInfo = props.contextualInfo
	local contextualInfoIcon

	if FFlagUserTileAddContextualInfoIcon then
		contextualInfoIcon = props.contextualInfoIcon
	end

	v4.contextualInfoIcon = contextualInfoIcon
	v4.layoutMode = props.layoutMode
	v4.titleStyle = props.titleStyle
	v4.subtitleStyle = props.subtitleStyle
	v4.contextualInfoStyle = props.contextualInfoStyle

	v4.titleIcon = props.titleIcon
	local onSubtitleClicked

	if FFlagProfilePlatformNewProfileHeader or FFlagEnableMobileGameJoinCard then
		onSubtitleClicked = props.onSubtitleClicked
	end

	v4.onSubtitleClicked = onSubtitleClicked
	local isTitleLoading

	if FFlagUserTileShowShimmerWhenLoading then
		isTitleLoading = props.isTitleLoading
	end

	v4.isTitleLoading = isTitleLoading
	local isSubtitleLoading

	if FFlagUserTileShowShimmerWhenLoading then
		isSubtitleLoading = props.isSubtitleLoading
	end

	v4.isSubtitleLoading = isSubtitleLoading
	local isContextualInfoLoading

	if FFlagUserTileShowShimmerWhenLoading then
		isContextualInfoLoading = props.isContextualInfoLoading
	end

	v4.isContextualInfoLoading = isContextualInfoLoading

	v4.customTextTruncation = props.customTextTruncation
	v4.isTrustedConnection = props.isTrustedConnection
	v4.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled
	local shouldShowUnfilteredChatIndicator

	if FFlagUserTileUnfilteredChatIndicator then
		shouldShowUnfilteredChatIndicator = props.shouldShowUnfilteredChatIndicator
	end

	v4.shouldShowUnfilteredChatIndicator = shouldShowUnfilteredChatIndicator
	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = props.isRobloxSubscriber
	end

	v4.isRobloxSubscriber = isRobloxSubscriber
	v4.extraInfo = props.extraInfo
	local isExtraInfoLoading

	if FFlagUserTileTitleStackAddExtraInfo then
		isExtraInfoLoading = props.isExtraInfoLoading
	end

	v4.isExtraInfoLoading = isExtraInfoLoading
	v4.extraInfoStyle = props.extraInfoStyle
	v4.onExtraInfoClicked = props.onExtraInfoClicked
	children.TitleStack = createElement3(TitleStack, v4)
	return createElement(View, v2, children)
end

return UserTile

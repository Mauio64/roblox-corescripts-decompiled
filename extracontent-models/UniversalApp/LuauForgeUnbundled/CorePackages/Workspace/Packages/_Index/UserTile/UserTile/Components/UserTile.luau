local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Foundation")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Components/TitleStack")
local Avatar = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Components/Avatar")
local AvatarPile = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Components/AvatarPile")
local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local enums = Foundation.Enums

local LayoutMode = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Enums/LayoutMode")

local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagProfilePlatformNewProfileHeader
local FFlagUserTileShowShimmerWhenLoading = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Flags/FFlagUserTileShowShimmerWhenLoading")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagUserTileShowBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileShowBadges
local fFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagEnableMobileGameJoinCard
local fFlagUserTileAddContextualInfoIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileAddContextualInfoIcon
local fFlagUserTileTitleStackAddExtraInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileTitleStackAddExtraInfo
local fFlagUserTileUnfilteredChatIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileUnfilteredChatIndicator

local function UserTile(props)
	local state, setState = React.useState(false)
	local v5 = props.onActivated ~= nil
	local v6 = React.useCallback(function(p2)
		setState(v5 and (p2 == controlState.Hover or p2 == controlState.Pressed))

		if props.onStateChanged then
			props.onStateChanged(p2)
		end
	end, { props.onActivated, props.onStateChanged })

	local createElement = React.createElement
	local v8 = {
		tag = {
			["size-full"] = true,
			["col align-x-center gap-small"] = props.layoutMode == LayoutMode.compact,
			["row align-y-center gap-medium"] = props.layoutMode == LayoutMode.wide
		},
		selection = { Selectable = props.selectable },
		onStateChanged = v6,
		onActivated = props.onActivated,
		stateLayer = { affordance = enums.StateLayerAffordance.None }
	}

	local createElement2 = React.createElement
	local v10 = {
		tag = "size-full aspect-1-1",
		Size = props.avatarSize,
		LayoutOrder = 1
	}
	local v12

	if props.facePileSecondUserId then
		v12 = React.createElement(AvatarPile, {
			layoutOrder = 1,
			primaryUserId = props.userId,
			secondUserId = props.facePileSecondUserId,
			userPresenceType = props.userPresenceType,
			ZIndex = 2,
			hover = state
		})
	else
		local createElement3 = React.createElement
		local v15 = if FFlagUserTileShowShimmerWhenLoading then props.avatarThumbnailUrl else nil
		v12 = createElement3(Avatar, {
			avatarThumbnailUrl = v15,
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
		AvatarThumbnail = createElement2(view, v10, { AvatarComponent = v12 }),
		TitleStack = 0
	}

	local createElement3 = React.createElement
	local v14 = {
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
	local v15 = if fFlagUserTileShowBadges then props.isVerified else nil
	v14.isVerified = v15
	local v16 = if fFlagUserTileShowBadges then props.isPremium else nil
	v14.isPremium = v16
	local v17 = if fFlagUserTileShowBadges then props.isRobloxAdmin else nil
	v14.isRobloxAdmin = v17
	v14.subtitle = props.subtitle
	v14.contextualInfo = props.contextualInfo
	local v18 = if fFlagUserTileAddContextualInfoIcon then props.contextualInfoIcon else nil
	v14.contextualInfoIcon = v18
	v14.layoutMode = props.layoutMode
	v14.titleStyle = props.titleStyle
	v14.subtitleStyle = props.subtitleStyle
	v14.contextualInfoStyle = props.contextualInfoStyle

	v14.titleIcon = props.titleIcon

	local v19 = if fFlagProfilePlatformNewProfileHeader or fFlagEnableMobileGameJoinCard then props.onSubtitleClicked else nil
	v14.onSubtitleClicked = v19

	local v20 = if FFlagUserTileShowShimmerWhenLoading then props.isTitleLoading else nil
	v14.isTitleLoading = v20
	local v21 = if FFlagUserTileShowShimmerWhenLoading then props.isSubtitleLoading else nil
	v14.isSubtitleLoading = v21

	local v22 = if FFlagUserTileShowShimmerWhenLoading then props.isContextualInfoLoading else nil
	v14.isContextualInfoLoading = v22

	v14.customTextTruncation = props.customTextTruncation
	v14.isTrustedConnection = props.isTrustedConnection
	v14.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled

	local v23 = if fFlagUserTileUnfilteredChatIndicator then props.shouldShowUnfilteredChatIndicator else nil
	v14.shouldShowUnfilteredChatIndicator = v23

	local v24 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber else nil
	v14.isRobloxSubscriber = v24
	v14.extraInfo = props.extraInfo
	local v25 = if fFlagUserTileTitleStackAddExtraInfo then props.isExtraInfoLoading else nil
	v14.isExtraInfoLoading = v25
	v14.extraInfoStyle = props.extraInfoStyle
	v14.onExtraInfoClicked = props.onExtraInfoClicked
	children.TitleStack = createElement3(module3, v14)
	return createElement(view, v8, children)
end

return UserTile

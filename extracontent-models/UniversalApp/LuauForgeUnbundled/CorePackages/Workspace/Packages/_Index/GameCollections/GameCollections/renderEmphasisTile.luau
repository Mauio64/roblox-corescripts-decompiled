local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes

local fFlagLuaAppEmphasisGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEmphasisGameTileVideo

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local emphasisGameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").EmphasisGameTile
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/VideoUtils")

local memo = React.memo(function(props)
	local createElement = React.createElement
	local v6 = {
		size = props.item.sizeOverride,
		index = props.index,
		layoutOrder = props.index,
		SelectionOrder = props.SelectionOrder,
		isDisabled = props.isDisabled,
		onSelectionGained = props.onHoldableFocused,
		onSelectionLost = props.onHoldableUnfocused,
		entry = props.item,
		topicId = props.topicId,
		source = props.source,
		referralSource = props.referralSource,
		playerCountStyle = props.playerCountStyle,
		hideGameStats = props.hideGameStats,
		gameTileLayoutType = props.gameTileLayoutType,
		useHoverTile = props.hoverTileEnabled,
		isContained = props.isContained,
		reportGameDetailOpened = props.reportGameDetailOpened,
		reportExperienceLaunched = props.reportExperienceLaunched,
		launchExperienceEventContext = props.launchExperienceEventContext,
		onPeekViewClosed = props.onPeekViewClosed,
		navigateToGameDetails = props.navigateToGameDetails,
		impressionsTag = props.impressionsTag,
		textSizeOffset = props.textSizeOffset,
		showDescription = props.item.showDescription,
		zIndex = props.zIndex,
		videoPlaybackContext = props.videoPlaybackContext,
		appPage = 0,
		videoAnalytics = 0
	}
	local v7 = if fFlagLuaAppEmphasisGameTileVideo then props.appPage else nil
	v6.appPage = v7
	local v8 = if fFlagLuaAppEmphasisGameTileVideo then props.videoAnalytics else nil
	v6.videoAnalytics = v8
	return createElement(emphasisGameTile, v6)
end)

return function(p2)
	return React.createElement(memo, p2), gameCollectionItemTypes.GameCollectionItemType.EmphasisTile
end

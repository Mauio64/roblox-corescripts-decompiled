local parent = script:FindFirstAncestor("GameCollections").Parent

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEmphasisGameTileVideo = SharedFlags.FFlagLuaAppEmphasisGameTileVideo

local React = require(parent.React)
local GameTile = require(parent.GameTile)
local EmphasisGameTile = GameTile.EmphasisGameTile
require(parent.VideoUtils)

local memo = React.memo(function(props)
	local createElement = React.createElement
	local v = {
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
	local appPage

	if FFlagLuaAppEmphasisGameTileVideo then
		appPage = props.appPage
	end

	v.appPage = appPage
	local videoAnalytics

	if FFlagLuaAppEmphasisGameTileVideo then
		videoAnalytics = props.videoAnalytics
	end

	v.videoAnalytics = videoAnalytics
	return createElement(EmphasisGameTile, v)
end)

return function(p)
	return React.createElement(memo, p), GameCollectionItemTypes.GameCollectionItemType.EmphasisTile
end

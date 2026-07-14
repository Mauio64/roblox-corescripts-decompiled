local Parent = script:FindFirstAncestor("GameCollections").Parent
local SharedFlags = require(Parent.SharedFlags)
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local React = require(Parent.React)
local GameTile = require(Parent.GameTile)
local OneByTwoTile = GameTile.OneByTwoTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry

require(Parent.VideoUtils)

local FFlagLuaAppHomeTouchAutoplay = SharedFlags.FFlagLuaAppHomeTouchAutoplay
local v9 = React.memo(function(t1: {[any]: any}) -- line: 31
	-- upvalues: getTileBadgeByPositionConfigFromEntry (copy), React (copy), OneByTwoTile (copy), FFlagLuaAppHomeTouchAutoplay (copy)
	local v11 = getTileBadgeByPositionConfigFromEntry(t1.item)
	local v12 = -((t1.maxItemIndex or 0) + 1)
	local v13 = if not t1.zIndex then v12 else t1.zIndex + v12

	return React.createElement(OneByTwoTile, {
		size = t1.item.sizeOverride,
		layoutOrder = t1.index,
		zIndex = v13,
		contentType = t1.item.contentType,
		universeId = t1.item.universeId,
		placeId = t1.item.placeId,
		placeIdOverride = t1.item.placeIdOverride,
		launchDataOverride = t1.item.launchDataOverride,
		referralSource = t1.appPage,
		reportExperienceLaunched = t1.reportExperienceLaunched,
		topicId = t1.topicId,
		badgeOverride = v11,
		primaryImageAssetId = t1.item.primaryImageAssetId,
		primaryVideoAssetId = t1.item.primaryVideoAssetId,
		logoImageAssetId = t1.item.logoAssetId,
		logoAspectRatio = t1.item.logoAspectRatio,
		headline = t1.item.headline,
		subtitle = t1.item.subtitle,
		videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t1.videoPlaybackContext
	})
end)

return function(t2: {[any]: any}) -- line: 61
	-- upvalues: React (copy), v9 (copy), GameCollectionItemTypes (copy)
	return React.createElement(v9, t2), GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile
end

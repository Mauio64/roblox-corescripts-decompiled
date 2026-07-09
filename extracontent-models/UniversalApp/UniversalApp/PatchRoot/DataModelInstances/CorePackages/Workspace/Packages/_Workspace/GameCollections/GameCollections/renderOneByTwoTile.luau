local Parent = script:FindFirstAncestor("GameCollections").Parent
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local React = require(Parent.React)
local GameTile = require(Parent.GameTile)
local OneByTwoTile = GameTile.OneByTwoTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local v7 = React.memo(function(t1: {[any]: any}) -- line: 24
	-- upvalues: getTileBadgeByPositionConfigFromEntry (copy), React (copy), OneByTwoTile (copy)
	local v9 = getTileBadgeByPositionConfigFromEntry(t1.item)
	local v10 = -((t1.maxItemIndex or 0) + 1)
	local v11 = if not t1.zIndex then v10 else t1.zIndex + v10

	return React.createElement(OneByTwoTile, {
		size = t1.item.sizeOverride,
		layoutOrder = t1.index,
		zIndex = v11,
		contentType = t1.item.contentType,
		universeId = t1.item.universeId,
		placeId = t1.item.placeId,
		placeIdOverride = t1.item.placeIdOverride,
		launchDataOverride = t1.item.launchDataOverride,
		referralSource = t1.appPage,
		reportExperienceLaunched = t1.reportExperienceLaunched,
		topicId = t1.topicId,
		badgeOverride = v9,
		primaryImageAssetId = t1.item.primaryImageAssetId,
		logoImageAssetId = t1.item.logoAssetId,
		logoAspectRatio = t1.item.logoAspectRatio,
		headline = t1.item.headline,
		subtitle = t1.item.subtitle
	})
end)

return function(t2: {[any]: any}) -- line: 52
	-- upvalues: React (copy), v7 (copy), GameCollectionItemTypes (copy)
	return React.createElement(v7, t2), GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile
end

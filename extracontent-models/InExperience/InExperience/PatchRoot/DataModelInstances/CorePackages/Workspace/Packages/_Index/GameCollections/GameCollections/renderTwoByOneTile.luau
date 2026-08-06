local Parent = script:FindFirstAncestor("GameCollections").Parent
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local React = require(Parent.React)
local GameTile = require(Parent.GameTile)
local TwoByOneGameTile = GameTile.TwoByOneGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry

require(Parent.VideoUtils)

local v7 = React.memo(function(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), getTileBadgeByPositionConfigFromEntry (copy), TwoByOneGameTile (copy)
	local v9 = -((t1.maxItemIndex or 0) + 1)
	local v10 = if not t1.zIndex then v9 else t1.zIndex + v9
	local v11 = React.useCallback(function() -- line: 44
		-- upvalues: t1 (copy)
		if t1.onSelectionGained then
			t1.onSelectionGained(t1.item, t1.index, t1.item.universeId)
		end
	end, {
		t1.onSelectionGained,
		t1.item,
		t1.index
	})
	local v12 = getTileBadgeByPositionConfigFromEntry(t1.item)

	return React.createElement(TwoByOneGameTile, {
		size = t1.item.sizeOverride,
		layoutOrder = t1.index,
		zIndex = v10,
		universeId = t1.item.universeId,
		placeId = t1.item.placeId,
		topicId = t1.topicId,
		logoImageAssetId = t1.item.logoAssetId,
		logoAspectRatio = t1.item.logoAspectRatio,
		headline = t1.item.headline,
		subtitle = t1.item.subtitle,
		ctaText = t1.item.ctaText,
		tileVariant = t1.item.tileVariant,
		badgeOverride = v12,
		payerName = t1.item.payerName,
		adId = t1.item.adId,
		isSponsored = t1.item.isSponsored,
		sponsoredUserCohort = t1.sponsoredUserCohort,
		appPage = t1.appPage,
		setGameHidden = t1.setGameHidden,
		isHidden = t1.isHidden,
		hoverKey = `TwoByOneTile_{ t1.impressionsTag or "" }_{ t1.index or "0" }_{ t1.item.universeId }`,
		impressionsTag = t1.impressionsTag,
		index = t1.index,
		reportGameDetailOpened = t1.reportGameDetailOpened,
		reportExperienceLaunched = t1.reportExperienceLaunched,
		enableSponsoredFeedback = t1.enableSponsoredFeedback,
		enableReportAd = t1.enableReportAd,
		enableExplicitFeedback = t1.enableExplicitFeedback,
		placeIdOverride = t1.item.placeIdOverride,
		launchDataOverride = t1.item.launchDataOverride,
		onSelectionGained = v11,
		onSelectionLost = t1.onSelectionLost,
		primaryWideImageAssetId = t1.item.primaryWideImageAssetId,
		videoPlaybackContext = t1.videoPlaybackContext,
		SelectionOrder = t1.SelectionOrder
	})
end)

return function(t2: {[any]: any}) -- line: 93
	-- upvalues: React (copy), v7 (copy), GameCollectionItemTypes (copy)
	return React.createElement(v7, t2), GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
end

local Parent = script:FindFirstAncestor("GameCollections").Parent
local SharedFlags = require(Parent.SharedFlags)
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local React = require(Parent.React)
local GameTile = require(Parent.GameTile)
local TwoByOneGameTile = GameTile.TwoByOneGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry

require(Parent.VideoUtils)

local FFlagLuaAppSupportSponsoredExplicitFeedback = SharedFlags.FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppFixCustomTileBugs = SharedFlags.FFlagLuaAppFixCustomTileBugs
local v10 = React.memo(function(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), getTileBadgeByPositionConfigFromEntry (copy), TwoByOneGameTile (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), FFlagLuaAppFixCustomTileBugs (copy)
	local v12 = -((t1.maxItemIndex or 0) + 1)
	local v13 = if not t1.zIndex then v12 else t1.zIndex + v12
	local v14 = React.useCallback(function() -- line: 47
		-- upvalues: t1 (copy)
		if t1.onSelectionGained then
			t1.onSelectionGained(t1.item, t1.index, t1.item.universeId)
		end
	end, {
		t1.onSelectionGained,
		t1.item,
		t1.index
	})
	local v15 = getTileBadgeByPositionConfigFromEntry(t1.item)

	return React.createElement(TwoByOneGameTile, {
		size = t1.item.sizeOverride,
		layoutOrder = t1.index,
		zIndex = v13,
		universeId = t1.item.universeId,
		placeId = t1.item.placeId,
		topicId = t1.topicId,
		logoImageAssetId = t1.item.logoAssetId,
		logoAspectRatio = t1.item.logoAspectRatio,
		headline = t1.item.headline,
		subtitle = t1.item.subtitle,
		ctaText = t1.item.ctaText,
		tileVariant = t1.item.tileVariant,
		badgeOverride = v15,
		payerName = t1.item.payerName,
		adId = t1.item.adId,
		isSponsored = t1.item.isSponsored,
		sponsoredUserCohort = t1.sponsoredUserCohort,
		appPage = t1.appPage,
		setGameHidden = t1.setGameHidden,
		isHidden = if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isHidden,
		hoverKey = `TwoByOneTile_{ t1.impressionsTag or "" }_{ t1.index or "0" }_{ t1.item.universeId }`,
		impressionsTag = t1.impressionsTag,
		index = t1.index,
		reportGameDetailOpened = t1.reportGameDetailOpened,
		reportExperienceLaunched = t1.reportExperienceLaunched,
		enableSponsoredFeedback = if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.enableSponsoredFeedback,
		enableReportAd = if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.enableReportAd,
		enableExplicitFeedback = if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.enableExplicitFeedback,
		placeIdOverride = t1.item.placeIdOverride,
		launchDataOverride = t1.item.launchDataOverride,
		onSelectionGained = v14,
		onSelectionLost = t1.onSelectionLost,
		primaryWideImageAssetId = t1.item.primaryWideImageAssetId,
		videoPlaybackContext = t1.videoPlaybackContext,
		SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t1.SelectionOrder
	})
end)

return function(t2: {[any]: any}) -- line: 100
	-- upvalues: React (copy), v10 (copy), GameCollectionItemTypes (copy)
	return React.createElement(v10, t2), GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
end

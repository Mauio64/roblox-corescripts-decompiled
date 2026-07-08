local Parent = script:FindFirstAncestor("GameCollections").Parent
local SharedFlags = require(Parent.SharedFlags)
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local React = require(Parent.React)
local GameTile = require(Parent.GameTile)
local TwoByOneGameTile = GameTile.TwoByOneGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry

require(Parent.VideoUtils)

local FFlagLuaAppGameTileLockedBadge = SharedFlags.FFlagLuaAppGameTileLockedBadge
local FFlagLuaAppSupportSponsoredExplicitFeedback = SharedFlags.FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppHomeTouchAutoplay = SharedFlags.FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppFixCustomTileBugs = SharedFlags.FFlagLuaAppFixCustomTileBugs
local v12 = React.memo(function(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), FFlagLuaAppGameTileLockedBadge (copy), getTileBadgeByPositionConfigFromEntry (copy), TwoByOneGameTile (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), FFlagLuaAppHomeTouchAutoplay (copy), FFlagLuaAppFixCustomTileBugs (copy)
	local v14 = -((t1.maxItemIndex or 0) + 1)
	local v15 = if not t1.zIndex then v14 else t1.zIndex + v14
	local v16 = React.useCallback(function() -- line: 50
		-- upvalues: t1 (copy)
		if t1.onSelectionGained then
			t1.onSelectionGained(t1.item, t1.index, t1.item.universeId)
		end
	end, {
		t1.onSelectionGained,
		t1.item,
		t1.index
	})
	local v17 = nil

	if FFlagLuaAppGameTileLockedBadge then
		v17 = getTileBadgeByPositionConfigFromEntry(t1.item)
	elseif t1.item.badgePosition and t1.item.badgeAnalyticsId and t1.item.badgeType and (t1.item.badgeText or t1.item.badgeIcon) then
		v17 = {
			[t1.item.badgePosition] = {{
				analyticsId = t1.item.badgeAnalyticsId,
				tileBadgeType = t1.item.badgeType,
				text = t1.item.badgeText,
				icons = if not t1.item.badgeIcon then nil else { t1.item.badgeIcon },
				tileBadgeComponentType = t1.item.badgeComponentType
			}}
		}
	end

	return React.createElement(TwoByOneGameTile, {
		size = t1.item.sizeOverride,
		layoutOrder = t1.index,
		zIndex = v15,
		universeId = t1.item.universeId,
		placeId = t1.item.placeId,
		topicId = t1.topicId,
		logoImageAssetId = t1.item.logoAssetId,
		logoAspectRatio = t1.item.logoAspectRatio,
		headline = t1.item.headline,
		subtitle = t1.item.subtitle,
		ctaText = t1.item.ctaText,
		tileVariant = t1.item.tileVariant,
		badgeOverride = v17,
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
		onSelectionGained = v16,
		onSelectionLost = t1.onSelectionLost,
		primaryWideImageAssetId = t1.item.primaryWideImageAssetId,
		videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t1.videoPlaybackContext,
		SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t1.SelectionOrder
	})
end)

return function(t2: {[any]: any}) -- line: 125
	-- upvalues: React (copy), v12 (copy), GameCollectionItemTypes (copy)
	return React.createElement(v12, t2), GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
end

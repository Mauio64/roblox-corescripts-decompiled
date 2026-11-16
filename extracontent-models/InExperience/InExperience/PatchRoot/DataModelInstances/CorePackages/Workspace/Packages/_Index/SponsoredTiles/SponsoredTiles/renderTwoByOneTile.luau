local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")
local parent = SponsoredTiles.Parent

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local React = require(parent.React)
local GameTile = require(parent.GameTile)
local TwoByOneGameTile = require(SponsoredTiles.TwoByOneGameTile)
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local resolveWideAssetId = GameTile.resolveWideAssetId
require(parent.VideoUtils)
local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEnableReportExperience = SharedFlags2.FFlagLuaAppEnableReportExperience

local memo = React.memo(function(props)
	local zIndex = -((props.maxItemIndex or 0) + 1)

	if props.zIndex then
		zIndex = props.zIndex + zIndex
	end

	local onSelectionGained = React.useCallback(function()
		if props.onSelectionGained then
			props.onSelectionGained(props.item, props.index, props.item.universeId)
		end
	end, { props.onSelectionGained, props.item, props.index })

	local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(props.item)

	local createElement = React.createElement
	local v = {}
	v.size = props.item.sizeOverride
	v.layoutOrder = props.index
	v.zIndex = zIndex
	v.universeId = props.item.universeId
	v.placeId = props.item.placeId
	v.topicId = props.topicId
	v.logoImageAssetId = props.item.logoAssetId
	v.logoAspectRatio = props.item.logoAspectRatio
	v.headline = props.item.headline
	v.subtitle = props.item.subtitle
	v.ctaText = props.item.ctaText
	v.tileVariant = props.item.tileVariant
	v.badgeOverride = tileBadgeByPositionConfigFromEntry
	v.payerName = props.item.payerName
	v.adId = props.item.adId
	v.isSponsored = props.item.isSponsored
	v.sponsoredUserCohort = props.sponsoredUserCohort
	v.appPage = props.appPage
	v.setGameHidden = props.setGameHidden
	v.isHidden = props.isHidden
	v.hoverKey = `TwoByOneTile_{props.impressionsTag or ""}_{props.index or "0"}_{props.item.universeId}`
	v.impressionsTag = props.impressionsTag
	v.index = props.index
	v.reportGameDetailOpened = props.reportGameDetailOpened
	v.reportExperienceLaunched = props.reportExperienceLaunched
	v.enableSponsoredFeedback = props.enableSponsoredFeedback
	v.enableReportAd = props.enableReportAd
	local enableReportExperience

	if FFlagLuaAppEnableReportExperience then
		enableReportExperience = props.enableReportExperience
	end

	v.enableReportExperience = enableReportExperience
	v.enableExplicitFeedback = props.enableExplicitFeedback
	v.placeIdOverride = props.item.placeIdOverride
	v.launchDataOverride = props.item.launchDataOverride
	v.onSelectionGained = onSelectionGained
	v.onSelectionLost = props.onSelectionLost
	local primaryWideImageAssetId

	if not FFlagMigrateGameInfoToStore then
		primaryWideImageAssetId = props.item.primaryWideImageAssetId
	end

	v.primaryWideImageAssetId = primaryWideImageAssetId
	local wideAssetId

	if FFlagMigrateGameInfoToStore then
		wideAssetId = resolveWideAssetId(props.item.primaryWideImageAssetId, props.item, props.topicId)
	end

	v.wideAssetId = wideAssetId
	local ageRatingLabel

	if FFlagMigrateGameInfoToStore then
		ageRatingLabel = props.item.ageRecommendationDisplayName
	end

	v.ageRatingLabel = ageRatingLabel
	v.videoPlaybackContext = props.videoPlaybackContext
	v.SelectionOrder = props.SelectionOrder
	return createElement(TwoByOneGameTile, v)
end)

return function(p)
	return React.createElement(memo, p), GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
end

local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryTypes").GameCollectionItemTypes

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameTile")
local TwoByOneGameTile = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/TwoByOneGameTile")
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local resolveWideAssetId = GameTile.resolveWideAssetId
require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/VideoUtils")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags").FFlagMigrateGameInfoToStore
local fFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags").FFlagLuaAppEnableReportExperience

local memo = React.memo(function(props)
	local v5 = -((props.maxItemIndex or 0) + 1)

	if props.zIndex then
		v5 = props.zIndex + v5
	end

	local v6 = React.useCallback(function()
		if props.onSelectionGained then
			props.onSelectionGained(props.item, props.index, props.item.universeId)
		end
	end, { props.onSelectionGained, props.item, props.index })

	local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(props.item)

	local createElement = React.createElement
	local v8 = {}
	v8.size = props.item.sizeOverride
	v8.layoutOrder = props.index
	v8.zIndex = v5
	v8.universeId = props.item.universeId
	v8.placeId = props.item.placeId
	v8.topicId = props.topicId
	v8.logoImageAssetId = props.item.logoAssetId
	v8.logoAspectRatio = props.item.logoAspectRatio
	v8.headline = props.item.headline
	v8.subtitle = props.item.subtitle
	v8.ctaText = props.item.ctaText
	v8.tileVariant = props.item.tileVariant
	v8.badgeOverride = tileBadgeByPositionConfigFromEntry
	v8.payerName = props.item.payerName
	v8.adId = props.item.adId
	v8.isSponsored = props.item.isSponsored
	v8.sponsoredUserCohort = props.sponsoredUserCohort
	v8.appPage = props.appPage
	v8.setGameHidden = props.setGameHidden
	v8.isHidden = props.isHidden
	v8.hoverKey = `TwoByOneTile_{props.impressionsTag or ""}_{props.index or "0"}_{props.item.universeId}`
	v8.impressionsTag = props.impressionsTag
	v8.index = props.index
	v8.reportGameDetailOpened = props.reportGameDetailOpened
	v8.reportExperienceLaunched = props.reportExperienceLaunched
	v8.enableSponsoredFeedback = props.enableSponsoredFeedback
	v8.enableReportAd = props.enableReportAd
	local v9 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	v8.enableReportExperience = v9
	v8.enableExplicitFeedback = props.enableExplicitFeedback
	v8.placeIdOverride = props.item.placeIdOverride
	v8.launchDataOverride = props.item.launchDataOverride
	v8.onSelectionGained = v6
	v8.onSelectionLost = props.onSelectionLost
	local v10 = if not fFlagMigrateGameInfoToStore then props.item.primaryWideImageAssetId else nil
	v8.primaryWideImageAssetId = v10

	local v11 = if fFlagMigrateGameInfoToStore then resolveWideAssetId(
		props.item.primaryWideImageAssetId,
		props.item,
		props.topicId
	) else nil
	v8.wideAssetId = v11

	local v12 = if fFlagMigrateGameInfoToStore then props.item.ageRecommendationDisplayName else nil
	v8.ageRatingLabel = v12
	v8.videoPlaybackContext = props.videoPlaybackContext
	v8.SelectionOrder = props.SelectionOrder
	return createElement(TwoByOneGameTile, v8)
end)

return function(p2)
	return React.createElement(memo, p2), gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
end

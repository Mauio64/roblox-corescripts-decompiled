local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryTypes").GameCollectionItemTypes
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameTile")
local OneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/OneByTwoTile")
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/VideoUtils")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags")
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local memo = React.memo(function(props)
	local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(props.item)

	local v5 = -((props.maxItemIndex or 0) + 1)

	if props.zIndex then
		v5 = props.zIndex + v5
	end

	local formatted = `OneByTwoTile_{props.impressionsTag or ""}_{props.index or "0"}_{props.item.universeId or props.item.clickoutUrl}`

	local v6 = React.useCallback(function()
		if props.onSelectionGained then
			props.onSelectionGained(props.item, props.index, props.item.universeId)
		end
	end, { props.onSelectionGained, props.item, props.index })

	local createElement = React.createElement
	local v8 = {}
	v8.size = props.item.sizeOverride
	local v9 = if props.item.spanOverride ~= nil then props.item.spanOverride.alignmentType else nil
	v8.alignmentType = v9
	v8.zIndex = v5
	v8.hoverKey = formatted
	v8.contentType = props.item.contentType
	v8.universeId = props.item.universeId
	v8.placeId = props.item.placeId
	v8.placeIdOverride = props.item.placeIdOverride
	v8.launchDataOverride = props.item.launchDataOverride
	v8.referralSource = props.appPage
	v8.reportGameDetailOpened = props.reportGameDetailOpened
	v8.reportExperienceLaunched = props.reportExperienceLaunched
	v8.launchExperienceEventContext = props.launchExperienceEventContext
	v8.topicId = props.topicId
	v8.badgeOverride = tileBadgeByPositionConfigFromEntry
	v8.primaryImageAssetId = props.item.primaryImageAssetId
	v8.primaryVideoAssetId = props.item.primaryVideoAssetId
	v8.attributionThumbnailAssetId = props.item.attributionThumbnailAssetId
	v8.logoImageAssetId = props.item.logoAssetId
	v8.logoAspectRatio = props.item.logoAspectRatio
	v8.headline = props.item.headline
	v8.subtitle = props.item.subtitle
	v8.ctaText = props.item.ctaText or ""
	v8.adId = props.item.adId
	v8.impressionsTag = props.impressionsTag
	v8.index = props.index
	v8.clickoutUrl = props.item.clickoutUrl
	v8.videoPlaybackContext = props.videoPlaybackContext
	v8.videoAnalytics = props.videoAnalytics
	v8.pageContext = props.appPage
	v8.payerName = props.item.payerName
	v8.appPage = props.appPage
	v8.sponsoredUserCohort = props.sponsoredUserCohort
	v8.setGameHidden = props.setGameHidden
	v8.enableSponsoredFeedback = props.enableSponsoredFeedback
	v8.enableReportAd = props.enableReportAd
	local v10 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	v8.enableReportExperience = v10
	v8.enableExplicitFeedback = props.enableExplicitFeedback
	v8.onSelectionGained = v6
	v8.onSelectionLost = props.onSelectionLost
	v8.SelectionOrder = props.SelectionOrder

	local v11 = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then props.item.oneByTwoTileFlowId else nil
	v8.oneByTwoTileFlowId = v11

	local v12 = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then props.item.recommendationsRequestId else nil
	v8.recommendationsRequestId = v12

	v8.isSdui = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then false else nil
	return createElement(OneByTwoTile, v8)
end)

return function(p2)
	return React.createElement(memo, p2), gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile
end

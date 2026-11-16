local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")
local parent = SponsoredTiles.Parent

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local React = require(parent.React)
local GameTile = require(parent.GameTile)
local OneByTwoTile = require(SponsoredTiles.OneByTwoTile)
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
require(parent.VideoUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local memo = React.memo(function(props)
	local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(props.item)

	local zIndex = -((props.maxItemIndex or 0) + 1)

	if props.zIndex then
		zIndex = props.zIndex + zIndex
	end

	local formatted = `OneByTwoTile_{props.impressionsTag or ""}_{props.index or "0"}_{props.item.universeId or props.item.clickoutUrl}`

	local onSelectionGained = React.useCallback(function()
		if props.onSelectionGained then
			props.onSelectionGained(props.item, props.index, props.item.universeId)
		end
	end, { props.onSelectionGained, props.item, props.index })

	local createElement = React.createElement
	local v = {}
	v.size = props.item.sizeOverride
	local alignmentType

	if props.item.spanOverride ~= nil then
		alignmentType = props.item.spanOverride.alignmentType
	end

	v.alignmentType = alignmentType
	v.zIndex = zIndex
	v.hoverKey = formatted
	v.contentType = props.item.contentType
	v.universeId = props.item.universeId
	v.placeId = props.item.placeId
	v.placeIdOverride = props.item.placeIdOverride
	v.launchDataOverride = props.item.launchDataOverride
	v.referralSource = props.appPage
	v.reportGameDetailOpened = props.reportGameDetailOpened
	v.reportExperienceLaunched = props.reportExperienceLaunched
	v.launchExperienceEventContext = props.launchExperienceEventContext
	v.topicId = props.topicId
	v.badgeOverride = tileBadgeByPositionConfigFromEntry
	v.primaryImageAssetId = props.item.primaryImageAssetId
	v.primaryVideoAssetId = props.item.primaryVideoAssetId
	v.attributionThumbnailAssetId = props.item.attributionThumbnailAssetId
	v.logoImageAssetId = props.item.logoAssetId
	v.logoAspectRatio = props.item.logoAspectRatio
	v.headline = props.item.headline
	v.subtitle = props.item.subtitle
	v.ctaText = props.item.ctaText or ""
	v.adId = props.item.adId
	v.impressionsTag = props.impressionsTag
	v.index = props.index
	v.clickoutUrl = props.item.clickoutUrl
	v.videoPlaybackContext = props.videoPlaybackContext
	v.videoAnalytics = props.videoAnalytics
	v.pageContext = props.appPage
	v.payerName = props.item.payerName
	v.appPage = props.appPage
	v.sponsoredUserCohort = props.sponsoredUserCohort
	v.setGameHidden = props.setGameHidden
	v.enableSponsoredFeedback = props.enableSponsoredFeedback
	v.enableReportAd = props.enableReportAd
	local enableReportExperience

	if FFlagLuaAppEnableReportExperience then
		enableReportExperience = props.enableReportExperience
	end

	v.enableReportExperience = enableReportExperience
	v.enableExplicitFeedback = props.enableExplicitFeedback
	v.onSelectionGained = onSelectionGained
	v.onSelectionLost = props.onSelectionLost
	v.SelectionOrder = props.SelectionOrder
	local oneByTwoTileFlowId

	if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		oneByTwoTileFlowId = props.item.oneByTwoTileFlowId
	end

	v.oneByTwoTileFlowId = oneByTwoTileFlowId
	local recommendationsRequestId

	if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		recommendationsRequestId = props.item.recommendationsRequestId
	end

	v.recommendationsRequestId = recommendationsRequestId

	v.isSdui = not FFlagLuaAppEnableOneByTwoTileFunnelTelemetry and nil
	return createElement(OneByTwoTile, v)
end)

return function(p)
	return React.createElement(memo, p), GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile
end

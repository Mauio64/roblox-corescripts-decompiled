local HttpService = game:GetService("HttpService")

local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/DiscoveryTypes")
local parseBooleanString = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/DiscoveryUtils").parseBooleanString
local omniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/Result")

local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/SharedFlags").FFlagEnableTopSongsSort
local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/SharedFlags").FFlagLuaAppEnableOneByTwoTileFunnelTelemetry
local fFlagLuaAppSponsoredGamePreviewVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/SharedFlags").FFlagLuaAppSponsoredGamePreviewVideo

local v5 = fFlagLuaAppEnableOneByTwoTileFunnelTelemetry and {} or nil

local v6 = {}

function v6.new()
	return {}
end

function v6.mock(value)
	local v7 = {}
	v7.contentType = omniRecommendationsContentType.Game
	v7.contentId = value or "149757"
	v7.isSponsored = false
	v7.isShowSponsoredLabel = v7.isSponsored
	v7.adId = nil
	v7.payerName = nil
	v7.logoAssetId = nil
	v7.logoAspectRatio = nil
	v7.headline = nil
	v7.subtitle = nil
	v7.ctaText = nil
	v7.tileVariant = nil
	v7.badgePosition = nil
	v7.badgeAnalyticsId = nil
	v7.badgeType = nil
	v7.badgeText = nil
	v7.badgeIcon = nil
	v7.badgeComponentType = nil
	v7.componentType = nil
	v7.alignmentType = nil
	v7.minRowPadding = nil
	v7.placeIdOverride = nil
	v7.launchDataOverride = nil
	v7.analyticsData = nil
	v7.primaryWideImageAssetId = nil
	v7.primaryWideImageListId = nil
	v7.primaryWideVideoAssetId = nil
	v7.sponsoredGamePreviewVideoEligible = nil
	v7.primaryImageAssetId = nil
	v7.primaryVideoAssetId = nil
	v7.attributionThumbnailAssetId = nil
	v7.clickoutUrl = nil

	if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		v7.oneByTwoTileFlowId = nil
		v7.recommendationsRequestId = nil
	end

	return v7
end

function v6.fromGamesApiData(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromGamesApiData expects universeId to be a number or a string")
	end

	local v7 = v6.new()
	v7.contentType = omniRecommendationsContentType.Game
	v7.contentId = tostring(data.universeId)
	v7.isSponsored = data.isSponsored
	v7.isShowSponsoredLabel = nil

	if data.isShowSponsoredLabel == nil then
		v7.isShowSponsoredLabel = true
	else
		v7.isShowSponsoredLabel = data.isShowSponsoredLabel
	end

	v7.adId = data.nativeAdData

	if data.contentMetadata then
		local contentMetadata = data.contentMetadata
		v7.badgePosition = contentMetadata.badgePosition
		v7.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v7.badgeType = contentMetadata.badgeType
		v7.badgeText = contentMetadata.badgeText
		v7.badgeIcon = contentMetadata.badgeIcon
		v7.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v7)
end

function v6.fromOmniAutocompleteApi(p2)
	if type(p2.universeId) ~= "number" and type(p2.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromOmniAutocomplete expects universeId to be a number or a string")
	end

	local v7 = v6.new()
	v7.contentType = omniRecommendationsContentType.Game
	v7.contentId = tostring(p2.universeId)

	if p2.contentMetadata then
		local contentMetadata = p2.contentMetadata
		v7.badgePosition = contentMetadata.badgePosition
		v7.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v7.badgeType = contentMetadata.badgeType
		v7.badgeText = contentMetadata.badgeText
		v7.badgeIcon = contentMetadata.badgeIcon
		v7.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v7)
end

function v6.fromExploreApiData(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromExploreApiData expects universeId to be a number or a string")
	end

	local v7 = v6.new()
	v7.contentType = omniRecommendationsContentType.Game
	v7.contentId = tostring(data.universeId)
	v7.isSponsored = data.isSponsored
	v7.adId = data.nativeAdData
	v7.isShowSponsoredLabel = nil

	if data.contentMetadata then
		local contentMetadata = data.contentMetadata
		v7.badgePosition = contentMetadata.badgePosition
		v7.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v7.badgeType = contentMetadata.badgeType
		v7.badgeText = contentMetadata.badgeText
		v7.badgeIcon = contentMetadata.badgeIcon
		v7.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v7)
end

if fFlagEnableTopSongsSort then
	function v6.songFromExploreApiData(p2)
		if type(p2.assetId) ~= "number" and type(p2.assetId) ~= "string" then
			return Result.error("TopicContentsEntryModel.songFromExploreApiData expects assetId to be a number or a string")
		end

		local v7 = v6.new()
		v7.contentType = omniRecommendationsContentType.Song
		v7.contentId = tostring(p2.assetId)
		v7.isSponsored = false
		return Result.success(v7)
	end
end

function v6.fromOmniRecommendations(data, recommendationsRequestId)
	local v7 = v6.new()
	v7.contentType = data.contentType
	v7.contentId = tostring(data.contentId)

	if data.contentMetadata then
		v7.adId = data.contentMetadata.EncryptedAdTrackingData or nil
		v7.isSponsored = v7.adId ~= nil and v7.adId ~= ""
		v7.isShowSponsoredLabel = nil
		v7.payerName = data.contentMetadata.PayerName or nil

		v7.logoAssetId = data.contentMetadata.LogoAssetId
		v7.logoAspectRatio = data.contentMetadata.LogoAspectRatio
		v7.headline = data.contentMetadata.Headline
		v7.subtitle = data.contentMetadata.Subtitle
		v7.ctaText = data.contentMetadata.CtaText
		v7.tileVariant = data.contentMetadata.TileVariant
		v7.badgePosition = data.contentMetadata.badgePosition
		v7.badgeAnalyticsId = data.contentMetadata.badgeAnalyticsId
		v7.badgeType = data.contentMetadata.badgeType
		v7.badgeText = data.contentMetadata.badgeText
		v7.badgeIcon = data.contentMetadata.badgeIcon
		v7.badgeComponentType = data.contentMetadata.badgeComponentType
		v7.componentType = data.contentMetadata.ComponentType
		v7.alignmentType = data.contentMetadata.AlignmentType
		v7.minRowPadding = data.contentMetadata.MinRowPadding
		local v9 = if data.contentMetadata.PlaceIdOverride then tostring(data.contentMetadata.PlaceIdOverride) else nil
		v7.placeIdOverride = v9

		v7.launchDataOverride = data.contentMetadata.LaunchDataOverride
		local v10 = if data.contentMetadata.PrimaryWideImageAssetId and data.contentMetadata.PrimaryWideImageAssetId ~= "" then data.contentMetadata.PrimaryWideImageAssetId else nil
		v7.primaryWideImageAssetId = v10

		v7.primaryWideImageListId = data.contentMetadata.PrimaryWideImageListId
		v7.primaryWideVideoAssetId = data.contentMetadata.PrimaryWideVideoAssetId

		if fFlagLuaAppSponsoredGamePreviewVideo then
			local sponsoredGamePreviewVideoEligible = data.contentMetadata.SponsoredGamePreviewVideoEligible

			local v11 = if sponsoredGamePreviewVideoEligible then parseBooleanString(sponsoredGamePreviewVideoEligible) == true else false
			v7.sponsoredGamePreviewVideoEligible = v11
		end

		local v11 = if fFlagLuaAppEnableNxMRoduxApportioning then data.contentMetadata.PrimaryImageAssetId else nil
		v7.primaryImageAssetId = v11

		local v12 = if fFlagLuaAppEnableNxMRoduxApportioning then data.contentMetadata.PrimaryVideoAssetId else nil
		v7.primaryVideoAssetId = v12

		local v13 = if fFlagLuaAppEnableNxMRoduxApportioning then data.contentMetadata.AttributionThumbnailAssetId else nil
		v7.attributionThumbnailAssetId = v13

		local v14 = if fFlagLuaAppEnableNxMRoduxApportioning then data.contentMetadata.ClickoutUrl else nil
		v7.clickoutUrl = v14
	else
		v7.adId = nil
		v7.isSponsored = false
		v7.isShowSponsoredLabel = nil
		v7.payerName = nil
		v7.placeIdOverride = nil
		v7.launchDataOverride = nil
	end

	v7.analyticsData = data.analyticsData

	if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		local contentMetadata = data.contentMetadata

		if contentMetadata and contentMetadata.ComponentType == "OneByTwoTile" then
			local v8 = string.format(
				"%s:%s:%s",
				recommendationsRequestId or "",
				tostring(data.contentId),
				contentMetadata.EncryptedAdTrackingData or ""
			)

			local v9 = v5[v8]

			if v9 == nil then
				v9 = HttpService:GenerateGUID(false):lower()
				v5[v8] = v9
			end

			v7.oneByTwoTileFlowId = v9
			v7.recommendationsRequestId = recommendationsRequestId
		end
	end

	return Result.success(v7)
end

return v6

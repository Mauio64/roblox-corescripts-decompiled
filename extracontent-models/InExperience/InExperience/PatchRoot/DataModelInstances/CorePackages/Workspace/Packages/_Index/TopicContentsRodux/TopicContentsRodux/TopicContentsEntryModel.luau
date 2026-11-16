local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("TopicContentsRodux").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local parseBooleanString = DiscoveryUtils.parseBooleanString
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local Result = require(parent.Result)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags2.FFlagLuaAppEnableHomepageOneByTwoTile

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags3.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSponsoredGamePreviewVideo = SharedFlags4.FFlagLuaAppSponsoredGamePreviewVideo

local v = FFlagLuaAppEnableOneByTwoTileFunnelTelemetry and {} or nil

local TopicContentsEntryModel = {}

function TopicContentsEntryModel.new()
	return {}
end

function TopicContentsEntryModel.mock(value: string?)
	local v2 = {}
	v2.contentType = OmniRecommendationsContentType.Game
	v2.contentId = value or "149757"
	v2.isSponsored = false
	v2.isShowSponsoredLabel = v2.isSponsored
	v2.adId = nil
	v2.payerName = nil
	v2.logoAssetId = nil
	v2.logoAspectRatio = nil
	v2.headline = nil
	v2.subtitle = nil
	v2.ctaText = nil
	v2.tileVariant = nil
	v2.badgePosition = nil
	v2.badgeAnalyticsId = nil
	v2.badgeType = nil
	v2.badgeText = nil
	v2.badgeIcon = nil
	v2.badgeComponentType = nil
	v2.componentType = nil
	v2.alignmentType = nil
	v2.minRowPadding = nil
	v2.placeIdOverride = nil
	v2.launchDataOverride = nil
	v2.analyticsData = nil
	v2.primaryWideImageAssetId = nil
	v2.primaryWideImageListId = nil
	v2.primaryWideVideoAssetId = nil
	v2.sponsoredGamePreviewVideoEligible = nil
	v2.primaryImageAssetId = nil
	v2.primaryVideoAssetId = nil
	v2.attributionThumbnailAssetId = nil
	v2.clickoutUrl = nil

	if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		v2.oneByTwoTileFlowId = nil
		v2.recommendationsRequestId = nil
	end

	return v2
end

function TopicContentsEntryModel.fromGamesApiData(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromGamesApiData expects universeId to be a number or a string")
	end

	local v2 = TopicContentsEntryModel.new()
	v2.contentType = OmniRecommendationsContentType.Game
	v2.contentId = tostring(data.universeId)
	v2.isSponsored = data.isSponsored
	v2.isShowSponsoredLabel = nil

	if data.isShowSponsoredLabel == nil then
		v2.isShowSponsoredLabel = true
	else
		v2.isShowSponsoredLabel = data.isShowSponsoredLabel
	end

	v2.adId = data.nativeAdData

	if data.contentMetadata then
		local contentMetadata = data.contentMetadata
		v2.badgePosition = contentMetadata.badgePosition
		v2.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v2.badgeType = contentMetadata.badgeType
		v2.badgeText = contentMetadata.badgeText
		v2.badgeIcon = contentMetadata.badgeIcon
		v2.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v2)
end

function TopicContentsEntryModel.fromOmniAutocompleteApi(p)
	if type(p.universeId) ~= "number" and type(p.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromOmniAutocomplete expects universeId to be a number or a string")
	end

	local v2 = TopicContentsEntryModel.new()
	v2.contentType = OmniRecommendationsContentType.Game
	v2.contentId = tostring(p.universeId)

	if p.contentMetadata then
		local contentMetadata = p.contentMetadata
		v2.badgePosition = contentMetadata.badgePosition
		v2.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v2.badgeType = contentMetadata.badgeType
		v2.badgeText = contentMetadata.badgeText
		v2.badgeIcon = contentMetadata.badgeIcon
		v2.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v2)
end

function TopicContentsEntryModel.fromExploreApiData(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromExploreApiData expects universeId to be a number or a string")
	end

	local v2 = TopicContentsEntryModel.new()
	v2.contentType = OmniRecommendationsContentType.Game
	v2.contentId = tostring(data.universeId)
	v2.isSponsored = data.isSponsored
	v2.adId = data.nativeAdData
	v2.isShowSponsoredLabel = nil

	if data.contentMetadata then
		local contentMetadata = data.contentMetadata
		v2.badgePosition = contentMetadata.badgePosition
		v2.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v2.badgeType = contentMetadata.badgeType
		v2.badgeText = contentMetadata.badgeText
		v2.badgeIcon = contentMetadata.badgeIcon
		v2.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v2)
end

if FFlagEnableTopSongsSort then
	function TopicContentsEntryModel.songFromExploreApiData(p)
		if type(p.assetId) ~= "number" and type(p.assetId) ~= "string" then
			return Result.error("TopicContentsEntryModel.songFromExploreApiData expects assetId to be a number or a string")
		end

		local v2 = TopicContentsEntryModel.new()
		v2.contentType = OmniRecommendationsContentType.Song
		v2.contentId = tostring(p.assetId)
		v2.isSponsored = false
		return Result.success(v2)
	end
end

function TopicContentsEntryModel.fromOmniRecommendations(data, recommendationsRequestId: string?)
	local v2 = TopicContentsEntryModel.new()
	v2.contentType = data.contentType
	v2.contentId = tostring(data.contentId)

	if data.contentMetadata then
		v2.adId = data.contentMetadata.EncryptedAdTrackingData or nil
		v2.isSponsored = v2.adId ~= nil and v2.adId ~= ""
		v2.isShowSponsoredLabel = nil
		v2.payerName = data.contentMetadata.PayerName or nil

		v2.logoAssetId = data.contentMetadata.LogoAssetId
		v2.logoAspectRatio = data.contentMetadata.LogoAspectRatio
		v2.headline = data.contentMetadata.Headline
		v2.subtitle = data.contentMetadata.Subtitle
		v2.ctaText = data.contentMetadata.CtaText
		v2.tileVariant = data.contentMetadata.TileVariant
		v2.badgePosition = data.contentMetadata.badgePosition
		v2.badgeAnalyticsId = data.contentMetadata.badgeAnalyticsId
		v2.badgeType = data.contentMetadata.badgeType
		v2.badgeText = data.contentMetadata.badgeText
		v2.badgeIcon = data.contentMetadata.badgeIcon
		v2.badgeComponentType = data.contentMetadata.badgeComponentType
		v2.componentType = data.contentMetadata.ComponentType
		v2.alignmentType = data.contentMetadata.AlignmentType
		v2.minRowPadding = data.contentMetadata.MinRowPadding
		local placeIdOverride

		if data.contentMetadata.PlaceIdOverride then
			placeIdOverride = tostring(data.contentMetadata.PlaceIdOverride)
		end

		v2.placeIdOverride = placeIdOverride

		v2.launchDataOverride = data.contentMetadata.LaunchDataOverride
		local primaryWideImageAssetId

		if data.contentMetadata.PrimaryWideImageAssetId and data.contentMetadata.PrimaryWideImageAssetId ~= "" then
			primaryWideImageAssetId = data.contentMetadata.PrimaryWideImageAssetId
		end

		v2.primaryWideImageAssetId = primaryWideImageAssetId

		v2.primaryWideImageListId = data.contentMetadata.PrimaryWideImageListId
		v2.primaryWideVideoAssetId = data.contentMetadata.PrimaryWideVideoAssetId

		if FFlagLuaAppSponsoredGamePreviewVideo then
			local sponsoredGamePreviewVideoEligible = data.contentMetadata.SponsoredGamePreviewVideoEligible
			local sponsoredGamePreviewVideoEligible2

			if sponsoredGamePreviewVideoEligible then
				sponsoredGamePreviewVideoEligible2 = parseBooleanString(sponsoredGamePreviewVideoEligible) == true
			else
				sponsoredGamePreviewVideoEligible2 = false
			end

			v2.sponsoredGamePreviewVideoEligible = sponsoredGamePreviewVideoEligible2
		end

		local primaryImageAssetId

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			primaryImageAssetId = data.contentMetadata.PrimaryImageAssetId
		end

		v2.primaryImageAssetId = primaryImageAssetId
		local primaryVideoAssetId

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			primaryVideoAssetId = data.contentMetadata.PrimaryVideoAssetId
		end

		v2.primaryVideoAssetId = primaryVideoAssetId
		local attributionThumbnailAssetId

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			attributionThumbnailAssetId = data.contentMetadata.AttributionThumbnailAssetId
		end

		v2.attributionThumbnailAssetId = attributionThumbnailAssetId
		local clickoutUrl

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			clickoutUrl = data.contentMetadata.ClickoutUrl
		end

		v2.clickoutUrl = clickoutUrl
	else
		v2.adId = nil
		v2.isSponsored = false
		v2.isShowSponsoredLabel = nil
		v2.payerName = nil
		v2.placeIdOverride = nil
		v2.launchDataOverride = nil
	end

	v2.analyticsData = data.analyticsData

	if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		local contentMetadata = data.contentMetadata

		if contentMetadata and contentMetadata.ComponentType == "OneByTwoTile" then
			local v3 = string.format(
				"%s:%s:%s",
				recommendationsRequestId or "",
				tostring(data.contentId),
				contentMetadata.EncryptedAdTrackingData or ""
			)

			local oneByTwoTileFlowId = v[v3]

			if oneByTwoTileFlowId == nil then
				oneByTwoTileFlowId = HttpService:GenerateGUID(false):lower()
				v[v3] = oneByTwoTileFlowId
			end

			v2.oneByTwoTileFlowId = oneByTwoTileFlowId
			v2.recommendationsRequestId = recommendationsRequestId
		end
	end

	return Result.success(v2)
end

return TopicContentsEntryModel

local Parent = script:FindFirstAncestor("TopicContentsRodux").Parent
local OmniRecommendationsContentType = require(Parent.DiscoveryTypes).OmniRecommendationsContentType
local Result = require(Parent.Result)
local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppEnableHomepageOneByTwoTile = require(Parent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local t2 = {
	new = function() -- line: 15
		return {}
	end,
	mock = function(s1: string?) -- line: 21
		-- upvalues: OmniRecommendationsContentType (copy)
		local t1 = {
			contentType = OmniRecommendationsContentType.Game,
			contentId = s1 or "149757",
			isSponsored = false
		}

		t1.isShowSponsoredLabel = t1.isSponsored
		t1.adId = nil
		t1.payerName = nil
		t1.logoAssetId = nil
		t1.logoAspectRatio = nil
		t1.headline = nil
		t1.subtitle = nil
		t1.ctaText = nil
		t1.tileVariant = nil
		t1.badgePosition = nil
		t1.badgeAnalyticsId = nil
		t1.badgeType = nil
		t1.badgeText = nil
		t1.badgeIcon = nil
		t1.badgeComponentType = nil
		t1.componentType = nil
		t1.alignmentType = nil
		t1.minRowPadding = nil
		t1.placeIdOverride = nil
		t1.launchDataOverride = nil
		t1.analyticsData = nil
		t1.primaryWideImageAssetId = nil
		t1.primaryWideImageListId = nil
		t1.primaryWideVideoAssetId = nil
		t1.primaryImageAssetId = nil
		t1.primaryVideoAssetId = nil
		t1.clickoutUrl = nil

		return t1
	end
}

function t2.fromGamesApiData(p1) -- line: 56
	-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
	if type(p1.universeId) ~= "number" and type(p1.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromGamesApiData expects universeId to be a number or a string")
	end

	local v11 = t2.new()

	v11.contentType = OmniRecommendationsContentType.Game
	v11.contentId = tostring(p1.universeId)
	v11.isSponsored = p1.isSponsored
	v11.isShowSponsoredLabel = nil

	if p1.isShowSponsoredLabel == nil then
		v11.isShowSponsoredLabel = true
	else
		v11.isShowSponsoredLabel = p1.isShowSponsoredLabel
	end

	v11.adId = p1.nativeAdData

	if p1.contentMetadata then
		local contentMetadata = p1.contentMetadata

		v11.badgePosition = contentMetadata.badgePosition
		v11.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v11.badgeType = contentMetadata.badgeType
		v11.badgeText = contentMetadata.badgeText
		v11.badgeIcon = contentMetadata.badgeIcon
		v11.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v11)
end

if FFlagSearchOmniAutocompletePage then
	function t2.fromOmniAutocompleteApi(p2) -- line: 89
		-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
		if type(p2.universeId) ~= "number" and type(p2.universeId) ~= "string" then
			return Result.error("TopicContentsEntryModel.fromOmniAutocomplete expects universeId to be a number or a string")
		end

		local v14 = t2.new()

		v14.contentType = OmniRecommendationsContentType.Game
		v14.contentId = tostring(p2.universeId)

		if p2.contentMetadata then
			local contentMetadata = p2.contentMetadata

			v14.badgePosition = contentMetadata.badgePosition
			v14.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
			v14.badgeType = contentMetadata.badgeType
			v14.badgeText = contentMetadata.badgeText
			v14.badgeIcon = contentMetadata.badgeIcon
			v14.badgeComponentType = contentMetadata.badgeComponentType
		end

		return Result.success(v14)
	end
end

function t2.fromExploreApiData(p3) -- line: 116
	-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
	if type(p3.universeId) ~= "number" and type(p3.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromExploreApiData expects universeId to be a number or a string")
	end

	local v17 = t2.new()

	v17.contentType = OmniRecommendationsContentType.Game
	v17.contentId = tostring(p3.universeId)
	v17.isSponsored = p3.isSponsored
	v17.adId = p3.nativeAdData
	v17.isShowSponsoredLabel = nil

	if p3.contentMetadata then
		local contentMetadata = p3.contentMetadata

		v17.badgePosition = contentMetadata.badgePosition
		v17.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v17.badgeType = contentMetadata.badgeType
		v17.badgeText = contentMetadata.badgeText
		v17.badgeIcon = contentMetadata.badgeIcon
		v17.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v17)
end

if FFlagEnableTopSongsSort then
	function t2.songFromExploreApiData(p4) -- line: 142
		-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
		if type(p4.assetId) ~= "number" and type(p4.assetId) ~= "string" then
			return Result.error("TopicContentsEntryModel.songFromExploreApiData expects assetId to be a number or a string")
		end

		local v20 = t2.new()

		v20.contentType = OmniRecommendationsContentType.Song
		v20.contentId = tostring(p4.assetId)
		v20.isSponsored = false

		return Result.success(v20)
	end
end

function t2.fromOmniRecommendations(p5) -- line: 157
	-- upvalues: t2 (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), Result (copy)
	local v22 = t2.new()

	v22.contentType = p5.contentType
	v22.contentId = tostring(p5.contentId)

	if p5.contentMetadata then
		v22.adId = p5.contentMetadata.EncryptedAdTrackingData or nil
		v22.isSponsored = v22.adId ~= nil and v22.adId ~= ""
		v22.isShowSponsoredLabel = nil
		v22.payerName = p5.contentMetadata.PayerName or nil
		v22.logoAssetId = p5.contentMetadata.LogoAssetId
		v22.logoAspectRatio = p5.contentMetadata.LogoAspectRatio
		v22.headline = p5.contentMetadata.Headline
		v22.subtitle = p5.contentMetadata.Subtitle
		v22.ctaText = p5.contentMetadata.CtaText
		v22.tileVariant = p5.contentMetadata.TileVariant
		v22.badgePosition = p5.contentMetadata.badgePosition
		v22.badgeAnalyticsId = p5.contentMetadata.badgeAnalyticsId
		v22.badgeType = p5.contentMetadata.badgeType
		v22.badgeText = p5.contentMetadata.badgeText
		v22.badgeIcon = p5.contentMetadata.badgeIcon
		v22.badgeComponentType = p5.contentMetadata.badgeComponentType
		v22.componentType = p5.contentMetadata.ComponentType
		v22.alignmentType = p5.contentMetadata.AlignmentType
		v22.minRowPadding = p5.contentMetadata.MinRowPadding
		v22.placeIdOverride = if not p5.contentMetadata.PlaceIdOverride then nil else tostring(p5.contentMetadata.PlaceIdOverride)
		v22.launchDataOverride = p5.contentMetadata.LaunchDataOverride
		v22.primaryWideImageAssetId = if not p5.contentMetadata.PrimaryWideImageAssetId or p5.contentMetadata.PrimaryWideImageAssetId == "" then nil else p5.contentMetadata.PrimaryWideImageAssetId
		v22.primaryWideImageListId = p5.contentMetadata.PrimaryWideImageListId
		v22.primaryWideVideoAssetId = p5.contentMetadata.PrimaryWideVideoAssetId
		v22.primaryImageAssetId = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.PrimaryImageAssetId
		v22.primaryVideoAssetId = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.PrimaryVideoAssetId
		v22.clickoutUrl = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.ClickoutUrl
	else
		v22.adId = nil
		v22.isSponsored = false
		v22.isShowSponsoredLabel = nil
		v22.payerName = nil
		v22.placeIdOverride = nil
		v22.launchDataOverride = nil
	end

	v22.analyticsData = p5.analyticsData

	return Result.success(v22)
end

return t2

local Parent = script:FindFirstAncestor("TopicContentsRodux").Parent
local OmniRecommendationsContentType = require(Parent.DiscoveryTypes).OmniRecommendationsContentType
local Result = require(Parent.Result)
local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppEnableWhyThisAdModal = require(Parent.SharedFlags).FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppEnableHomepageOneByTwoTile = require(Parent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local t2 = {
	new = function() -- line: 16
		return {}
	end,
	mock = function(s1: string?) -- line: 22
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

function t2.fromGamesApiData(p1) -- line: 57
	-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
	if type(p1.universeId) ~= "number" and type(p1.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromGamesApiData expects universeId to be a number or a string")
	end

	local v12 = t2.new()

	v12.contentType = OmniRecommendationsContentType.Game
	v12.contentId = tostring(p1.universeId)
	v12.isSponsored = p1.isSponsored
	v12.isShowSponsoredLabel = nil

	if p1.isShowSponsoredLabel == nil then
		v12.isShowSponsoredLabel = true
	else
		v12.isShowSponsoredLabel = p1.isShowSponsoredLabel
	end

	v12.adId = p1.nativeAdData

	if p1.contentMetadata then
		local contentMetadata = p1.contentMetadata

		v12.badgePosition = contentMetadata.badgePosition
		v12.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v12.badgeType = contentMetadata.badgeType
		v12.badgeText = contentMetadata.badgeText
		v12.badgeIcon = contentMetadata.badgeIcon
		v12.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v12)
end

if FFlagSearchOmniAutocompletePage then
	function t2.fromOmniAutocompleteApi(p2) -- line: 90
		-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
		if type(p2.universeId) ~= "number" and type(p2.universeId) ~= "string" then
			return Result.error("TopicContentsEntryModel.fromOmniAutocomplete expects universeId to be a number or a string")
		end

		local v15 = t2.new()

		v15.contentType = OmniRecommendationsContentType.Game
		v15.contentId = tostring(p2.universeId)

		if p2.contentMetadata then
			local contentMetadata = p2.contentMetadata

			v15.badgePosition = contentMetadata.badgePosition
			v15.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
			v15.badgeType = contentMetadata.badgeType
			v15.badgeText = contentMetadata.badgeText
			v15.badgeIcon = contentMetadata.badgeIcon
			v15.badgeComponentType = contentMetadata.badgeComponentType
		end

		return Result.success(v15)
	end
end

function t2.fromExploreApiData(p3) -- line: 117
	-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
	if type(p3.universeId) ~= "number" and type(p3.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromExploreApiData expects universeId to be a number or a string")
	end

	local v18 = t2.new()

	v18.contentType = OmniRecommendationsContentType.Game
	v18.contentId = tostring(p3.universeId)
	v18.isSponsored = p3.isSponsored
	v18.adId = p3.nativeAdData
	v18.isShowSponsoredLabel = nil

	if p3.contentMetadata then
		local contentMetadata = p3.contentMetadata

		v18.badgePosition = contentMetadata.badgePosition
		v18.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v18.badgeType = contentMetadata.badgeType
		v18.badgeText = contentMetadata.badgeText
		v18.badgeIcon = contentMetadata.badgeIcon
		v18.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v18)
end

if FFlagEnableTopSongsSort then
	function t2.songFromExploreApiData(p4) -- line: 143
		-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
		if type(p4.assetId) ~= "number" and type(p4.assetId) ~= "string" then
			return Result.error("TopicContentsEntryModel.songFromExploreApiData expects assetId to be a number or a string")
		end

		local v21 = t2.new()

		v21.contentType = OmniRecommendationsContentType.Song
		v21.contentId = tostring(p4.assetId)
		v21.isSponsored = false

		return Result.success(v21)
	end
end

function t2.fromOmniRecommendations(p5) -- line: 158
	-- upvalues: t2 (copy), FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), Result (copy)
	local v23 = t2.new()

	v23.contentType = p5.contentType
	v23.contentId = tostring(p5.contentId)

	if p5.contentMetadata then
		v23.adId = p5.contentMetadata.EncryptedAdTrackingData or nil
		v23.isSponsored = v23.adId ~= nil and v23.adId ~= ""
		v23.isShowSponsoredLabel = nil
		v23.payerName = if not FFlagLuaAppEnableWhyThisAdModal then nil else p5.contentMetadata.PayerName or nil
		v23.logoAssetId = p5.contentMetadata.LogoAssetId
		v23.logoAspectRatio = p5.contentMetadata.LogoAspectRatio
		v23.headline = p5.contentMetadata.Headline
		v23.subtitle = p5.contentMetadata.Subtitle
		v23.ctaText = p5.contentMetadata.CtaText
		v23.tileVariant = p5.contentMetadata.TileVariant
		v23.badgePosition = p5.contentMetadata.badgePosition
		v23.badgeAnalyticsId = p5.contentMetadata.badgeAnalyticsId
		v23.badgeType = p5.contentMetadata.badgeType
		v23.badgeText = p5.contentMetadata.badgeText
		v23.badgeIcon = p5.contentMetadata.badgeIcon
		v23.badgeComponentType = p5.contentMetadata.badgeComponentType
		v23.componentType = p5.contentMetadata.ComponentType
		v23.alignmentType = p5.contentMetadata.AlignmentType
		v23.minRowPadding = p5.contentMetadata.MinRowPadding
		v23.placeIdOverride = if not p5.contentMetadata.PlaceIdOverride then nil else tostring(p5.contentMetadata.PlaceIdOverride)
		v23.launchDataOverride = p5.contentMetadata.LaunchDataOverride
		v23.primaryWideImageAssetId = if not p5.contentMetadata.PrimaryWideImageAssetId or p5.contentMetadata.PrimaryWideImageAssetId == "" then nil else p5.contentMetadata.PrimaryWideImageAssetId
		v23.primaryWideImageListId = p5.contentMetadata.PrimaryWideImageListId
		v23.primaryWideVideoAssetId = p5.contentMetadata.PrimaryWideVideoAssetId
		v23.primaryImageAssetId = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.PrimaryImageAssetId
		v23.primaryVideoAssetId = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.PrimaryVideoAssetId
		v23.clickoutUrl = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.ClickoutUrl
	else
		v23.adId = nil
		v23.isSponsored = false
		v23.isShowSponsoredLabel = nil
		v23.payerName = nil
		v23.placeIdOverride = nil
		v23.launchDataOverride = nil
	end

	v23.analyticsData = p5.analyticsData

	return Result.success(v23)
end

return t2

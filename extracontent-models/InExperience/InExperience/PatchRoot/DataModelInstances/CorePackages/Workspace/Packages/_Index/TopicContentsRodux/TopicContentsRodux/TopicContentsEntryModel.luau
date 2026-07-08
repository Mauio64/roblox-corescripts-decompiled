local Parent = script:FindFirstAncestor("TopicContentsRodux").Parent
local OmniRecommendationsContentType = require(Parent.DiscoveryTypes).OmniRecommendationsContentType
local Result = require(Parent.Result)
local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppEnableWhyThisAdModal = require(Parent.SharedFlags).FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppGameTileLockedBadge = require(Parent.SharedFlags).FFlagLuaAppGameTileLockedBadge
local FFlagLuaAppEnableHomepageOneByTwoTile = require(Parent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local t2 = {
	new = function() -- line: 17
		return {}
	end,
	mock = function(s1: string?) -- line: 23
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

function t2.fromGamesApiData(p1) -- line: 58
	-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy), FFlagLuaAppGameTileLockedBadge (copy)
	if type(p1.universeId) ~= "number" and type(p1.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromGamesApiData expects universeId to be a number or a string")
	end

	local v13 = t2.new()

	v13.contentType = OmniRecommendationsContentType.Game
	v13.contentId = tostring(p1.universeId)
	v13.isSponsored = p1.isSponsored
	v13.isShowSponsoredLabel = nil

	if p1.isShowSponsoredLabel == nil then
		v13.isShowSponsoredLabel = true
	else
		v13.isShowSponsoredLabel = p1.isShowSponsoredLabel
	end

	v13.adId = p1.nativeAdData

	if FFlagLuaAppGameTileLockedBadge and p1.contentMetadata then
		local contentMetadata = p1.contentMetadata

		v13.badgePosition = contentMetadata.badgePosition
		v13.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v13.badgeType = contentMetadata.badgeType
		v13.badgeText = contentMetadata.badgeText
		v13.badgeIcon = contentMetadata.badgeIcon
		v13.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v13)
end

if FFlagSearchOmniAutocompletePage then
	function t2.fromOmniAutocompleteApi(p2) -- line: 91
		-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy), FFlagLuaAppGameTileLockedBadge (copy)
		if type(p2.universeId) ~= "number" and type(p2.universeId) ~= "string" then
			return Result.error("TopicContentsEntryModel.fromOmniAutocomplete expects universeId to be a number or a string")
		end

		local v16 = t2.new()

		v16.contentType = OmniRecommendationsContentType.Game
		v16.contentId = tostring(p2.universeId)

		if FFlagLuaAppGameTileLockedBadge and p2.contentMetadata then
			local contentMetadata = p2.contentMetadata

			v16.badgePosition = contentMetadata.badgePosition
			v16.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
			v16.badgeType = contentMetadata.badgeType
			v16.badgeText = contentMetadata.badgeText
			v16.badgeIcon = contentMetadata.badgeIcon
			v16.badgeComponentType = contentMetadata.badgeComponentType
		end

		return Result.success(v16)
	end
end

function t2.fromExploreApiData(p3) -- line: 118
	-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy), FFlagLuaAppGameTileLockedBadge (copy)
	if type(p3.universeId) ~= "number" and type(p3.universeId) ~= "string" then
		return Result.error("TopicContentsEntryModel.fromExploreApiData expects universeId to be a number or a string")
	end

	local v19 = t2.new()

	v19.contentType = OmniRecommendationsContentType.Game
	v19.contentId = tostring(p3.universeId)
	v19.isSponsored = p3.isSponsored
	v19.adId = p3.nativeAdData
	v19.isShowSponsoredLabel = nil

	if FFlagLuaAppGameTileLockedBadge and p3.contentMetadata then
		local contentMetadata = p3.contentMetadata

		v19.badgePosition = contentMetadata.badgePosition
		v19.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
		v19.badgeType = contentMetadata.badgeType
		v19.badgeText = contentMetadata.badgeText
		v19.badgeIcon = contentMetadata.badgeIcon
		v19.badgeComponentType = contentMetadata.badgeComponentType
	end

	return Result.success(v19)
end

if FFlagEnableTopSongsSort then
	function t2.songFromExploreApiData(p4) -- line: 144
		-- upvalues: Result (copy), t2 (copy), OmniRecommendationsContentType (copy)
		if type(p4.assetId) ~= "number" and type(p4.assetId) ~= "string" then
			return Result.error("TopicContentsEntryModel.songFromExploreApiData expects assetId to be a number or a string")
		end

		local v22 = t2.new()

		v22.contentType = OmniRecommendationsContentType.Song
		v22.contentId = tostring(p4.assetId)
		v22.isSponsored = false

		return Result.success(v22)
	end
end

function t2.fromOmniRecommendations(p5) -- line: 159
	-- upvalues: t2 (copy), FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), Result (copy)
	local v24 = t2.new()

	v24.contentType = p5.contentType
	v24.contentId = tostring(p5.contentId)

	if p5.contentMetadata then
		v24.adId = p5.contentMetadata.EncryptedAdTrackingData or nil
		v24.isSponsored = v24.adId ~= nil and v24.adId ~= ""
		v24.isShowSponsoredLabel = nil
		v24.payerName = if not FFlagLuaAppEnableWhyThisAdModal then nil else p5.contentMetadata.PayerName or nil
		v24.logoAssetId = p5.contentMetadata.LogoAssetId
		v24.logoAspectRatio = p5.contentMetadata.LogoAspectRatio
		v24.headline = p5.contentMetadata.Headline
		v24.subtitle = p5.contentMetadata.Subtitle
		v24.ctaText = p5.contentMetadata.CtaText
		v24.tileVariant = p5.contentMetadata.TileVariant
		v24.badgePosition = p5.contentMetadata.badgePosition
		v24.badgeAnalyticsId = p5.contentMetadata.badgeAnalyticsId
		v24.badgeType = p5.contentMetadata.badgeType
		v24.badgeText = p5.contentMetadata.badgeText
		v24.badgeIcon = p5.contentMetadata.badgeIcon
		v24.badgeComponentType = p5.contentMetadata.badgeComponentType
		v24.componentType = p5.contentMetadata.ComponentType
		v24.alignmentType = p5.contentMetadata.AlignmentType
		v24.minRowPadding = p5.contentMetadata.MinRowPadding
		v24.placeIdOverride = if not p5.contentMetadata.PlaceIdOverride then nil else tostring(p5.contentMetadata.PlaceIdOverride)
		v24.launchDataOverride = p5.contentMetadata.LaunchDataOverride
		v24.primaryWideImageAssetId = if not p5.contentMetadata.PrimaryWideImageAssetId or p5.contentMetadata.PrimaryWideImageAssetId == "" then nil else p5.contentMetadata.PrimaryWideImageAssetId
		v24.primaryWideImageListId = p5.contentMetadata.PrimaryWideImageListId
		v24.primaryWideVideoAssetId = p5.contentMetadata.PrimaryWideVideoAssetId
		v24.primaryImageAssetId = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.PrimaryImageAssetId
		v24.primaryVideoAssetId = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.PrimaryVideoAssetId
		v24.clickoutUrl = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else p5.contentMetadata.ClickoutUrl
	else
		v24.adId = nil
		v24.isSponsored = false
		v24.isShowSponsoredLabel = nil
		v24.payerName = nil
		v24.placeIdOverride = nil
		v24.launchDataOverride = nil
	end

	v24.analyticsData = p5.analyticsData

	return Result.success(v24)
end

return t2

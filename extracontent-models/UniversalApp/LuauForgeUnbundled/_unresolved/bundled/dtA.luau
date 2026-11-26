local module = require("@luauforge/bundled/dtB")

local module2 = require("@luauforge/bundled/dtC")

local fFlagLuaAppSearchResultsPageGameTileVideo = require("@luauforge/bundled/dtD").FFlagLuaAppSearchResultsPageGameTileVideo

local v5 = {}

function v5.new()
	return {}
end

function v5.mock(value, value2)
	local v6 = v5.new()
	v6.name = "test name"
	v6.universeId = value or "149757"
	v6.placeId = value2 or "384314"
	v6.isSponsored = false
	v6.isShowSponsoredLabel = v6.isSponsored
	v6.adId = nil
	v6.playerCount = 150
	v6.creatorName = "test name"
	v6.creatorHasVerifiedBadge = false
	v6.topicId = "test_topic"
	v6.placeIdOverride = "123"
	v6.launchDataOverride = "test"
	v6.badgePosition = nil
	v6.badgeAnalyticsId = nil
	v6.badgeType = nil
	v6.badgeText = nil
	v6.badgeIcon = nil
	v6.badgeComponentType = nil
	return v6
end

function v5.fromJsonData(data, p2)
	if p2 and type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return module.error("GameSearchEntry.fromJsonData expects universeId to be a number or a string for game contents")
	end

	if p2 and type(data.placeId) ~= "number" and type(data.placeId) ~= "string" then
		return module.error("GameSearchEntry.fromJsonData expects placeId to be a number or a string for game contents")
	end

	local v6 = v5.new()

	v6.name = data.name
	v6.topicId = data.topicId

	if p2 then
		v6.universeId = tostring(data.universeId)
		v6.placeId = tostring(data.placeId)
		v6.isSponsored = data.isSponsored
		v6.isShowSponsoredLabel = nil

		if data.isShowSponsoredLabel == nil then
			v6.isShowSponsoredLabel = true
		else
			v6.isShowSponsoredLabel = data.isShowSponsoredLabel
		end

		v6.adId = data.nativeAdData
		v6.playerCount = data.playerCount

		if fFlagLuaAppSearchResultsPageGameTileVideo then
			v6.primaryWideVideoAssetId = data.primaryWideVideoAssetId
		end

		if module2() then
			v6.creatorName = data.creatorName
			v6.creatorHasVerifiedBadge = data.creatorHasVerifiedBadge
		end

		local contentMetadata = data.contentMetadata

		if contentMetadata then
			local v7 = if contentMetadata.PlaceIdOverride then tostring(contentMetadata.PlaceIdOverride) else nil
			v6.placeIdOverride = v7

			v6.launchDataOverride = contentMetadata.LaunchDataOverride
			v6.badgePosition = contentMetadata.badgePosition
			v6.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
			v6.badgeType = contentMetadata.badgeType
			v6.badgeText = contentMetadata.badgeText
			v6.badgeIcon = contentMetadata.badgeIcon
			v6.badgeComponentType = contentMetadata.badgeComponentType
		end
	end

	return module.success(v6)
end

return v5

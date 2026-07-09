local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Result = require(DiscoveryMonolithParent.Result)
local Modules = DiscoveryMonolith.Modules
local GetFFlagShowCreatorNameOnEmphasisSearchTileIXP = require(Modules.LuaApp.Flags.GetFFlagShowCreatorNameOnEmphasisSearchTileIXP)
local FFlagLuaAppGameTileLockedBadge = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppGameTileLockedBadge
local t1 = {
	new = function() -- line: 33
		return {}
	end
}

function t1.mock(s1: string?, s2: string?) -- line: 39
	-- upvalues: t1 (copy)
	local v10 = t1.new()

	v10.name = "test name"
	v10.universeId = s1 or "149757"
	v10.placeId = s2 or "384314"
	v10.isSponsored = false
	v10.isShowSponsoredLabel = v10.isSponsored
	v10.adId = nil
	v10.playerCount = 150
	v10.creatorName = "test name"
	v10.creatorHasVerifiedBadge = false
	v10.topicId = "test_topic"
	v10.placeIdOverride = "123"
	v10.launchDataOverride = "test"
	v10.badgePosition = nil
	v10.badgeAnalyticsId = nil
	v10.badgeType = nil
	v10.badgeText = nil
	v10.badgeIcon = nil
	v10.badgeComponentType = nil

	return v10
end
function t1.fromJsonData(p1, p2) -- line: 62
	-- upvalues: Result (copy), t1 (copy), GetFFlagShowCreatorNameOnEmphasisSearchTileIXP (copy), FFlagLuaAppGameTileLockedBadge (copy)
	if p2 and (type(p1.universeId) ~= "number" and type(p1.universeId) ~= "string") then
		return Result.error("GameSearchEntry.fromJsonData expects universeId to be a number or a string for game contents")
	end

	if p2 and type(p1.placeId) ~= "number" and type(p1.placeId) ~= "string" then
		return Result.error("GameSearchEntry.fromJsonData expects placeId to be a number or a string for game contents")
	end

	local v13 = t1.new()

	v13.name = p1.name
	v13.topicId = p1.topicId

	if p2 then
		v13.universeId = tostring(p1.universeId)
		v13.placeId = tostring(p1.placeId)
		v13.isSponsored = p1.isSponsored
		v13.isShowSponsoredLabel = nil

		if p1.isShowSponsoredLabel == nil then
			v13.isShowSponsoredLabel = true
		else
			v13.isShowSponsoredLabel = p1.isShowSponsoredLabel
		end

		v13.adId = p1.nativeAdData
		v13.playerCount = p1.playerCount

		if GetFFlagShowCreatorNameOnEmphasisSearchTileIXP() then
			v13.creatorName = p1.creatorName
			v13.creatorHasVerifiedBadge = p1.creatorHasVerifiedBadge
		end

		local contentMetadata = p1.contentMetadata

		if contentMetadata then
			v13.placeIdOverride = if not contentMetadata.PlaceIdOverride then nil else tostring(contentMetadata.PlaceIdOverride)
			v13.launchDataOverride = contentMetadata.LaunchDataOverride

			if FFlagLuaAppGameTileLockedBadge then
				v13.badgePosition = contentMetadata.badgePosition
				v13.badgeAnalyticsId = contentMetadata.badgeAnalyticsId
				v13.badgeType = contentMetadata.badgeType
				v13.badgeText = contentMetadata.badgeText
				v13.badgeIcon = contentMetadata.badgeIcon
				v13.badgeComponentType = contentMetadata.badgeComponentType
			end
		end
	end

	return Result.success(v13)
end

return t1

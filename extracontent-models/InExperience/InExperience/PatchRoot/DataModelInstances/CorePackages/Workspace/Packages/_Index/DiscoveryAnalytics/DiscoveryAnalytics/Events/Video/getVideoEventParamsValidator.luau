local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemType = DiscoveryTypes.GameCollectionItemTypes.GameCollectionItemType
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType

local VideoEventInterfaceKey = require(script.Parent.VideoEventInterfaceKey)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning

local function getVideoEventParamsValidator(p)
	if not FFlagLuaAppEnableNxMRoduxApportioning or p.tileType ~= GameCollectionItemType.OneByTwoTile then
		return VideoEventInterfaceKey.DefaultGameTile
	end

	if p.contentType == OmniRecommendationsContentType.AdLink then
		return VideoEventInterfaceKey.OneByTwoTileAdLink
	end

	return VideoEventInterfaceKey.OneByTwoTileGame
end

return getVideoEventParamsValidator

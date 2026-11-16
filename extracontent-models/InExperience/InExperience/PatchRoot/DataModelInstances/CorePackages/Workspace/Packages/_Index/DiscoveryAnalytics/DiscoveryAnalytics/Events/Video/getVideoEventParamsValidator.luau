local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemType = DiscoveryTypes.GameCollectionItemTypes.GameCollectionItemType
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType

local VideoEventInterfaceKey = require(script.Parent.VideoEventInterfaceKey)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile

local function getVideoEventParamsValidator(p)
	if not FFlagLuaAppEnableHomepageOneByTwoTile or p.tileType ~= GameCollectionItemType.OneByTwoTile then
		return VideoEventInterfaceKey.DefaultGameTile
	end

	if p.contentType == OmniRecommendationsContentType.AdLink then
		return VideoEventInterfaceKey.OneByTwoTileAdLink
	end

	return VideoEventInterfaceKey.OneByTwoTileGame
end

return getVideoEventParamsValidator

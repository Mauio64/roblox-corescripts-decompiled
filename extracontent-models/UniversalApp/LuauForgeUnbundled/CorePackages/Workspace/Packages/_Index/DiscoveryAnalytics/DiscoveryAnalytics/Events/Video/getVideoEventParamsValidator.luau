local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryTypes")
local gameCollectionItemType = DiscoveryTypes.GameCollectionItemTypes.GameCollectionItemType
local omniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType

local VideoEventInterfaceKey = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/VideoEventInterfaceKey")

local fFlagLuaAppEnableHomepageOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppEnableHomepageOneByTwoTile

local function getVideoEventParamsValidator(p2)
	if not fFlagLuaAppEnableHomepageOneByTwoTile or p2.tileType ~= gameCollectionItemType.OneByTwoTile then
		return VideoEventInterfaceKey.DefaultGameTile
	end

	if p2.contentType == omniRecommendationsContentType.AdLink then
		return VideoEventInterfaceKey.OneByTwoTileAdLink
	end

	return VideoEventInterfaceKey.OneByTwoTileGame
end

return getVideoEventParamsValidator

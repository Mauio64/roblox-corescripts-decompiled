local Players = game:GetService("Players")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local FStringMomentsPostInsightsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsPostInsightsIxpLayer")

local recommendationSource = MomentsCommon.Analytics.RecommendationSource

local function logPostInsightsLayerExposure(p2, p3)
	if p3 ~= recommendationSource.Profile then
		return
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer == nil or p2.creatorId ~= localPlayer.UserId then
		return
	end

	MomentsCommon.Utils.logMomentsLayerExposure(FStringMomentsPostInsightsIxpLayer)
end

return logPostInsightsLayerExposure

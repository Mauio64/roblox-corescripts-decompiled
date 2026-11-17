local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Players = game:GetService("Players")

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local FStringMomentsPostInsightsIxpLayer = require(Moments.Flags.FStringMomentsPostInsightsIxpLayer)

local RecommendationSource = MomentsCommon.Analytics.RecommendationSource

local function logPostInsightsLayerExposure(p, p2: string?)
	if p2 ~= RecommendationSource.Profile then
		return
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer == nil or p.creatorId ~= localPlayer.UserId then
		return
	end

	MomentsCommon.Utils.logMomentsLayerExposure(FStringMomentsPostInsightsIxpLayer)
end

return logPostInsightsLayerExposure

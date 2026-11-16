local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent.installReducer.MomentsEligibility)

local SharedFlags = require(parent2.SharedFlags)
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local MomentsCommon = require(parent2.MomentsCommon)
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities

local engineFeature = game:GetEngineFeature("CaptureServiceEnableXExperiencePostingApis")

local function isEligibleForMoments(p): boolean
	if
		not engineFeature
		or FFlagMomentsCreationFeatureGate and not GetMomentsCapabilities(false).getCanCreateMoments(false)
	then
		return false
	end

	return p.byUniverseId[game.GameId] == true
end

return isEligibleForMoments

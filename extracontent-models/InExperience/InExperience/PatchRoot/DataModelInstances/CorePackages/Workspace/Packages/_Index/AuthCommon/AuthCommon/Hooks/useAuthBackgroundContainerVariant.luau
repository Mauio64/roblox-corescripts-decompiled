local Parent = script:FindFirstAncestor("AuthCommon").Parent
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local FFlagEnableAuthBackgroundContainer = require(Parent.SharedFlags).FFlagEnableAuthBackgroundContainer
local LandingLayer = require(Parent.ExperimentLayers).AppBtidLayers.LandingLayer

local function useAuthBackgroundContainerVariant() -- line: 20
	-- upvalues: FFlagEnableAuthBackgroundContainer (copy), RoactAppExperiment (copy), LandingLayer (copy)
	if not FFlagEnableAuthBackgroundContainer then
		return false
	end

	return RoactAppExperiment.useBrowserTrackerExperiment({ LandingLayer }, function(p1) -- line: 27
		-- upvalues: LandingLayer (copy)
		return (p1[LandingLayer] or {}).landingMarketingBackground == "NewGridBackground"
	end)
end

return useAuthBackgroundContainerVariant

local RoactAppExperiment = script:FindFirstAncestor("RoactAppExperiment")

local IXPService = game:GetService("IXPService")

local React = require(RoactAppExperiment.Parent.React)
local ExperimentContext = require(script.Parent.ExperimentContext)

local function useIXPService()
	return React.useContext(ExperimentContext) or IXPService
end

return useIXPService

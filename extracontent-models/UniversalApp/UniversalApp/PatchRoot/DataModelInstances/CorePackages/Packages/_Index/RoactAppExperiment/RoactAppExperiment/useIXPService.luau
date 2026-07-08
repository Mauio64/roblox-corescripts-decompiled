local RoactAppExperiment = script:FindFirstAncestor("RoactAppExperiment")
local IXPService = game:GetService("IXPService")
local React = require(RoactAppExperiment.Parent.React)
local ExperimentContext = require(script.Parent.ExperimentContext)

local function useIXPService() -- line: 8
	-- upvalues: React (copy), ExperimentContext (copy), IXPService (copy)
	local v6 = React.useContext(ExperimentContext)

	if v6 then
		return v6
	end

	return IXPService
end

return useIXPService

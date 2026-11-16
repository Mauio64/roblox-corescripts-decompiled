local parent = script:FindFirstAncestor("ExperimentCacheManager").Parent
local Dash = require(parent.Dash)
local ExperimentLayers = require(parent.ExperimentLayers)
local getAllAppUserLayers = ExperimentLayers.getAllAppUserLayers

return function()
	local allAppUserLayers = getAllAppUserLayers()
	return Dash.values(allAppUserLayers)
end

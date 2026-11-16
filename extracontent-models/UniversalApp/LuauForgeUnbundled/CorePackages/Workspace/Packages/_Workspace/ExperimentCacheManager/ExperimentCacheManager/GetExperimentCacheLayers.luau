local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/Dash")
local getAllAppUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentCacheManager/ExperimentLayers").getAllAppUserLayers

return function()
	local allAppUserLayers = getAllAppUserLayers()
	return Dash.values(allAppUserLayers)
end

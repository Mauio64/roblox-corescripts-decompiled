local Parent = script:FindFirstAncestor("ExperimentCacheManager").Parent
local Dash = require(Parent.Dash)
local getAllAppUserLayers = require(Parent.ExperimentLayers).getAllAppUserLayers

return function() -- line: 5
	-- upvalues: getAllAppUserLayers (copy), Dash (copy)
	local v4 = getAllAppUserLayers()

	return Dash.values(v4)
end

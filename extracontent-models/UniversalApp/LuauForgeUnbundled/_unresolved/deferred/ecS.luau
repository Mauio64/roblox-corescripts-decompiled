local module = require("@luauforge/deferred/ecT")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

return function(p2, p3)
	return performFetch.GetStatus(p2, module(p3))
end

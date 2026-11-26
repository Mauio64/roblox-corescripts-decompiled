local module = require("@luauforge/deferred/hXx")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

return {
	Patch = function(p2, p3, p4)
		return performFetch.Single("luaapp.devsubs.cancelsubscription", function(p5)
			return module(p2, p3, p4)
		end)
	end,
	GetPatchingStatus = function(p2)
		return performFetch.GetStatus(p2, "luaapp.devsubs.cancelsubscription")
	end
}

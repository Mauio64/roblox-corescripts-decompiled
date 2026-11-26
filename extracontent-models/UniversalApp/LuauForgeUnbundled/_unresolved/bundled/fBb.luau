local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/fBc")
local module2 = require("@luauforge/bundled/egs")

return function(p2)
	return performFetch.Single("FetchRobuxBadge", function(p3)
		return module(p2):andThen(function(list)
			if not list then
				return module2.resolve()
			end

			local item = list[1]
			return module2.resolve(item)
		end, function(p4)
			return module2.resolve()
		end)
	end)
end

local module = require("@luauforge/bundled/dyJ")
local module2 = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module3 = require("@luauforge/deferred/fYG")

return function(p2, p3)
	return performFetch.Single("ApiFetchGameBadges" .. p3, function(object)
		return module3(p2, p3):andThen(function(p4)
			object:dispatch(module(p3, p4.responseBody.data))
			return module2.resolve(p4)
		end)
	end)
end

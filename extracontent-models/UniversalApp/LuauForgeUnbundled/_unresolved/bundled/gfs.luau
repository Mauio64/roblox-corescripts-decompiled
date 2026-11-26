local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/gft")
local module2 = require("@luauforge/bundled/gfu")

return function(p2)
	return performFetch.Single("luaapp.apiProxy.incoming-items-count", function(object)
		return module(p2):andThen(function(p3)
			object:dispatch(module2(p3.responseBody.count))

			return p3
		end)
	end)
end

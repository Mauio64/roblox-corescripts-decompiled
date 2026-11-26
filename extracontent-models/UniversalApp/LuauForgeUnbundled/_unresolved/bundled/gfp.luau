local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/gfq")
local module2 = require("@luauforge/bundled/gfr")

return function(p2)
	return performFetch.Single("luaapp.friendsapi.friend-requests-count", function(object)
		return module(p2):andThen(function(p3)
			object:dispatch(module2(p3.responseBody.count))

			return p3
		end)
	end)
end

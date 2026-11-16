local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/fAX")
local module2 = require("@luauforge/bundled/fAY")

return function(p2)
	return performFetch.Single("luaapp.friendsapi.friend-requests-count", function(object)
		return module(p2):andThen(function(p3)
			object:dispatch(module2(p3.responseBody.count))

			return p3
		end)
	end)
end

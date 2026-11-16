local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/fAR")
local module2 = require("@luauforge/bundled/fAS")

return function(p2)
	return performFetch.Single("luaapp.accountsettingsapi.email", function(object)
		return module(p2):andThen(function(p3)
			object:dispatch(module2(p3.responseBody.verified == false and 1 or 0))

			return p3
		end)
	end)
end

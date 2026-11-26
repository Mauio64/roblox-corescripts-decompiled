local module = require("@luauforge/bundled/dJk")
local performFetch = require("@luauforge/bundled/dJl").PerformFetch

return function(p2)
	return performFetch.Single("FetchDialog", function(p3)
		return module(p2):andThen(function(p4)
			return p4.responseBody
		end)
	end)
end

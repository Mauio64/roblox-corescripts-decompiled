local module = require("@luauforge/bundled/dGf")
local performFetch = require("@luauforge/bundled/dGg").PerformFetch

return function(p2)
	return performFetch.Single("FetchDialog", function(p3)
		return module(p2):andThen(function(p4)
			return p4.responseBody
		end)
	end)
end

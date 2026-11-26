local performFetch = require("@luauforge/bundled/fzc").PerformFetch
local module = require("@luauforge/bundled/fzb")

return function(p2)
	return performFetch.Single("GetPromptAssignments", function(p3)
		return module(p2):andThen(function(p4)
			return p4.responseBody
		end)
	end)
end

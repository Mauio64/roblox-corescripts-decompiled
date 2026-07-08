require(script.Parent.networkingCallTypes)

local networkRequests = script.Parent.networkRequests
local createGetCallHistory = require(networkRequests.createGetCallHistory)
local createGetSuggestedCallees = require(networkRequests.createGetSuggestedCallees)

return function(p1) -- line: 9
	-- upvalues: createGetCallHistory (copy), createGetSuggestedCallees (copy)
	return {
		GetCallHistory = createGetCallHistory(p1),
		GetSuggestedCallees = createGetSuggestedCallees(p1)
	}
end

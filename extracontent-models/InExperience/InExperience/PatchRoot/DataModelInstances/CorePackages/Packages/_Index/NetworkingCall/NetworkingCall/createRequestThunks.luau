require(script.Parent.networkingCallTypes)

local networkRequests = script.Parent.networkRequests
local createGetCallHistory = require(networkRequests.createGetCallHistory)

local createGetSuggestedCallees = require(networkRequests.createGetSuggestedCallees)

return function(p)
	return {
		GetCallHistory = createGetCallHistory(p),
		GetSuggestedCallees = createGetSuggestedCallees(p)
	}
end

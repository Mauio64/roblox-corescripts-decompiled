local scriptParent = script.Parent
local networkRequests = scriptParent.networkRequests
local createGetEmailSettings = require(networkRequests.createGetEmailSettings)

require(scriptParent.Types.networkRequestsTypes)

return function(p1) -- line: 6
	-- upvalues: createGetEmailSettings (copy)
	return {
		GetEmailSettings = createGetEmailSettings(p1)
	}
end

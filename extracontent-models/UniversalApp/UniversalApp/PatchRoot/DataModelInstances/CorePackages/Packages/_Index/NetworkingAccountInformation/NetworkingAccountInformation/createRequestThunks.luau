local scriptParent = script.Parent
local networkRequests = scriptParent.networkRequests
local createGetPhoneInformation = require(networkRequests.createGetPhoneInformation)

require(scriptParent.Types.networkRequestsTypes)

return function(p1) -- line: 6
	-- upvalues: createGetPhoneInformation (copy)
	return {
		GetPhoneInformation = createGetPhoneInformation(p1)
	}
end

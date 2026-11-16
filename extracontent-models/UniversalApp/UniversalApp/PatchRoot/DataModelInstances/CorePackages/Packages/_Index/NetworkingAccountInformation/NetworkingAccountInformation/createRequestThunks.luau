local parent = script.Parent
local networkRequests = parent.networkRequests
local createGetPhoneInformation = require(networkRequests.createGetPhoneInformation)
require(parent.Types.networkRequestsTypes)

return function(p)
	return { GetPhoneInformation = createGetPhoneInformation(p) }
end

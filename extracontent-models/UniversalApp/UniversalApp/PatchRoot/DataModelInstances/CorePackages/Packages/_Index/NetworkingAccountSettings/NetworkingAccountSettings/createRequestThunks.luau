local parent = script.Parent
local networkRequests = parent.networkRequests
local createGetEmailSettings = require(networkRequests.createGetEmailSettings)
require(parent.Types.networkRequestsTypes)

return function(p)
	return { GetEmailSettings = createGetEmailSettings(p) }
end

local networkRequests = script.Parent.networkRequests

local createGetPresencesFromUserIds = require(networkRequests.createGetPresencesFromUserIds)
local createSetInvisibilityStatus = require(networkRequests.createSetInvisibilityStatus)
require(script.Parent.networkingPresenceTypes)

return function(p)
	return {
		GetPresencesFromUserIds = createGetPresencesFromUserIds(p),
		SetInvisibilityStatus = createSetInvisibilityStatus(p)
	}
end

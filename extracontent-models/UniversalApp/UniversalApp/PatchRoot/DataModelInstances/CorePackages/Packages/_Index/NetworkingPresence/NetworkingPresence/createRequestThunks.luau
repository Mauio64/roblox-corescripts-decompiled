local networkRequests = script.Parent.networkRequests
local createGetPresencesFromUserIds = require(networkRequests.createGetPresencesFromUserIds)
local createSetInvisibilityStatus = require(networkRequests.createSetInvisibilityStatus)

require(script.Parent.networkingPresenceTypes)

return function(p1) -- line: 7
	-- upvalues: createGetPresencesFromUserIds (copy), createSetInvisibilityStatus (copy)
	return {
		GetPresencesFromUserIds = createGetPresencesFromUserIds(p1),
		SetInvisibilityStatus = createSetInvisibilityStatus(p1)
	}
end

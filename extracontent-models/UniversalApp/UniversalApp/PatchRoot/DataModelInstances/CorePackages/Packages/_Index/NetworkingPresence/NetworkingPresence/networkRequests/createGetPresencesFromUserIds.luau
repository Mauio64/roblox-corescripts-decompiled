local parent = script.Parent.Parent
require(parent.networkingPresenceTypes)
local PRESENCE_URL = require(parent.PRESENCE_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "GetPresencesFromUserIds" }, function(callback, userIds)
		return callback(PRESENCE_URL):path("v1"):path("presence"):path("users"):body({
			userIds = userIds
		}):setStatusIds(userIds)
	end)
end

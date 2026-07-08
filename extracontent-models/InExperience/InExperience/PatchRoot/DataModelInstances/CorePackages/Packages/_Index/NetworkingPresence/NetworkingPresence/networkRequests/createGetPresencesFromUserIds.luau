local ParentParent = script.Parent.Parent

require(ParentParent.networkingPresenceTypes)

local PRESENCE_URL = require(ParentParent.PRESENCE_URL)

return function(p1) -- line: 5
	-- upvalues: PRESENCE_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "GetPresencesFromUserIds"
	}, function(p2, p3) -- line: 8
		-- upvalues: PRESENCE_URL (copy)
		return p2(PRESENCE_URL):path("v1"):path("presence"):path("users"):body({
			userIds = p3
		}):setStatusIds(p3)
	end)
end

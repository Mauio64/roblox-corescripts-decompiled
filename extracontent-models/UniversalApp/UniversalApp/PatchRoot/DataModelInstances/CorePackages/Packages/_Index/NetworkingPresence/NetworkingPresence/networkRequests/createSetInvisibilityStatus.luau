local ParentParent = script.Parent.Parent

require(ParentParent.networkingPresenceTypes)

local PRESENCE_URL = require(ParentParent.PRESENCE_URL)

return function(p1) -- line: 7
	-- upvalues: PRESENCE_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "SetInvisibilityStatus"
	}, function(p2, b1: boolean) -- line: 10
		-- upvalues: PRESENCE_URL (copy)
		return p2(PRESENCE_URL):path("v1"):path("presence"):path("set-invisibility-status"):body({
			isInvisible = b1
		})
	end)
end

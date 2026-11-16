local parent = script.Parent.Parent

require(parent.networkingPresenceTypes)

local PRESENCE_URL = require(parent.PRESENCE_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "SetInvisibilityStatus" }, function(callback, isInvisible: boolean)
		return callback(PRESENCE_URL):path("v1"):path("presence"):path("set-invisibility-status"):body({
			isInvisible = isInvisible
		})
	end)
end

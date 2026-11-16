local getUserPresenceByUserId = require(script.getUserPresenceByUserId)

return function(p)
	return { getUserPresenceByUserId = getUserPresenceByUserId(p) }
end

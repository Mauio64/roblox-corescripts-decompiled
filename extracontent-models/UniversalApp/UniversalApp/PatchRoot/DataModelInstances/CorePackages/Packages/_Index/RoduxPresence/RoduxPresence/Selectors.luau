local getUserPresenceByUserId = require(script.getUserPresenceByUserId)

return function(p1) -- line: 3
	-- upvalues: getUserPresenceByUserId (copy)
	return {
		getUserPresenceByUserId = getUserPresenceByUserId(p1)
	}
end

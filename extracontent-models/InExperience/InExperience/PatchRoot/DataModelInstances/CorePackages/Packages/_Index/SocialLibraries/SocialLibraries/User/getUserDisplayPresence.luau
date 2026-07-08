local getPresenceTextFromUser = require(script.Parent.getPresenceTextFromUser)
local presenceImageByPresence = require(script.Parent.presenceImageByPresence)

return function(p1) -- line: 4
	-- upvalues: getPresenceTextFromUser (copy), presenceImageByPresence (copy)
	return {
		text = getPresenceTextFromUser(p1),
		image = presenceImageByPresence[p1.presence]
	}
end

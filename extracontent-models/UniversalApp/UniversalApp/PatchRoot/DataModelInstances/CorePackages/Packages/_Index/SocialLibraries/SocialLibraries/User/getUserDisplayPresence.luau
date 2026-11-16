local getPresenceTextFromUser = require(script.Parent.getPresenceTextFromUser)
local presenceImageByPresence = require(script.Parent.presenceImageByPresence)

return function(p)
	return { text = getPresenceTextFromUser(p), image = presenceImageByPresence[p.presence] }
end

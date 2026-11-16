local user = script:FindFirstAncestor("SocialLibraries").User
local presenceImageByPresence = require(user.presenceImageByPresence)
local getPresenceTextFromUser = require(user.getPresenceTextFromUser)

local getOtherParticipant = require(script.Parent.getOtherParticipant)

return function(p, p2)
	if p2.conversationType ~= "OneToOneConversation" then
		return nil
	end

	local otherParticipant = getOtherParticipant(p, p2.participants)

	local v = otherParticipant and p.Users[otherParticipant]

	if v then
		return { image = presenceImageByPresence[v.presence], text = getPresenceTextFromUser(v) }
	end

	return nil
end

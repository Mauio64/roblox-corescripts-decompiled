local User = script:FindFirstAncestor("SocialLibraries").User
local presenceImageByPresence = require(User.presenceImageByPresence)
local getPresenceTextFromUser = require(User.getPresenceTextFromUser)
local getOtherParticipant = require(script.Parent.getOtherParticipant)

return function(p1, p2) -- line: 8
	-- upvalues: getOtherParticipant (copy), presenceImageByPresence (copy), getPresenceTextFromUser (copy)
	if p2.conversationType == "OneToOneConversation" then
		local v7 = getOtherParticipant(p1, p2.participants)

		if v7 then
			local v8 = p1.Users[v7]

			if v8 then
				return {
					image = presenceImageByPresence[v8.presence],
					text = getPresenceTextFromUser(v8)
				}
			end
		end
	end

	return nil
end

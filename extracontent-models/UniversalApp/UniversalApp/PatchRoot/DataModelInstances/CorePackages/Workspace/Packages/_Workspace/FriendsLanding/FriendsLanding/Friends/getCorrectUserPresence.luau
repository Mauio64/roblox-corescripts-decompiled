local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local PresenceType = require(FriendsLanding.dependencies).RoduxPresence.Enums.PresenceType
local isUserInGame = require(script.Parent.isUserInGame)

return function(p1) -- line: 10
	-- upvalues: PresenceType (copy), isUserInGame (copy)
	if not p1 then
		return nil
	end

	assert(p1, "")

	local userPresenceType = p1.userPresenceType

	if userPresenceType == PresenceType.InGame then
		return isUserInGame(p1) and PresenceType.InGame or PresenceType.Online
	end

	return userPresenceType
end

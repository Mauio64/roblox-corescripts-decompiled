local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local isUserInGame = require(script.Parent.isUserInGame)

return function(p)
	if not p then
		return nil
	end

	assert(p, "")

	local userPresenceType = p.userPresenceType

	if userPresenceType == presenceType.InGame then
		return isUserInGame(p) and presenceType.InGame or presenceType.Online
	end

	return userPresenceType
end

local presenceType = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").RoduxPresence.Enums.PresenceType
local isUserInGame = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/isUserInGame")

return function(p2)
	if not p2 then
		return nil
	end

	assert(p2, "")

	local userPresenceType = p2.userPresenceType

	if userPresenceType == presenceType.InGame then
		return isUserInGame(p2) and presenceType.InGame or presenceType.Online
	end

	return userPresenceType
end

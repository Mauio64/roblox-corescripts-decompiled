local presenceType = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").RoduxPresence.Enums.PresenceType

return function(p2)
	if not p2 then
		return false
	end

	assert(p2, "user modal must be non-nil")
	return p2.userPresenceType == presenceType.InGame
		and p2.lastLocation
		and p2.lastLocation ~= ""
		and true
		or false
end

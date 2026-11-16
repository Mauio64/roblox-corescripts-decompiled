local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

return function(p)
	if not p then
		return false
	end

	assert(p, "user modal must be non-nil")
	return p.userPresenceType == presenceType.InGame and p.lastLocation and p.lastLocation ~= "" and true or false
end

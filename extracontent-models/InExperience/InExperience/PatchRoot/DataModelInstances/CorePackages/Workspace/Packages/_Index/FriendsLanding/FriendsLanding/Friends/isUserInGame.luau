local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local PresenceType = require(FriendsLanding.dependencies).RoduxPresence.Enums.PresenceType

return function(t1: {[any]: any}?) -- line: 11
	-- upvalues: PresenceType (copy)
	if not t1 then
		return false
	end

	assert(t1, "user modal must be non-nil")

	return t1.userPresenceType == PresenceType.InGame and (not not t1.lastLocation and (t1.lastLocation ~= "" or false))
end

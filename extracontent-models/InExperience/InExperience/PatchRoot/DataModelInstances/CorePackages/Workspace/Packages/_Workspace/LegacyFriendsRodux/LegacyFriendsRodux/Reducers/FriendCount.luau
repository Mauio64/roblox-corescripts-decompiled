local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local SetFriendCount = require(LegacyFriendsRodux.Actions).SetFriendCount

return function(p1, p2) -- line: 5
	-- upvalues: SetFriendCount (copy)
	local v5 = p1 or 0

	if p2.type == SetFriendCount.name then
		v5 = p2.count
	end

	return v5
end

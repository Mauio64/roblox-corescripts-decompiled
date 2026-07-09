local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local LegacyFriendsRoduxParent = LegacyFriendsRodux.Parent
local Cryo = require(LegacyFriendsRoduxParent.Cryo)
local UpdateFriendPresenceCounts = require(LegacyFriendsRodux.Actions).UpdateFriendPresenceCounts

return function(p1, p2) -- line: 8
	-- upvalues: UpdateFriendPresenceCounts (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == UpdateFriendPresenceCounts.name then
		v7 = Cryo.Dictionary.join({}, p2.presenceCounts)
	end

	return v7
end

local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local parent = LegacyFriendsRodux.Parent

local Cryo = require(parent.Cryo)
local Actions = require(LegacyFriendsRodux.Actions)
local UpdateFriendPresenceCounts = Actions.UpdateFriendPresenceCounts

return function(options, p)
	return p.type ~= UpdateFriendPresenceCounts.name and (options or {}) or Cryo.Dictionary.join({}, p.presenceCounts)
end

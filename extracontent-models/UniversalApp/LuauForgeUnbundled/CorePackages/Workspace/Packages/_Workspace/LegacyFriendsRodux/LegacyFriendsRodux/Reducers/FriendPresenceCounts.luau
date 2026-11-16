local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/Cryo")
local updateFriendPresenceCounts = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Actions").UpdateFriendPresenceCounts

return function(options, p2)
	return p2.type ~= updateFriendPresenceCounts.name and (options or {})
		or Cryo.Dictionary.join({}, p2.presenceCounts)
end

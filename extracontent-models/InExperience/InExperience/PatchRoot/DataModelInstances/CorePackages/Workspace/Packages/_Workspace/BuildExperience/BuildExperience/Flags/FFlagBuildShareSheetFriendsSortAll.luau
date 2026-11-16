local parent = script:FindFirstAncestor("BuildExperience").Parent

local v = game:DefineFastFlag("BuildShareSheetFriendsSortAll", false)

if v then
	local SharedFlags = require(parent.SharedFlags)
	return SharedFlags.FFlagShareSheetFriendsSort
end

return v

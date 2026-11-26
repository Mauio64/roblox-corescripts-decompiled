local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")

local v5 = { all = filterStates.All, online = filterStates.Online, trusted = filterStates.Trusted }

local function getInitialFilter(value)
	if value == nil then
		return filterStates.All
	end

	return v5[string.lower(value)] or filterStates.All
end

return getInitialFilter

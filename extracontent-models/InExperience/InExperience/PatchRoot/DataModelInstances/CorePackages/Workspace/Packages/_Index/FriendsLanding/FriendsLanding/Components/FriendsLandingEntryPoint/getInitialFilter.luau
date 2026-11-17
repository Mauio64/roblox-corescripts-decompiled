local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

local filterStates = require(FriendsLanding.Friends.filterStates)

local v = { all = filterStates.All, online = filterStates.Online, trusted = filterStates.Trusted }

local function getInitialFilter(value: string?)
	if value == nil then
		return filterStates.All
	end

	return v[string.lower(value)] or filterStates.All
end

return getInitialFilter

local module = require("@luauforge/bundled/dxC")
local useLastOnlineForSort = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Utils/presenceSortComparator").useLastOnlineForSort
local getFriendWeight = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Utils/presenceSortComparator").getFriendWeight

local module2 = require("@luauforge/deferred/hLS")

if require("@luauforge/deferred/hLT") and module2 then
	return nil
end

return function(data, p2): boolean
	local friendWeight = getFriendWeight(data)
	local friendWeight2 = getFriendWeight(p2)

	if friendWeight ~= friendWeight2 then
		return friendWeight2 < friendWeight
	end

	if
		data.presence == module.PresenceType.OFFLINE
		or not useLastOnlineForSort(data.lastOnline, p2.lastOnline)
	then
		return data.name:lower() < p2.name:lower()
	end

	return data.lastOnline > p2.lastOnline
end

local module = require("@luauforge/bundled/dAF")

local module2 = require("@luauforge/deferred/hWA")
local module3 = require("@luauforge/deferred/hWB")

local v5 = {
	[module.PresenceType.IN_GAME] = 3,
	[module.PresenceType.ONLINE] = 2,
	[module.PresenceType.IN_STUDIO] = 1,
	[module.PresenceType.OFFLINE] = 0
}

local function useLastOnlineForSort(value, value2): boolean
	return typeof(value) == "number" and typeof(value2) == "number" and value ~= value2
end

local function getFriendWeight(p2)
	local friendWeight = if p2 and p2.presence then v5[p2.presence] else nil

	if friendWeight == nil then
		friendWeight = v5[module.PresenceType.OFFLINE]
	end

	return friendWeight
end

if module3 and module2 then
	useLastOnlineForSort = nil
end

if module3 and module2 then
	getFriendWeight = nil
end

return {
	useLastOnlineForSort = useLastOnlineForSort,
	getFriendWeight = getFriendWeight
}

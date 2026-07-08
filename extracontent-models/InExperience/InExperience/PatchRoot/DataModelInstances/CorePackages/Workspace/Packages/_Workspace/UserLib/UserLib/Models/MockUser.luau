local User = require(script.Parent.User)
local n1 = 0
local t1 = {}

t1.__index = t1

function t1.new() -- line: 15
	-- upvalues: User (copy), n1 (ref)
	local v4 = User.new()

	n1 += 1
	v4.id = tostring(n1)
	v4.isFetching = false
	v4.isFriend = false
	v4.friendRank = 0
	v4.lastLocation = nil
	v4.name = "USER NAME"
	v4.universeId = nil
	v4.placeId = nil
	v4.rootPlaceId = nil
	v4.gameInstanceId = nil
	v4.presence = User.PresenceType.OFFLINE
	v4.membership = nil
	v4.thumbnails = nil
	v4.lastOnline = nil
	v4.displayName = "DN+" .. v4.name
	v4.externalAppDisplayName = "EXTERNAL APP DISPLAY NAME"
	v4.hasVerifiedBadge = false
	v4.hasRobloxSubscription = false
	setmetatable(v4, {
		__index = User
	})

	return v4
end
function t1.mockEndpointResponse() -- line: 45
	return {
		created = "0001-01-01T06:00:00Z",
		displayName = "DN+12345",
		friendFrequentRank = 1,
		friendFrequentScore = 2,
		id = 12345,
		isBanned = false,
		isDeleted = false,
		isOnline = false,
		name = "USER NAME",
		presenceType = 0,
		hasVerifiedBadge = false
	}
end

return t1

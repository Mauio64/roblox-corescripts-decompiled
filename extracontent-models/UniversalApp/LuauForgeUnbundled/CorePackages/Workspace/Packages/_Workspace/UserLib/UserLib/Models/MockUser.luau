local User = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Models/User")

local count = 0

local v5 = {}
v5.__index = v5

function v5.new()
	local v6 = User.new()
	count += 1
	v6.id = tostring(count)

	v6.isFetching = false
	v6.isFriend = false
	v6.friendRank = 0
	v6.lastLocation = nil
	v6.name = "USER NAME"
	v6.universeId = nil
	v6.placeId = nil
	v6.rootPlaceId = nil
	v6.gameInstanceId = nil
	v6.presence = User.PresenceType.OFFLINE
	v6.membership = nil
	v6.thumbnails = nil
	v6.lastOnline = nil
	v6.displayName = "DN+" .. v6.name
	v6.externalAppDisplayName = "EXTERNAL APP DISPLAY NAME"
	v6.hasVerifiedBadge = false
	v6.hasRobloxSubscription = false

	setmetatable(v6, { __index = User })

	return v6
end

function v5.mockEndpointResponse()
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

return v5

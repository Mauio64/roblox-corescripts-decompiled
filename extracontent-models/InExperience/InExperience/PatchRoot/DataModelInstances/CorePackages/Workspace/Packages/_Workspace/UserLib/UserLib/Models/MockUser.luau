local User = require(script.Parent.User)

local count = 0

local MockUser = {}
MockUser.__index = MockUser

local function fn() -- 1 equivalent call inferred from this helper
	count += 1
	return (tostring(count))
end

function MockUser.new()
	local v = User.new()

	v.id = fn() -- inferred equivalent call

	v.isFetching = false
	v.isFriend = false
	v.friendRank = 0
	v.lastLocation = nil
	v.name = "USER NAME"
	v.universeId = nil
	v.placeId = nil
	v.rootPlaceId = nil
	v.gameInstanceId = nil
	v.presence = User.PresenceType.OFFLINE
	v.membership = nil
	v.thumbnails = nil
	v.lastOnline = nil
	v.displayName = "DN+" .. v.name
	v.externalAppDisplayName = "EXTERNAL APP DISPLAY NAME"
	v.hasVerifiedBadge = false
	v.hasRobloxSubscription = false

	setmetatable(v, { __index = User })

	return v
end

function MockUser.mockEndpointResponse()
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

return MockUser

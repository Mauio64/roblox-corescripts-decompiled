local parent = script:FindFirstAncestor("ApolloPresence").Parent

local Cryo = require(parent.Cryo)

local GraphQLServer = require(parent.GraphQLServer)
local presenceType = GraphQLServer.types.PresenceType

local v = {
	[presenceType.Offline] = 0,
	[presenceType.Online] = 1,
	[presenceType.InGame] = 2,
	[presenceType.InStudio] = 3
}

local foldLeft = Cryo.List.foldLeft(Cryo.Dictionary.keys(v), function(p, p2)
	p[tostring(v[p2])] = p2
	return p
end, {})

local function convertToStringWithDefault(p) -- 4 equivalent calls inferred from this helper
	if p then
		return (tostring(p))
	end

	return ""
end

local function formatNumberToPresenceType(userPresenceNumber) -- 1 equivalent call inferred from this helper
	return userPresenceNumber and foldLeft[tostring(userPresenceNumber)] or presenceType.Offline
end

local Formatters = {}
Formatters.formatNumberToPresenceType = formatNumberToPresenceType

function Formatters.formatPresenceTypeToNumber(p)
	return p and v[p] or v[presenceType.Offline]
end

function Formatters.formatUserPresence(data)
	local v2 = {
		id = data.id,
		userPresenceType = 0,
		lastLocation = 0,
		lastOnline = 0,
		gameId = 0,
		placeId = 0,
		rootPlaceId = 0,
		universeId = 0
	}
	local userPresenceType

	if data.userPresenceType then
		userPresenceType = data.userPresenceType
	else
		userPresenceType = formatNumberToPresenceType(data.userPresenceNumber) -- inferred equivalent call
	end

	v2.userPresenceType = userPresenceType

	v2.lastLocation = data.lastLocation or ""
	v2.lastOnline = data.lastOnline or ""
	v2.gameId = convertToStringWithDefault(data.gameId) -- inferred equivalent call
	v2.placeId = convertToStringWithDefault(data.placeId) -- inferred equivalent call
	v2.rootPlaceId = convertToStringWithDefault(data.rootPlaceId) -- inferred equivalent call
	v2.universeId = convertToStringWithDefault(data.universeId) -- inferred equivalent call
	return v2
end

return Formatters

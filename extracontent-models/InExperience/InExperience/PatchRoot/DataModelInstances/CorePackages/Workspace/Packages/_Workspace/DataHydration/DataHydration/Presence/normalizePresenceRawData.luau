local DataHydration = script:FindFirstAncestor("DataHydration")
local SharedFlags = require(DataHydration.Parent.SharedFlags)
local FFlagPresenceLocationType = SharedFlags.FFlagPresenceLocationType
local PresenceType = require(script.Parent.Enums.PresenceType)

local v = {
	[0] = PresenceType.Offline,
	[1] = PresenceType.Online,
	[2] = PresenceType.InGame,
	[3] = PresenceType.InStudio
}

local function coerceStringField(p) -- 5 equivalent calls inferred from this helper
	if p == nil then
		return ""
	end

	return (tostring(p))
end

local function mapRawPresenceTypeToEnum(userPresenceType)
	if type(userPresenceType) == "number" then
		return v[userPresenceType] or PresenceType.Offline
	end

	if
		type(userPresenceType) == "string"
		and (userPresenceType == "Offline" or userPresenceType == "Online" or userPresenceType == "InGame" or userPresenceType == "InStudio")
	then
		return userPresenceType
	end

	if
		userPresenceType == PresenceType.Offline
		or userPresenceType == PresenceType.Online
		or userPresenceType == PresenceType.InGame
		or userPresenceType == PresenceType.InStudio
	then
		return userPresenceType
	end

	return PresenceType.Offline
end

local function fromApiPresenceTable(data, p)
	p = data and data.userId or p

	if not data or type(data) ~= "table" or not p then
		return nil
	end

	local v2 = {
		id = tostring(p),
		userPresenceType = mapRawPresenceTypeToEnum(data.userPresenceType),
		lastLocation = coerceStringField(data.lastLocation), -- inferred equivalent call
		lastOnline = data.lastOnline,
		gameId = coerceStringField(data.gameId), -- inferred equivalent call
		placeId = coerceStringField(data.placeId), -- inferred equivalent call
		rootPlaceId = coerceStringField(data.rootPlaceId), -- inferred equivalent call
		universeId = coerceStringField(data.universeId), -- inferred equivalent call
		locationType = 0
	}
	local locationType

	if FFlagPresenceLocationType then
		locationType = data.locationType
	end

	v2.locationType = locationType
	return v2
end

return fromApiPresenceTable

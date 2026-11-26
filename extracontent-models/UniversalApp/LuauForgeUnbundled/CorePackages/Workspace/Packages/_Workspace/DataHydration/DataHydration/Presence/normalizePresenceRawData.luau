local fFlagPresenceLocationType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagPresenceLocationType
local PresenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Enums/PresenceType")

local v5 = {
	[0] = PresenceType.Offline,
	[1] = PresenceType.Online,
	[2] = PresenceType.InGame,
	[3] = PresenceType.InStudio
}

local function coerceStringField(p2)
	if p2 == nil then
		return ""
	end

	return (tostring(p2))
end

local function mapRawPresenceTypeToEnum(userPresenceType)
	if type(userPresenceType) == "number" then
		return v5[userPresenceType] or PresenceType.Offline
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

local function fromApiPresenceTable(data, p2)
	p2 = data and data.userId or p2

	if not data or type(data) ~= "table" or not p2 then
		return nil
	end

	local v6 = {
		id = tostring(p2),
		userPresenceType = mapRawPresenceTypeToEnum(data.userPresenceType),
		lastLocation = 0,
		lastOnline = 0,
		gameId = 0,
		placeId = 0,
		rootPlaceId = 0,
		universeId = 0,
		locationType = 0
	}
	local lastLocation = data.lastLocation
	v6.lastLocation = lastLocation == nil and "" or tostring(lastLocation)
	v6.lastOnline = data.lastOnline
	local gameId = data.gameId
	v6.gameId = gameId == nil and "" or tostring(gameId)
	local placeId = data.placeId
	v6.placeId = placeId == nil and "" or tostring(placeId)
	local rootPlaceId = data.rootPlaceId
	v6.rootPlaceId = rootPlaceId == nil and "" or tostring(rootPlaceId)
	local universeId = data.universeId
	v6.universeId = universeId == nil and "" or tostring(universeId)
	local v7 = if fFlagPresenceLocationType then data.locationType else nil
	v6.locationType = v7
	return v6
end

return fromApiPresenceTable

local PresenceType = require(script.Parent.Enums.PresenceType)
local t1 = {
	[0] = PresenceType.Offline,
	[1] = PresenceType.Online,
	[2] = PresenceType.InGame,
	[3] = PresenceType.InStudio
}

local function coerceStringField(p1) -- line: 34
	if p1 == nil then
		return ""
	end

	return (tostring(p1))
end
local function mapRawPresenceTypeToEnum(p2) -- line: 41
	-- upvalues: t1 (copy), PresenceType (copy)
	if type(p2) == "number" then
		return t1[p2] or PresenceType.Offline
	end

	if type(p2) == "string" and (p2 == "Offline" or p2 == "Online" or p2 == "InGame" or p2 == "InStudio") then
		return p2
	end

	if p2 == PresenceType.Offline or p2 == PresenceType.Online or p2 == PresenceType.InGame or p2 == PresenceType.InStudio then
		return p2
	end

	return PresenceType.Offline
end
local function fromApiPresenceTable(t2: {[any]: any}?, p3) -- line: 61
	-- upvalues: mapRawPresenceTypeToEnum (copy)
	local v10 = t2 and t2.userId or p3

	if not t2 or (type(t2) ~= "table" or not v10) then
		return nil
	end

	local t3 = {
		id = tostring(v10),
		userPresenceType = mapRawPresenceTypeToEnum(t2.userPresenceType)
	}
	local lastLocation = t2.lastLocation

	t3.lastLocation = if lastLocation ~= nil then tostring(lastLocation) else ""
	t3.lastOnline = t2.lastOnline

	local gameId = t2.gameId

	t3.gameId = if gameId ~= nil then tostring(gameId) else ""

	local placeId = t2.placeId

	t3.placeId = if placeId ~= nil then tostring(placeId) else ""

	local rootPlaceId = t2.rootPlaceId

	t3.rootPlaceId = if rootPlaceId ~= nil then tostring(rootPlaceId) else ""

	local universeId = t2.universeId

	t3.universeId = if universeId ~= nil then tostring(universeId) else ""

	return t3
end

return fromApiPresenceTable

local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local RoduxPresenceParent = RoduxPresence.Parent
local Cryo = require(RoduxPresenceParent.Cryo)
local t = require(RoduxPresenceParent.t)
local Enums = require(RoduxPresence.Enums)
local t1 = {}

function t1.new(p1) -- line: 10
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 22
	-- upvalues: t1 (copy)
	local v9 = p2 or {}

	return (t1.new({
		gameId = v9.gameId or "Game-OoooOO-Id",
		invisibleModeExpiry = v9.invisibleModeExpiry or "2061-01-01T00:00:00Z",
		lastLocation = v9.lastLocation or "LastLocation",
		lastOnline = v9.lastOnline or "LastOnline-OOOoOO",
		placeId = v9.placeId or 123,
		rootPlaceId = v9.rootPlaceId or 234,
		universeId = v9.universeId or 345,
		userId = v9.userId or 456,
		userPresenceType = v9.userPresenceType or 0
	}))
end
function t1.format(p3) -- line: 40
	-- upvalues: Cryo (copy), Enums (copy)
	return Cryo.Dictionary.join(p3, {
		userPresenceType = Enums.PresenceType.fromRawValue(p3.userPresenceType)
	})
end

t1.isValid = t.interface({
	gameId = t.optional(t.string),
	invisibleModeExpiry = t.optional(t.string),
	lastLocation = t.string,
	lastOnline = t.string,
	placeId = t.optional(t.union(t.numberPositive, t.string)),
	rootPlaceId = t.optional(t.union(t.numberPositive, t.string)),
	universeId = t.optional(t.union(t.numberPositive, t.string)),
	userId = t.union(t.numberPositive, t.string),
	userPresenceType = function(p4) -- line: 55
		-- upvalues: Enums (copy)
		return Enums.PresenceType.fromRawValue(p4) ~= nil
	end
})

return t1

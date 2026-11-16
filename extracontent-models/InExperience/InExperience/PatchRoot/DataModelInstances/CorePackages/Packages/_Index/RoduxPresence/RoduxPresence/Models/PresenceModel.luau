local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local parent = RoduxPresence.Parent
local Cryo = require(parent.Cryo)
local t = require(parent.t)

local Enums = require(RoduxPresence.Enums)

local PresenceModel = {}

function PresenceModel.new(p)
	assert(PresenceModel.isValid(p))

	PresenceModel.__index = PresenceModel

	setmetatable(p, PresenceModel)

	return p
end

function PresenceModel.mock(options)
	local v = options or {}

	return (PresenceModel.new({
		gameId = v.gameId or "Game-OoooOO-Id",
		invisibleModeExpiry = v.invisibleModeExpiry or "2061-01-01T00:00:00Z",
		lastLocation = v.lastLocation or "LastLocation",
		lastOnline = v.lastOnline or "LastOnline-OOOoOO",
		placeId = v.placeId or 123,
		rootPlaceId = v.rootPlaceId or 234,
		universeId = v.universeId or 345,
		userId = v.userId or 456,
		userPresenceType = v.userPresenceType or 0
	}))
end

function PresenceModel.format(p)
	return Cryo.Dictionary.join(p, {
		userPresenceType = Enums.PresenceType.fromRawValue(p.userPresenceType)
	})
end

PresenceModel.isValid = t.interface({
	gameId = t.optional(t.string),
	invisibleModeExpiry = t.optional(t.string),
	lastLocation = t.string,
	lastOnline = t.string,
	placeId = t.optional(t.union(t.numberPositive, t.string)),
	rootPlaceId = t.optional(t.union(t.numberPositive, t.string)),
	universeId = t.optional(t.union(t.numberPositive, t.string)),
	userId = t.union(t.numberPositive, t.string),
	userPresenceType = function(p): boolean
		return Enums.PresenceType.fromRawValue(p) ~= nil
	end
})

return PresenceModel

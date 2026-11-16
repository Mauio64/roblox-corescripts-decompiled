local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationPlayerCountGameInfoStore = SharedFlags.FFlagLuaAppDataHydrationPlayerCountGameInfoStore

local interface = t.interface
local array = t.array
local interface2 = t.interface
local v = {
	id = t.number,
	rootPlaceId = t.number,
	name = t.optional(t.string),
	description = t.optional(t.string),
	creator = t.optional(t.interface({
		id = t.optional(t.number),
		name = t.optional(t.string),
		hasVerifiedBadge = t.optional(t.boolean)
	})),
	visits = t.optional(t.number),
	playerCount = 0,
	totalUpVotes = 0,
	totalDownVotes = 0
}
local playerCount

if FFlagLuaAppDataHydrationPlayerCountGameInfoStore then
	playerCount = t.optional(t.number)
end

v.playerCount = playerCount
v.totalUpVotes = t.optional(t.string)
v.totalDownVotes = t.optional(t.string)
return {
	gameInfoResponseValidator = interface({ data = array(interface2(v)) })
}

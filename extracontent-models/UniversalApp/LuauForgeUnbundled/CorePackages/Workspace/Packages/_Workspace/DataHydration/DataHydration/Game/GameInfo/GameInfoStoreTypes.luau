require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

local fFlagLuaAppDataHydrationPlayerCountGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationPlayerCountGameInfoStore

local interface = t.interface
local array = t.array
local interface2 = t.interface
local v6 = {
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
local v7 = if fFlagLuaAppDataHydrationPlayerCountGameInfoStore then t.optional(t.number) else nil
v6.playerCount = v7
v6.totalUpVotes = t.optional(t.string)
v6.totalDownVotes = t.optional(t.string)
return {
	gameInfoResponseValidator = interface({ data = array(interface2(v6)) })
}

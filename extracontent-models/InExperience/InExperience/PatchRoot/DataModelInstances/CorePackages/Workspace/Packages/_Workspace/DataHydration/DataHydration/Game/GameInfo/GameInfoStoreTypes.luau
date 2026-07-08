local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)

local t = require(DataHydrationParent.t)
local FFlagLuaAppDataHydrationPlayerCountGameInfoStore = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationPlayerCountGameInfoStore
local FFlagSduiExperienceDetailsSupport = require(DataHydrationParent.SharedFlags).FFlagSduiExperienceDetailsSupport

return {
	gameInfoResponseValidator = t.interface({
		data = t.array(t.interface({
			id = t.number,
			rootPlaceId = t.number,
			name = t.optional(t.string),
			description = t.optional(t.string),
			creator = t.optional(t.interface({
				id = t.optional(t.number),
				name = t.optional(t.string),
				hasVerifiedBadge = t.optional(t.boolean)
			})),
			playerCount = if not FFlagLuaAppDataHydrationPlayerCountGameInfoStore then nil else t.optional(t.number),
			totalUpVotes = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string),
			totalDownVotes = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
		}))
	})
}

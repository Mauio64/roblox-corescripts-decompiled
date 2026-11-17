local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
local t = require(parent.t)

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
			visits = t.optional(t.number),
			playerCount = t.optional(t.number),
			totalUpVotes = t.optional(t.string),
			totalDownVotes = t.optional(t.string)
		}))
	})
}

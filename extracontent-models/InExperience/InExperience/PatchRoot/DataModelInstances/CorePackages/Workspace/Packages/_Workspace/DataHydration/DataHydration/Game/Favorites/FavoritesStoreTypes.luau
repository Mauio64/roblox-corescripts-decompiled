local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(parent.Signals)
local t = require(parent.t)

return {
	favoriteResponseValidator = t.interface({ isFavorited = t.optional(t.boolean) })
}

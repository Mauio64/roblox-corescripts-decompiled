local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(DataHydrationParent.Signals)

local t = require(DataHydrationParent.t)

return {
	favoriteResponseValidator = t.interface({
		isFavorited = t.optional(t.boolean)
	})
}

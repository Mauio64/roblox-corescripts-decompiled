local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)

local t = require(DataHydrationParent.t)
local DiscoveryTypes = require(DataHydrationParent.DiscoveryTypes)

return {
	playabilityResponseValidator = t.array(t.interface({
		universeId = t.number,
		isPlayable = t.boolean,
		playabilityStatus = t.optional(t.string)
	})),
	PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
}

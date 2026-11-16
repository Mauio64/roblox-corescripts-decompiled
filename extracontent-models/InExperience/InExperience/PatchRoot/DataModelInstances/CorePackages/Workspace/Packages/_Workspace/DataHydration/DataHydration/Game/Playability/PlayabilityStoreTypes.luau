local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
local t = require(parent.t)
local DiscoveryTypes = require(parent.DiscoveryTypes)

return {
	playabilityResponseValidator = t.array(t.interface({
		universeId = t.number,
		isPlayable = t.boolean,
		playabilityStatus = t.optional(t.string)
	})),
	PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
}

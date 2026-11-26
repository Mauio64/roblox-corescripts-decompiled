require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryTypes")

return {
	playabilityResponseValidator = t.array(t.interface({
		universeId = t.number,
		isPlayable = t.boolean,
		playabilityStatus = t.optional(t.string)
	})),
	PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
}

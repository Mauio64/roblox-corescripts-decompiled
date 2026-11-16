local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)

local function useExperienceDetails(p: string)
	return (SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(p).data))
end

return useExperienceDetails

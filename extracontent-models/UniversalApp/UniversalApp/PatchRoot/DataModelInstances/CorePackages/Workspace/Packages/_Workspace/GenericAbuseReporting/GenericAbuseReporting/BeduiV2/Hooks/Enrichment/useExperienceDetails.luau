local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local DataHydration = require(Parent.DataHydration)
local SignalsReact = require(Parent.SignalsReact)

local function useExperienceDetails(s1: string) -- line: 9
	-- upvalues: SignalsReact (copy), DataHydration (copy)
	return (SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(s1).data))
end

return useExperienceDetails

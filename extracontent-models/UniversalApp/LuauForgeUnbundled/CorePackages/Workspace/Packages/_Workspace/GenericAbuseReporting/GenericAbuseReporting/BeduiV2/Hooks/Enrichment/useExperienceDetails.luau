local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/DataHydration")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SignalsReact")

local function useExperienceDetails(p2)
	return (SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(p2).data))
end

return useExperienceDetails

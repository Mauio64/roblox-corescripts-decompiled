local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")

local function useDataHydrationAccountGeneration()
	return SignalsReact.useSignalState(getSduiApiStore().getAccountGeneration)
end

return useDataHydrationAccountGeneration

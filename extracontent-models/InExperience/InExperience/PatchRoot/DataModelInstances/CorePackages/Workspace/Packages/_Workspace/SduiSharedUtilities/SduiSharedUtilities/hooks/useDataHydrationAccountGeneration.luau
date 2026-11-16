local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local SignalsReact = require(parent.SignalsReact)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useDataHydrationAccountGeneration()
	return SignalsReact.useSignalState(getSduiApiStore().getAccountGeneration)
end

return useDataHydrationAccountGeneration

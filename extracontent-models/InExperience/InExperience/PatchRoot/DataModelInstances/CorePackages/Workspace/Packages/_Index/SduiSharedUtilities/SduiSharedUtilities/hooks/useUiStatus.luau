local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local DataHydration = require(SduiSharedUtilitiesParent.DataHydration)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)
local UiStatus = require(SduiSharedUtilities.SduiIntegrationTypes).UiStatus
local DataHydrationTypes = DataHydration.DataHydrationTypes

local function useUiStatus(s1: string) -- line: 14
	-- upvalues: SignalsReact (copy), getSduiApiStore (copy), DataHydrationTypes (copy), UiStatus (copy)
	local v10 = SignalsReact.useSignalState(getSduiApiStore().getData(s1).status)

	if v10 == DataHydrationTypes.DataStatus.NotReady then
		return UiStatus.Loading
	end

	if v10 == DataHydrationTypes.DataStatus.Failed then
		return UiStatus.Error
	end

	return UiStatus.Resolved
end

return useUiStatus

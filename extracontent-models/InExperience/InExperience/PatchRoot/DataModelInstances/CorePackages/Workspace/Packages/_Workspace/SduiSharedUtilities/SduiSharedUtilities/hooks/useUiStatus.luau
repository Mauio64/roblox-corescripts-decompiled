local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)

local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local UiStatus = SduiIntegrationTypes.UiStatus

local DataHydrationTypes = DataHydration.DataHydrationTypes

local function useUiStatus(p: string)
	local v = SignalsReact.useSignalState(getSduiApiStore().getData(p).status)

	if v == DataHydrationTypes.DataStatus.NotReady then
		return UiStatus.Loading
	end

	if v == DataHydrationTypes.DataStatus.Failed then
		return UiStatus.Error
	end

	return UiStatus.Resolved
end

return useUiStatus

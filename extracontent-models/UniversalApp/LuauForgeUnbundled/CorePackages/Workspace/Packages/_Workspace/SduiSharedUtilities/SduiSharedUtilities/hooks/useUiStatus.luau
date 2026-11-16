local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/DataHydration")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")

local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")
local uiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").UiStatus

local dataHydrationTypes = DataHydration.DataHydrationTypes

local function useUiStatus(p2)
	local v5 = SignalsReact.useSignalState(getSduiApiStore().getData(p2).status)

	if v5 == dataHydrationTypes.DataStatus.NotReady then
		return uiStatus.Loading
	end

	if v5 == dataHydrationTypes.DataStatus.Failed then
		return uiStatus.Error
	end

	return uiStatus.Resolved
end

return useUiStatus

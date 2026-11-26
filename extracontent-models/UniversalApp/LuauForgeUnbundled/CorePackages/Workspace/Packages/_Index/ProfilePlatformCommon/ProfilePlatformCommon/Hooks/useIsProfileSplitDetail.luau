local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SignalsReact").useSignalState

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SplitPane") else nil

return function(): boolean
	if not fFlagEnableSplitPane then
		return false
	end

	local v6 = useSignalState(v5.SplitPaneStore.getStore().getSupportPaneModeIfActive)

	return v6 ~= nil and v5.SplitPaneVariant.getProfileSplitPaneEligibility(v6) ~= nil
end

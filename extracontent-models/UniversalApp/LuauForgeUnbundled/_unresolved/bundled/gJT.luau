local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local splitPaneStore = if fFlagEnableSplitPane then require("@luauforge/bundled/dIW").SplitPaneStore else nil

return function(p2)
	if fFlagEnableSplitPane and splitPaneStore.getStore().getIsBreakpointEnabled(false) then
		return deviceOrientationMode.Landscape
	end

	return p2.DeviceOrientation
end

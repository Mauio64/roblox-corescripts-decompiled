local splitPaneSlot = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView").Enums.SplitPaneSlot

local function isSupportPaneScreen(p2): boolean
	return p2.descriptor.options.splitPaneEligibility == splitPaneSlot.Support
end

return isSupportPaneScreen

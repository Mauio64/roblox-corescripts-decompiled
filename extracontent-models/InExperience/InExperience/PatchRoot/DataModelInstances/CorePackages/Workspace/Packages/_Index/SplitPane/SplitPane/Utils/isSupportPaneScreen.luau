local parent = script:FindFirstAncestor("SplitPane").Parent

local AppSplitView = require(parent.AppSplitView)
local SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot

local function isSupportPaneScreen(p): boolean
	return p.descriptor.options.splitPaneEligibility == SplitPaneSlot.Support
end

return isSupportPaneScreen

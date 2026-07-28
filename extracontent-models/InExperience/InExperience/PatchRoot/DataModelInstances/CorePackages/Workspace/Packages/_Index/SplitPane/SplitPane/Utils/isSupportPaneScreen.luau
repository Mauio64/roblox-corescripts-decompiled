local Parent = script:FindFirstAncestor("SplitPane").Parent
local SplitPaneSlot = require(Parent.AppSplitView).Enums.SplitPaneSlot

local function isSupportPaneScreen(p1) -- line: 7
	-- upvalues: SplitPaneSlot (copy)
	return p1.descriptor.options.splitPaneEligibility == SplitPaneSlot.Support
end

return isSupportPaneScreen

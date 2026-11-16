local parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(parent.React)

return React.createContext({
	renderSupportContent = nil,
	supportPaneResizable = nil,
	onContentRegionRectChanged = nil,
	resolveEligibility = nil
})

local Parent = script:FindFirstAncestor("SplitPane").Parent

return require(Parent.React).createContext({
	renderSupportContent = nil,
	supportPaneResizable = nil,
	onContentRegionRectChanged = nil
})

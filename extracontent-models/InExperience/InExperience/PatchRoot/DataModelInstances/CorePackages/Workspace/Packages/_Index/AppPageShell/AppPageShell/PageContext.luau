local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

require(parent.AppCommonLib)
local React = require(parent.React)

require(AppPageShell.PageTypes)
require(AppPageShell.createPageScrollStore)

return React.createContext({
	scrollViewPositionChangedSignal = nil,
	verticalScrollingFrameRef = nil,
	impressionsParentScrollingFrameRef = nil
})

local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(parent.React)
require(parent.AppCommonLib)

return React.createContext({
	scrollViewPositionChangedSignal = nil,
	verticalScrollingFrameRef = nil,
	impressionsParentScrollingFrameRef = nil
})

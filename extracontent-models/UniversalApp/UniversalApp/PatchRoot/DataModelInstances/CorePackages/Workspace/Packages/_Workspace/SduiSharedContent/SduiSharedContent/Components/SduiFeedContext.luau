local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)

require(Parent.AppCommonLib)

return React.createContext({
	scrollViewPositionChangedSignal = nil,
	verticalScrollingFrameRef = nil
})

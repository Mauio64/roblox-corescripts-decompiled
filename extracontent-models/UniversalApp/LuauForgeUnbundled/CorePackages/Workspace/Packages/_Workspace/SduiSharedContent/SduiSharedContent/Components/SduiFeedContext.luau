local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")

return React.createContext({
	scrollViewPositionChangedSignal = nil,
	verticalScrollingFrameRef = nil,
	impressionsParentScrollingFrameRef = nil
})

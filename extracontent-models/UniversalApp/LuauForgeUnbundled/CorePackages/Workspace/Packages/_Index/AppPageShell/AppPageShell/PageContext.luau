require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/AppCommonLib")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/React")

require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/createPageScrollStore")

return React.createContext({
	scrollViewPositionChangedSignal = nil,
	verticalScrollingFrameRef = nil,
	impressionsParentScrollingFrameRef = nil
})

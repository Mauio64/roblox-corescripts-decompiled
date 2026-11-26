local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

return React.createContext({
	isFullHeight = false,
	isFullWidth = false,
	modalSize = UDim2.new(0, 0, 0, 0),
	modalMode = "default"
})

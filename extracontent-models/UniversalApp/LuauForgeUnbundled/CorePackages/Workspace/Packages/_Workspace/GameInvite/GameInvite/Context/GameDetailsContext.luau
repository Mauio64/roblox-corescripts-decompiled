local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

return React.createContext({
	gameDetails = {},
	serverType = "",
	promptMessage = "",
	trigger = "",
	isCoreScript = false
})

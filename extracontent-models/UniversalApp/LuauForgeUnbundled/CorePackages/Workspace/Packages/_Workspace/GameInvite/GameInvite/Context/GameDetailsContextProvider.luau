local GameDetailsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameDetailsContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

return function(props)
	return React.createElement(GameDetailsContext.Provider, {
		value = {
			gameDetails = props.gameDetails or {},
			serverType = props.serverType or "",
			promptMessage = props.promptMessage or "",
			trigger = props.trigger or "",
			isCoreScript = props.isCoreScript or false
		}
	}, props.children)
end

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")

local GameInviteContextProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameInviteContextProvider")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteContent")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

return function(props)
	return React.createElement(GameInviteContextProvider, {
		options = props.options,
		serverType = props.serverType,
		gameDetails = props.gameDetails,
		isLoadingCustomParams = props.isLoading,
		isCoreScript = props.isCoreScript
	}, {
		GameInviteContent = React.createElement(module3, {
			isLoadingCustomParams = props.isLoading,
			disableSelectionParentManagement = props.disableSelectionParentManagement,
			hideCloseButton = props.hideCloseButton
		})
	})
end

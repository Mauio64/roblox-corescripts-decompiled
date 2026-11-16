local GameInvite = script:FindFirstAncestor("GameInvite")
local Components = GameInvite.Components
local Context = GameInvite.Context
local parent = GameInvite.Parent

local React = require(parent.React)

local GameInviteContextProvider = require(Context.GameInviteContextProvider)
local GameInviteContent = require(Components.GameInviteContent)
require(GameInvite.gameInviteModalType)

return function(props)
	return React.createElement(GameInviteContextProvider, {
		options = props.options,
		serverType = props.serverType,
		gameDetails = props.gameDetails,
		isLoadingCustomParams = props.isLoading,
		isCoreScript = props.isCoreScript
	}, {
		GameInviteContent = React.createElement(GameInviteContent, {
			isLoadingCustomParams = props.isLoading,
			disableSelectionParentManagement = props.disableSelectionParentManagement,
			hideCloseButton = props.hideCloseButton
		})
	})
end

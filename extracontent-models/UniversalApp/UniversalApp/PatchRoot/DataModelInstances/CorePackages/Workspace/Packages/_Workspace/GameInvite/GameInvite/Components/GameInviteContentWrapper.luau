local GameInvite = script:FindFirstAncestor("GameInvite")
local Components = GameInvite.Components
local Context = GameInvite.Context
local GameInviteParent = GameInvite.Parent
local React = require(GameInviteParent.React)
local GameInviteContextProvider = require(Context.GameInviteContextProvider)
local GameInviteContent = require(Components.GameInviteContent)

require(GameInvite.gameInviteModalType)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), GameInviteContextProvider (copy), GameInviteContent (copy)
	return React.createElement(GameInviteContextProvider, {
		options = t1.options,
		serverType = t1.serverType,
		gameDetails = t1.gameDetails,
		isLoadingCustomParams = t1.isLoading,
		isCoreScript = t1.isCoreScript
	}, {
		GameInviteContent = React.createElement(GameInviteContent, {
			isLoadingCustomParams = t1.isLoading,
			disableSelectionParentManagement = t1.disableSelectionParentManagement,
			hideCloseButton = t1.hideCloseButton
		})
	})
end

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")

local function ParentContainerProvider(props)
	return React.createElement(ParentContainerContext.Provider, {
		value = {
			getParentContainer = props.getParentContainer,
			visibilitySignal = props.visibilitySignal,
			getRequestedRoute = props.getRequestedRoute,
			requestedRouteSignal = props.requestedRouteSignal,
			clearRequestedRoute = props.clearRequestedRoute,
			getShouldSetAppChatVisible = props.getShouldSetAppChatVisible,
			entryPoint = props.entryPoint,
			hideParentContainer = props.hideParentContainer,
			showParentContainer = props.showParentContainer,
			updateCurrentSquadId = props.updateCurrentSquadId,
			openFriendsChatConversation = props.openFriendsChatConversation
		}
	}, props.children)
end

return ParentContainerProvider

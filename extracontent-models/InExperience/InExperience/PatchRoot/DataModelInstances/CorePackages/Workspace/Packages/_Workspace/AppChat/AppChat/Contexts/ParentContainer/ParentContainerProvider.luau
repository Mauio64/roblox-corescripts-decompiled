local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local ParentContainerContext = require(script.Parent.ParentContainerContext)

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

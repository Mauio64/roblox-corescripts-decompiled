local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local MessageContextMenuContainer = require(script.Parent.MessageContextMenuContainer)

function MessageContextMenuScreen()
	local v = useNavigation()

	return React.createElement(MessageContextMenuContainer, {
		messageId = v.getParam("messageId"),
		conversationId = v.getParam("conversationId"),
		inputBoxRef = v.getParam("inputBoxRef")
	})
end

return MessageContextMenuScreen

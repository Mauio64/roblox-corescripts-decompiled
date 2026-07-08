local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local MessageContextMenuContainer = require(script.Parent.MessageContextMenuContainer)

function MessageContextMenuScreen() -- line: 12
	-- upvalues: useNavigation (copy), React (copy), MessageContextMenuContainer (copy)
	local v5 = useNavigation()

	return React.createElement(MessageContextMenuContainer, {
		messageId = v5.getParam("messageId"),
		conversationId = v5.getParam("conversationId"),
		inputBoxRef = v5.getParam("inputBoxRef")
	})
end

return MessageContextMenuScreen

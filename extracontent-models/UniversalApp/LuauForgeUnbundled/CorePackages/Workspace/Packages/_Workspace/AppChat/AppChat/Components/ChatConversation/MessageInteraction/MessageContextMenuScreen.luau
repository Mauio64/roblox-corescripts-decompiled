local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local MessageContextMenuContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/MessageContextMenuContainer")

function LUAUFORGE_MODULE_GLOBALS_hpq_MessageContextMenuScreen()
	local v5 = useNavigation()

	return React.createElement(MessageContextMenuContainer, {
		messageId = v5.getParam("messageId"),
		conversationId = v5.getParam("conversationId"),
		inputBoxRef = v5.getParam("inputBoxRef")
	})
end

return LUAUFORGE_MODULE_GLOBALS_hpq_MessageContextMenuScreen

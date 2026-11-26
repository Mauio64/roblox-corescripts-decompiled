local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local ConversationOverlayContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/ConversationOverlayContainer")

return function(p2)
	local v5 = useNavigation()
	local v6 = v5 and v5.getParam("conversationId", nil)
	local v7 = React.useCallback(function()
		if v5 and v5.state.routeName == EnumScreens.ConversationOverlay then
			v5.goBack(v5.state.key)
		end
	end, { v5 })

	return React.createElement(ConversationOverlayContainer, { conversationId = v6, dismissModal = v7 })
end

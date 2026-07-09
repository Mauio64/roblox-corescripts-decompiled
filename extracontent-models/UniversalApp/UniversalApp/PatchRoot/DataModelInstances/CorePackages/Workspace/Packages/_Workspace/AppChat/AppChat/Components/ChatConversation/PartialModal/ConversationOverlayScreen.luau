local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local EnumScreens = require(AppChat.EnumScreens)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local ConversationOverlayContainer = require(script.Parent.ConversationOverlayContainer)

return function(_: {[any]: any}) -- line: 17
	-- upvalues: useNavigation (copy), React (copy), EnumScreens (copy), ConversationOverlayContainer (copy)
	local v8 = useNavigation()
	local v9 = v8 and v8.getParam("conversationId", nil)
	local v10 = React.useCallback(function() -- line: 20
		-- upvalues: v8 (copy), EnumScreens (copy)
		if v8 and v8.state.routeName == EnumScreens.ConversationOverlay then
			v8.goBack(v8.state.key)
		end
	end, { v8 })

	return React.createElement(ConversationOverlayContainer, {
		conversationId = v9,
		dismissModal = v10
	})
end

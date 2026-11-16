local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)

local EnumScreens = require(AppChat.EnumScreens)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local ConversationOverlayContainer = require(script.Parent.ConversationOverlayContainer)

return function(_)
	local v = useNavigation()
	local conversationId = v and v.getParam("conversationId", nil)
	local dismissModal = React.useCallback(function()
		if v and v.state.routeName == EnumScreens.ConversationOverlay then
			v.goBack(v.state.key)
		end
	end, { v })

	return React.createElement(ConversationOverlayContainer, {
		conversationId = conversationId,
		dismissModal = dismissModal
	})
end

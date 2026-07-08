local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local v4 = require(AppChat.Logger):new(script.Name)
local EnumScreens = require(AppChat.EnumScreens)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local TrustedConnectionsUpsellContainer = require(script.Parent.TrustedConnectionsUpsellContainer)

return function(_: {[any]: any}) -- line: 13
	-- upvalues: useNavigation (copy), React (copy), EnumScreens (copy), v4 (copy), TrustedConnectionsUpsellContainer (copy)
	local v9 = useNavigation()
	local v10 = v9 and v9.getParam("conversationId", nil)
	local v11 = v9 and v9.getParam("modalVariant", nil)
	local v12 = React.useCallback(function() -- line: 17
		-- upvalues: v9 (copy), EnumScreens (copy)
		if v9 and v9.state.routeName == EnumScreens.TrustedConnectionsUpsell then
			v9.goBack(v9.state.key)
		end
	end, { v9 })

	if not v11 or not v10 then
		v4:error("TrustedConnectionsUpsellScreen: Missing required parameters", {
			conversationId = v10,
			modalVariant = v11
		})
		v9.goBack()

		return nil
	end

	return React.createElement(TrustedConnectionsUpsellContainer, {
		conversationId = v10,
		dismissModal = v12,
		modalVariant = v11
	})
end

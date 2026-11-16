local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local EnumScreens = require(AppChat.EnumScreens)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local TrustedFriendsUpsellContainer = require(script.Parent.TrustedFriendsUpsellContainer)

return function(_)
	local v2 = useNavigation()
	local userId = v2 and v2.getParam("userId", nil)
	local conversationId = v2 and v2.getParam("conversationId", nil)
	local v3 = v2 and v2.getParam("modalVariant", nil)
	local source = v2 and v2.getParam("source", nil)
	local modalVariantOverride = v2 and v2.getParam("modalVariantOverride", nil)
	local onRequestSent = v2 and v2.getParam("onRequestSent", nil)
	local onRequestAccepted = v2 and v2.getParam("onRequestAccepted", nil)
	local onAcknowledged = v2 and v2.getParam("onAcknowledged", nil)

	local dismissModal = React.useCallback(function()
		if v2 and v2.state.routeName == EnumScreens.TrustedConnectionsUpsell then
			v2.goBack(v2.state.key)
		end
	end, { v2 })

	if userId then
		return React.createElement(TrustedFriendsUpsellContainer, {
			userId = userId,
			dismissModal = dismissModal,
			source = source,
			conversationId = conversationId,
			analyticsModalVariant = v3,
			modalVariantOverride = modalVariantOverride,
			onRequestSent = onRequestSent,
			onRequestAccepted = onRequestAccepted,
			onAcknowledged = onAcknowledged
		})
	end

	v:error("TrustedFriendsUpsellScreen: Missing required userId param", {
		conversationId = conversationId,
		modalVariant = v3
	})

	if v2 then
		v2.goBack()
	end

	return nil
end

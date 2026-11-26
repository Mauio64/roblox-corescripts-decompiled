local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("TrustedFriendsUpsellScreen")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local TrustedFriendsUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TrustedFriendsUpsell/TrustedFriendsUpsellContainer")

return function(p2)
	local v6 = useNavigation()
	local v7 = v6 and v6.getParam("userId", nil)
	local v8 = v6 and v6.getParam("conversationId", nil)
	local v9 = v6 and v6.getParam("modalVariant", nil)
	local v10 = v6 and v6.getParam("source", nil)
	local v11 = v6 and v6.getParam("modalVariantOverride", nil)
	local v12 = v6 and v6.getParam("onRequestSent", nil)
	local v13 = v6 and v6.getParam("onRequestAccepted", nil)
	local v14 = v6 and v6.getParam("onAcknowledged", nil)

	local v15 = React.useCallback(function()
		if v6 and v6.state.routeName == EnumScreens.TrustedConnectionsUpsell then
			v6.goBack(v6.state.key)
		end
	end, { v6 })

	if v7 then
		return React.createElement(TrustedFriendsUpsellContainer, {
			userId = v7,
			dismissModal = v15,
			source = v10,
			conversationId = v8,
			analyticsModalVariant = v9,
			modalVariantOverride = v11,
			onRequestSent = v12,
			onRequestAccepted = v13,
			onAcknowledged = v14
		})
	end

	v5:error("TrustedFriendsUpsellScreen: Missing required userId param", {
		conversationId = v8,
		modalVariant = v9
	})

	if v6 then
		v6.goBack()
	end

	return nil
end

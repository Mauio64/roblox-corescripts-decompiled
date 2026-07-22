local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ChatLandingTelemetryLayer = require(Parent.AppChat.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(Parent.AppChat.ChatLandingTelemetryState)
local useGetAndSetRef = require(Parent.AppChat.useGetAndSetRef)

local function FriendsChatLandingTelemetryProviders(t1: {[any]: any}) -- line: 20
	-- upvalues: useGetAndSetRef (copy), React (copy), ChatLandingTelemetryState (copy), ChatLandingTelemetryLayer (copy)
	local v8, v9 = useGetAndSetRef({})
	local v10 = React.useCallback(function() -- line: 22
		-- upvalues: v8 (copy)
		local v11 = v8()

		return {
			chatLandingListCount = v11.chatLandingListCount,
			pendingConversationCount = v11.pendingConversationCount,
			unfilteredConversationCount = v11.unfilteredConversationCount
		}
	end, { v8 })

	return React.createElement(ChatLandingTelemetryState.Provider, {
		value = {
			get = v8,
			set = v9
		}
	}, {
		Layer = React.createElement(ChatLandingTelemetryLayer.Provider, {
			value = v10
		}, t1.children)
	})
end

return FriendsChatLandingTelemetryProviders

local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local ChatLandingTelemetryLayer = require(parent.AppChat.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(parent.AppChat.ChatLandingTelemetryState)
local useGetAndSetRef = require(parent.AppChat.useGetAndSetRef)

local function FriendsChatLandingTelemetryProviders(p)
	local get, set = useGetAndSetRef({})
	local v = React.useCallback(function()
		local v = get()
		return {
			chatLandingListCount = v.chatLandingListCount,
			pendingConversationCount = v.pendingConversationCount,
			unfilteredConversationCount = v.unfilteredConversationCount,
			searchSessionId = v.searchSessionId,
			activeFilters = v.activeFilters
		}
	end, { get })

	return React.createElement(ChatLandingTelemetryState.Provider, {
		value = { get = get, set = set }
	}, {
		Layer = React.createElement(ChatLandingTelemetryLayer.Provider, { value = v }, p.children)
	})
end

return FriendsChatLandingTelemetryProviders

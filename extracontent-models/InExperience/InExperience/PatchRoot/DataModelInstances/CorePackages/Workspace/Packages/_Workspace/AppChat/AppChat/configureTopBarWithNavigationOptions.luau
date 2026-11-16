local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)
local SignalsReact = require(parent.SignalsReact)

local createChatTopBar = require(AppChat.createChatTopBar)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local function TopBarFromStore(p)
	local navigation = p.navigation
	local activeChildNavigationOptions = RoactNavigation.getActiveChildNavigationOptions(navigation)
	local state = navigation.state
	local route = state.routes[state.index]

	local screenTopBar = GetTopBarStore(false).getScreenTopBar(route.routeName)
	local v = SignalsReact.useSignalState(screenTopBar)
	ArgCheck.isType(v, "table", "screenTopBar")

	local conversationId = route.params and route.params.conversationId
	local conversationId2 = v.conversationId

	if conversationId and conversationId2 and conversationId ~= conversationId2 then
		v = Cryo.Dictionary.union(v, {
			headerText = { raw = "", shouldLocalize = false }
		})
	end

	return createChatTopBar(Cryo.Dictionary.join(v, activeChildNavigationOptions, {
		navigation = navigation
	}))
end

return function(navigation)
	return Roact.createElement(TopBarFromStore, { navigation = navigation })
end

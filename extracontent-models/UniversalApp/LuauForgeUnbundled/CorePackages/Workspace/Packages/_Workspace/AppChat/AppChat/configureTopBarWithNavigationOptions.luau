local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local createChatTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/createChatTopBar")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local function TopBarFromStore(p2)
	local navigation = p2.navigation
	local activeChildNavigationOptions = RoactNavigation.getActiveChildNavigationOptions(navigation)
	local state = navigation.state
	local route = state.routes[state.index]

	local screenTopBar = GetTopBarStore(false).getScreenTopBar(route.routeName)
	local v5 = SignalsReact.useSignalState(screenTopBar)
	ArgCheck.isType(v5, "table", "screenTopBar")

	local conversationId = route.params and route.params.conversationId
	local conversationId2 = v5.conversationId

	if conversationId and conversationId2 and conversationId ~= conversationId2 then
		v5 = Cryo.Dictionary.union(v5, {
			headerText = { raw = "", shouldLocalize = false }
		})
	end

	return createChatTopBar(Cryo.Dictionary.join(v5, activeChildNavigationOptions, {
		navigation = navigation
	}))
end

return function(p2)
	return Roact.createElement(TopBarFromStore, { navigation = p2 })
end

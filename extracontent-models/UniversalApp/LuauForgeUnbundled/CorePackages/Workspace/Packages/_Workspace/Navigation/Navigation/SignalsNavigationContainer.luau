local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/React")
local context = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation").Context
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SignalsReact").useSignalState

require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/createSignalsNavigationObject")

local function SignalsNavigationContainer(p2)
	local v5 = useSignalState(p2.navigation.getNavigation)

	React.useEffect(function()
		p2.navigation.notifyEvents()
	end)

	return React.createElement(context.Provider, { value = v5 }, p2.children)
end

return SignalsNavigationContainer

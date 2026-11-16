local parent = script.Parent.Parent
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Context = RoactNavigation.Context
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

require(script.Parent.createSignalsNavigationObject)

local function SignalsNavigationContainer(p)
	local v = useSignalState(p.navigation.getNavigation)

	React.useEffect(function()
		p.navigation.notifyEvents()
	end)

	return React.createElement(Context.Provider, { value = v }, p.children)
end

return SignalsNavigationContainer

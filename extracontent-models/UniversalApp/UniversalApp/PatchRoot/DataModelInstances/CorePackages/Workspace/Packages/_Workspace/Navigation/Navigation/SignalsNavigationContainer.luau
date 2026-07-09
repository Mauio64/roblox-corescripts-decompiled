local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Context = require(ParentParent.RoactNavigation).Context
local useSignalState = require(ParentParent.SignalsReact).useSignalState

require(script.Parent.createSignalsNavigationObject)

local function SignalsNavigationContainer(t1: {[any]: any}) -- line: 15
	-- upvalues: useSignalState (copy), React (copy), Context (copy)
	local v7 = useSignalState(t1.navigation.getNavigation)

	React.useEffect(function() -- line: 19
		-- upvalues: t1 (copy)
		t1.navigation.notifyEvents()
	end)

	return React.createElement(Context.Provider, {
		value = v7
	}, t1.children)
end

return SignalsNavigationContainer

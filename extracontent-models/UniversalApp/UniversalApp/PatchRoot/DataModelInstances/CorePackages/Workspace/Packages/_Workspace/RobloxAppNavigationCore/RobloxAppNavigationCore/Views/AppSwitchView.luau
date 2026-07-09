local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)

require(Parent.Navigation)

local AppCard = require(script.Parent.AppCard)

local function AppSwitchView(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), AppCard (copy)
	local descriptors = t1.descriptors
	local state = t1.navigation.state
	local key = state.routes[state.index].key
	local t2 = {}

	for v10, v11 in descriptors do
		t2[v10] = React.createElement(AppCard, {
			isActive = v10 == key,
			descriptor = v11,
			screenProps = t1.screenProps,
			isVisible = v10 == key
		})
	end

	return React.createElement(React.Fragment, nil, t2)
end

return AppSwitchView

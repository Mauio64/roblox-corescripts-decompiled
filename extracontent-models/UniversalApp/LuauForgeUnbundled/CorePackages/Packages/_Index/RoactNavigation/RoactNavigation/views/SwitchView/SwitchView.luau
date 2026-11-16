local React = require("@game/CorePackages/Workspace/Packages/React")
require("@luauforge/bundled/dCC")

local module2 = require("@luauforge/bundled/dCN")

local function AppSwitchView(props)
	local descriptors = props.descriptors
	local state = props.navigation.state
	local key = state.routes[state.index].key

	local children = {}

	for k, descriptor in descriptors do
		children[k] = React.createElement(module2, {
			isActive = k == key,
			descriptor = descriptor,
			screenProps = props.screenProps,
			isVisible = k == key
		})
	end

	return React.createElement(React.Fragment, nil, children)
end

return AppSwitchView

local parent = script.Parent.Parent.Parent.Parent
local React = require(parent.React)
local SceneView = require(script.Parent.Parent.SceneView)

local function SwitchView(props)
	local state = props.navigation.state
	local key = state.routes[state.index].key
	local descriptor = props.descriptors[key]
	local component = descriptor.getComponent()

	return React.createElement(SceneView, {
		component = component,
		navigation = descriptor.navigation,
		screenProps = props.screenProps
	})
end

return SwitchView

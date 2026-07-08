local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local SceneView = require(script.Parent.Parent.SceneView)

local function SwitchView(p1) -- line: 8
	-- upvalues: React (copy), SceneView (copy)
	local state = p1.navigation.state
	local key = state.routes[state.index].key
	local v8 = p1.descriptors[key]
	local v9 = v8.getComponent()

	return React.createElement(SceneView, {
		component = v9,
		navigation = v8.navigation,
		screenProps = p1.screenProps
	})
end

return SwitchView

local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local React = require(ParentParent.React)
local NavigationContext = require(scriptParent.NavigationContext)
local v5 = React.PureComponent:extend("SceneView")

function v5.render(p1) -- line: 11
	-- upvalues: React (copy), NavigationContext (copy)
	local screenProps = p1.props.screenProps
	local component = p1.props.component
	local navigation = p1.props.navigation

	return React.createElement(NavigationContext.Provider, {
		value = navigation
	}, {
		Scene = React.createElement(component, {
			screenProps = screenProps,
			navigation = navigation
		})
	})
end

return v5

local parent = script.Parent
local parent2 = parent.Parent.Parent

local React = require(parent2.React)
local NavigationContext = require(parent.NavigationContext)

local extended = React.PureComponent:extend("SceneView")

function extended.render(p)
	local screenProps = p.props.screenProps
	local component = p.props.component
	local navigation = p.props.navigation

	return React.createElement(NavigationContext.Provider, { value = navigation }, {
		Scene = React.createElement(component, {
			screenProps = screenProps,
			navigation = navigation
		})
	})
end

return extended

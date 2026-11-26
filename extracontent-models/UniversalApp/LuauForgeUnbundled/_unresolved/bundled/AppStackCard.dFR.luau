local React = require("@game/CorePackages/Workspace/Packages/React")

local module2 = require("@luauforge/bundled/dFS")

local function AppStackCard(props)
	React.useEffect(function()
		props.onAnimationComplete()
	end, { props.onAnimationComplete })

	return React.createElement(module2, {
		isActive = props.isActive,
		descriptor = props.descriptor,
		screenProps = props.screenProps,
		isVisible = props.isVisible,
		ZIndex = props.ZIndex,
		onScreenContextValue = props.onScreenContextValue
	})
end

return AppStackCard

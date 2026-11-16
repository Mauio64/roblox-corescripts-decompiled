local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/React")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Foundation").Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("DrawerScrimCanBeModal", false)

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		ref = p2,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = props.transparencyBinding,
		BackgroundColor3 = v5.Color.Common.Scrim.Color3,
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		ZIndex = props.zIndex,
		[React.Change.AbsoluteSize] = props.onSizeChanged,
		[React.Event.Activated] = props.onActivated,
		BorderSizePixel = 0
	}

	local v8 = if defineFastFlag then props.isModal else nil
	v7.Modal = v8
	return createElement("TextButton", v7, props.children)
end))

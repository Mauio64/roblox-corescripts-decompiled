local parent = script:FindFirstAncestor("Drawer").Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("DrawerScrimCanBeModal", false)

return (React.forwardRef(function(props, ref)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		ref = ref,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = props.transparencyBinding,
		BackgroundColor3 = v.Color.Common.Scrim.Color3,
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		ZIndex = props.zIndex,
		[React.Change.AbsoluteSize] = props.onSizeChanged,
		[React.Event.Activated] = props.onActivated,
		BorderSizePixel = 0
	}
	local modal

	if defineFastFlag then
		modal = props.isModal
	end

	v2.Modal = modal
	return createElement("TextButton", v2, props.children)
end))

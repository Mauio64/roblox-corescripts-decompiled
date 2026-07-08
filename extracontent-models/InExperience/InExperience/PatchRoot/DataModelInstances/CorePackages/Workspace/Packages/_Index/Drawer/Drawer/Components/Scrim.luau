local Parent = script:FindFirstAncestor("Drawer").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local v4 = game:DefineFastFlag("DrawerScrimCanBeModal", false)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 18
	-- upvalues: useTokens (copy), React (copy), v4 (copy)
	local v7 = useTokens()

	return React.createElement("TextButton", {
		ref = p1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = t1.transparencyBinding,
		BackgroundColor3 = v7.Color.Common.Scrim.Color3,
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		ZIndex = t1.zIndex,
		[React.Change.AbsoluteSize] = t1.onSizeChanged,
		[React.Event.Activated] = t1.onActivated,
		BorderSizePixel = 0,
		Modal = if not v4 then nil else t1.isModal
	}, t1.children)
end))

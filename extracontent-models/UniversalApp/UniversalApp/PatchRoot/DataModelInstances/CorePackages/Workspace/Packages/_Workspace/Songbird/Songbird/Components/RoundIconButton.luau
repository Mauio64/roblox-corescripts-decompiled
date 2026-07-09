local Songbird = script:FindFirstAncestor("Songbird")
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function RoundIconButton(t1: {[any]: any}) -- line: 17
	-- upvalues: useTokens (copy), React (copy), Foundation (copy)
	local v7 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "auto-xy bg-action-emphasis radius-circle padding-small",
		aspectRatio = 1,
		onActivated = t1.onActivated,
		LayoutOrder = t1.LayoutOrder
	}, {
		Icon = React.createElement(Foundation.Icon, {
			Position = t1.iconOffset,
			name = t1.icon,
			size = Foundation.Enums.IconSize.Medium,
			style = v7.Color.ActionEmphasis.Foreground
		})
	})
end

return RoundIconButton

local Parent = script:FindFirstAncestor("VideoUtils").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function RoundIconButton(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), View (copy), Icon (copy), IconSize (copy)
	local v10 = useTokens()

	return React.createElement(View, {
		tag = "auto-xy bg-over-media-100 radius-circle padding-medium",
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		ZIndex = t1.ZIndex,
		onActivated = t1.onActivated,
		selection = if t1.Selectable == nil then nil else {
			Selectable = t1.Selectable
		}
	}, {
		Icon = React.createElement(Icon, {
			name = t1.icon,
			size = IconSize.Medium,
			style = v10.Color.Content.Emphasis
		})
	})
end

return RoundIconButton

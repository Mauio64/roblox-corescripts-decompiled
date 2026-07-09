local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconSize = Foundation.Enums.IconSize

local function Badge(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), IconSize (copy)
	local v8 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "auto-xy row align-x-center align-y-center bg-surface-300 radius-circle padding-small gap-xsmall",
		BorderSizePixel = 0,
		Text = "",
		LayoutOrder = t1.LayoutOrder,
		onActivated = t1.onActivated
	}, {
		Icon = React.createElement(Foundation.Icon, {
			LayoutOrder = 1,
			name = t1.icon,
			variant = t1.iconVariant,
			size = IconSize.Medium,
			style = v8.Color.Content.Default
		}),
		Text = if not t1.text then nil else React.createElement(Foundation.Text, {
			tag = "text-caption-large content-emphasis text-align-x-left auto-xy text-truncate-none",
			LayoutOrder = 2,
			Text = t1.text,
			textStyle = v8.Color.Content.Default
		})
	})
end

return Badge

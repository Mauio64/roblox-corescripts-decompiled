local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function CustomPill(t1: {[any]: any}) -- line: 20
	-- upvalues: useTokens (copy), React (copy), Foundation (copy)
	local v7 = useTokens()
	local v8 = if not t1.isChecked then v7.Color.Shift.Shift_200 else v7.Color.ActionSubEmphasis.Background
	local v9 = if not t1.isChecked then v7.Color.Content.Emphasis else v7.Color.ActionSubEmphasis.Foreground

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		backgroundStyle = v8,
		onActivated = t1.onActivated,
		LayoutOrder = t1.LayoutOrder
	}, {
		PillText = React.createElement(Foundation.Text, {
			tag = "auto-xy text-align-x-center text-align-y-center text-no-wrap padding-x-xsmall text-truncate-end",
			Text = t1.text,
			textStyle = v9,
			fontStyle = v7.Typography.CaptionLarge
		})
	})
end

return CustomPill

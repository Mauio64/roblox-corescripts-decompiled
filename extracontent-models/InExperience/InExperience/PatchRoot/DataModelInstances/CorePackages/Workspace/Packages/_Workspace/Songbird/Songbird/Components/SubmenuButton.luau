local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local useCallback = React.useCallback
local createNextOrder = ReactUtils.createNextOrder
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	iconSize = Foundation.Enums.IconSize.Medium
}

local function SubmenuButton(t2: {[any]: any}) -- line: 31
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), useTokens (copy), useCallback (copy), Foundation (copy), React (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = createNextOrder()
	local v14 = useTokens()
	local v15 = useCallback(function(p1) -- line: 37
		-- upvalues: Foundation (copy), v12 (copy)
		if p1 == Foundation.Enums.ControlState.Pressed and v12.onActivated then
			v12.onActivated()
		end
	end, { v12.onActivated })

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y row gap-small padding-small align-y-center radius-medium",
		onStateChanged = v15,
		LayoutOrder = v12.LayoutOrder
	}, {
		Icon = if not v12.icon then nil else React.createElement(Foundation.Icon, {
			name = v12.icon,
			size = v12.iconSize,
			style = v14.Color.Content.Emphasis,
			LayoutOrder = v13()
		}),
		Text = React.createElement(Foundation.Text, {
			tag = "auto-xy content-default text-label-large",
			Text = v12.text,
			LayoutOrder = v13()
		})
	})
end

return SubmenuButton

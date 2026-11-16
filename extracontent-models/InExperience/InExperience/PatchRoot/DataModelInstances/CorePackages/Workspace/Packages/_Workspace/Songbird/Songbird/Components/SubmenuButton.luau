local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local ReactUtils = require(Songbird.Parent.ReactUtils)

local useCallback = React.useCallback
local createNextOrder = ReactUtils.createNextOrder
local useTokens = Foundation.Hooks.useTokens

local v = { iconSize = Foundation.Enums.IconSize.Medium }

local function SubmenuButton(p)
	local joined = Cryo.Dictionary.join(v, p)
	local nextOrder = createNextOrder()
	local v2 = useTokens()

	local onStateChanged = useCallback(function(p2)
		if p2 == Foundation.Enums.ControlState.Pressed and joined.onActivated then
			joined.onActivated()
		end
	end, { joined.onActivated })

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		tag = "size-full-0 auto-y row gap-small padding-small align-y-center radius-medium",
		onStateChanged = onStateChanged,
		LayoutOrder = joined.LayoutOrder
	}
	local icon

	if joined.icon then
		icon = React.createElement(Foundation.Icon, {
			name = joined.icon,
			size = joined.iconSize,
			style = v2.Color.Content.Emphasis,
			LayoutOrder = nextOrder()
		})
	end

	return createElement(view, v3, {
		Icon = icon,
		Text = React.createElement(Foundation.Text, {
			tag = "auto-xy content-default text-label-large",
			Text = joined.text,
			LayoutOrder = nextOrder()
		})
	})
end

return SubmenuButton

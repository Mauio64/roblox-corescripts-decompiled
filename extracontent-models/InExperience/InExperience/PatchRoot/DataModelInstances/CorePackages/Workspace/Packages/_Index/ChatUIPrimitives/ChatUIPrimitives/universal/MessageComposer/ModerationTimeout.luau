local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Countdown = require(script.Parent.Countdown)

local function ModerationTimeout(p)
	local v = Foundation.Hooks.useTokens()
	local untilTimestamp = p.state.untilTimestamp

	if p.state.status == "loading" then
		return React.createElement(
			Foundation.View,
			{
				tag = "row align-x-center align-y-center size-full",
				GroupTransparency = p.transparency,
				testId = "moderationTimeoutLoading"
			},
			{
				Spinner = React.createElement(Foundation.Loading, {
					size = Foundation.Enums.IconSize.Medium
				})
			}
		)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "row align-y-center gap-small size-full padding-left-large padding-right-medium",
		GroupTransparency = p.transparency,
		testId = "moderationTimeout"
	}

	local v3 = {
		Copy = React.createElement(Foundation.Text, {
			tag = "fill auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-system-alert",
			Text = p.state.text or "",
			LayoutOrder = 1
		}),
		Trailing = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local countdown

	if untilTimestamp ~= nil then
		countdown = React.createElement(Countdown, {
			untilTimestamp = untilTimestamp,
			LayoutOrder = 1
		})
	end

	v3.Trailing = createElement2(view2, {
		tag = "row align-y-center gap-small auto-xy",
		LayoutOrder = 2
	}, {
		Countdown = countdown,
		AlertIcon = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			size = Foundation.Enums.IconSize.Medium,
			style = v.Color.System.Alert,
			LayoutOrder = 2
		})
	})
	return createElement(view, v2, v3)
end

return ModerationTimeout

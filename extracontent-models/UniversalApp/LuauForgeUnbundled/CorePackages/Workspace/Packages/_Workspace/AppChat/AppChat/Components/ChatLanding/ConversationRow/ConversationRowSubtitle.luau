local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local function isNonEmpty(value)
	if typeof(value) == "string" then
		return value ~= ""
	end

	return value:map(function(p2): boolean
		return p2 ~= ""
	end)
end

local function ConversationRowSubtitle(props)
	local v5 = React.useMemo(function()
		return isNonEmpty(props.subtitleText)
	end, { props.subtitleText })
	local v6 = React.useMemo(function()
		return isNonEmpty(props.timestampText)
	end, { props.timestampText })

	return React.createElement(
		Foundation.View,
		{
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-right-medium clip",
			LayoutOrder = props.LayoutOrder
		},
		{
			subtitle = React.createElement(Foundation.Text, {
				tag = "shrink auto-xy text-body-small text-align-x-left text-truncate-split content-default",
				Text = props.subtitleText,
				Visible = v5,
				LayoutOrder = 1
			}),
			inlineTimestamp = React.createElement(
				Foundation.View,
				{
					tag = "row align-y-center gap-xsmall auto-xy",
					Visible = v6,
					LayoutOrder = 2,
					testId = "conversation-row-inline-timestamp"
				},
				{
					separator = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-small content-default",
						Text = "·",
						Visible = v5,
						LayoutOrder = 1
					}),
					timestamp = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-small content-default",
						Text = props.timestampText,
						LayoutOrder = 2,
						testId = "conversation-row-timestamp"
					})
				}
			)
		}
	)
end

return React.memo(ConversationRowSubtitle)

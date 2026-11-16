local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function isNonEmpty(value)
	if typeof(value) == "string" then
		return value ~= ""
	end

	return value:map(function(p: string): boolean
		return p ~= ""
	end)
end

local function ConversationRowSubtitle(props)
	local visible = React.useMemo(function()
		return isNonEmpty(props.subtitleText)
	end, { props.subtitleText })
	local visible2 = React.useMemo(function()
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
				Visible = visible,
				LayoutOrder = 1
			}),
			inlineTimestamp = React.createElement(
				Foundation.View,
				{
					tag = "row align-y-center gap-xsmall auto-xy",
					Visible = visible2,
					LayoutOrder = 2,
					testId = "conversation-row-inline-timestamp"
				},
				{
					separator = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-small content-default",
						Text = "·",
						Visible = visible,
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

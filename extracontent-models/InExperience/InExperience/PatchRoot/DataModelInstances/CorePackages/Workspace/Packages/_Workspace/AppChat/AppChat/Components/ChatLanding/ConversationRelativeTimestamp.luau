local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function ConversationRelativeTimestamp(p)
	local hasUnreadMessages = p.hasUnreadMessages

	local createElement = React.createElement
	local view = Foundation.View

	local v = {
		timestamp = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-default",
			LayoutOrder = 1,
			Text = p.timestampText
		}),
		unreadDot = 0
	}
	local unreadDot

	if hasUnreadMessages then
		unreadDot = React.createElement(Foundation.View, {
			tag = "size-200-200 radius-circle bg-action-emphasis",
			LayoutOrder = 2
		})
	end

	v.unreadDot = unreadDot
	return createElement(view, { tag = "row auto-xy align-y-center gap-xsmall" }, v)
end

return ConversationRelativeTimestamp

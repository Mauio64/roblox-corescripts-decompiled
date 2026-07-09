local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function ConversationRelativeTimestamp(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), Foundation (copy)
	local hasUnreadMessages = t1.hasUnreadMessages

	return React.createElement(Foundation.View, {
		tag = "row auto-xy align-y-center gap-xsmall"
	}, {
		timestamp = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-default",
			LayoutOrder = 1,
			Text = t1.timestampText
		}),
		unreadDot = if not hasUnreadMessages then nil else React.createElement(Foundation.View, {
			tag = "size-200-200 radius-circle bg-action-emphasis",
			LayoutOrder = 2
		})
	})
end

return ConversationRelativeTimestamp

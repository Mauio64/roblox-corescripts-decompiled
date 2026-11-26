local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local function ConversationRelativeTimestamp(p2)
	local hasUnreadMessages = p2.hasUnreadMessages

	local createElement = React.createElement
	local view = Foundation.View

	local v6 = {
		timestamp = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-default",
			LayoutOrder = 1,
			Text = p2.timestampText
		}),
		unreadDot = 0
	}

	local v7 = if hasUnreadMessages then React.createElement(Foundation.View, {
		tag = "size-200-200 radius-circle bg-action-emphasis",
		LayoutOrder = 2
	}) else nil
	v6.unreadDot = v7
	return createElement(view, { tag = "row auto-xy align-y-center gap-xsmall" }, v6)
end

return ConversationRelativeTimestamp

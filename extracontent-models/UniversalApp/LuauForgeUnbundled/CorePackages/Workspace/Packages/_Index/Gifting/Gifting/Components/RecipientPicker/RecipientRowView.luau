local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local avatarSize = Foundation.Enums.AvatarSize

local function RecipientRowView(props)
	local userId = tonumber(props.userId)

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "size-full-0 auto-y padding-y-xsmall",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v8 = if props.isAvailable then props.onActivated else nil

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v10 = {
		tag = "row align-y-center gap-large size-full-0 auto-y padding-y-small",
		testId = `recipient-row-{props.userId}`
	}

	local v12 = if userId then React.createElement(Foundation.Avatar, {
		userId = userId,
		backgroundStyle = props.avatarBackgroundStyle,
		size = avatarSize.Large,
		LayoutOrder = 1
	}) else nil

	local createElement4 = React.createElement
	local view4 = Foundation.View

	local v14 = {
		DisplayName = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
			Text = props.displayName,
			LayoutOrder = 1
		}),
		Username = 0
	}

	local v15 = if props.username ~= "" then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
		Text = `@{props.username}`,
		LayoutOrder = 2
	}) else nil
	v14.Username = v15
	local v11 = {
		Avatar = v12,
		Names = createElement4(view4, {
			tag = "col fill auto-y padding-y-xsmall",
			LayoutOrder = 2
		}, v14),
		Unavailable = 0
	}

	local v16 = if not props.isAvailable then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-small content-default",
		Text = props.unavailableLabel,
		testId = `recipient-row-unavailable-{props.userId}`,
		LayoutOrder = 3
	}) else nil
	v11.Unavailable = v16
	return createElement(view, v5, {
		HoverSurface = createElement2(
			view2,
			{
				onActivated = v8,
				tag = "size-full-0 auto-y padding-x-small radius-medium"
			},
			{
				Row = createElement3(view3, v10, v11)
			}
		)
	})
end

return React.memo(RecipientRowView)

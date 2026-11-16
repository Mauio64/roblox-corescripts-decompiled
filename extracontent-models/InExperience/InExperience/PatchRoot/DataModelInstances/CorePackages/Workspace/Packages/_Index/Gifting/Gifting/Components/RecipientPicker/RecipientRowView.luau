local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local AvatarSize = Foundation.Enums.AvatarSize

local function RecipientRowView(props)
	local userId = tonumber(props.userId)

	local createElement = React.createElement
	local view = Foundation.View
	local v = { tag = "size-full-0 auto-y padding-y-xsmall", LayoutOrder = props.LayoutOrder }

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local onActivated

	if props.isAvailable then
		onActivated = props.onActivated
	end

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v2 = {
		tag = "row align-y-center gap-large size-full-0 auto-y padding-y-small",
		testId = `recipient-row-{props.userId}`
	}
	local avatar

	if userId then
		avatar = React.createElement(Foundation.Avatar, {
			userId = userId,
			backgroundStyle = props.avatarBackgroundStyle,
			size = AvatarSize.Large,
			LayoutOrder = 1
		})
	end

	local createElement4 = React.createElement
	local view4 = Foundation.View

	local v3 = {
		DisplayName = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
			Text = props.displayName,
			LayoutOrder = 1
		}),
		Username = 0
	}
	local username

	if props.username ~= "" then
		username = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			Text = `@{props.username}`,
			LayoutOrder = 2
		})
	end

	v3.Username = username
	local v4 = {
		Avatar = avatar,
		Names = createElement4(view4, { tag = "col fill auto-y padding-y-xsmall", LayoutOrder = 2 }, v3),
		Unavailable = 0
	}
	local unavailable

	if not props.isAvailable then
		unavailable = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-default",
			Text = props.unavailableLabel,
			testId = `recipient-row-unavailable-{props.userId}`,
			LayoutOrder = 3
		})
	end

	v4.Unavailable = unavailable
	return createElement(view, v, {
		HoverSurface = createElement2(
			view2,
			{ onActivated = onActivated, tag = "size-full-0 auto-y padding-x-small radius-medium" },
			{ Row = createElement3(view3, v2, v4) }
		)
	})
end

return React.memo(RecipientRowView)

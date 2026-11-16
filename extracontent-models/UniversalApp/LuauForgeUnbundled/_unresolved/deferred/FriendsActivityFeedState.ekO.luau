local module = require("@luauforge/deferred/ejT")
local module2 = require("@luauforge/deferred/ejR")

local button = module.Button
local icon = module.Icon
local text = module.Text
local view = module.View

local buttonVariant = module.Enums.ButtonVariant
local iconName = module.Enums.IconName
local iconSize = module.Enums.IconSize
local inputSize = module.Enums.InputSize

local function FriendsActivityFeedState(props)
	local v5 = props.kind == "Error"

	local createElement = module2.createElement
	local v7 = {
		tag = {
			["col align-x-center align-y-center gap-xxlarge padding-xlarge"] = true,
			["size-full"] = props.isScrollEnabled,
			["size-full-0 auto-y"] = not props.isScrollEnabled
		},
		LayoutOrder = props.layoutOrder,
		testId = "friends-activity-feed-state"
	}

	local createElement2 = module2.createElement
	local v9 = {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(100, 100),
		testId = "friends-activity-feed-state-graphic"
	}

	local v10 = {
		TiltFrame = module2.createElement(view, {
			tag = "position-center-center anchor-center-center stroke-standard stroke-default radius-xsmall",
			Rotation = -15,
			Size = UDim2.fromOffset(72, 72),
			testId = "friends-activity-feed-state-tilt-frame"
		}),
		Glyph = 0
	}

	local createElement3 = module2.createElement
	local v12 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		name = 0,
		size = 0,
		testId = "friends-activity-feed-state-icon"
	}
	local v13 = if v5 then iconName.TriangleExclamation else iconName.Check
	v12.name = v13
	v12.size = iconSize.Large
	v10.Glyph = createElement3(icon, v12)
	local children = { Graphic = createElement2(view, v9, v10), Copy = 0 }

	local createElement4 = module2.createElement
	local v15 = {
		LayoutOrder = 2,
		tag = "col align-x-center gap-small size-full-0 auto-y",
		sizeConstraint = { MaxSize = Vector2.new(261, 1e999) }
	}

	local v16 = {
		Title = module2.createElement(text, {
			LayoutOrder = 1,
			Text = v5 and "Error" or "No recent activity",
			tag = "size-full-0 auto-y text-label-large text-wrap text-align-x-center content-emphasis"
		}),
		Description = 0,
		Retry = 0
	}

	local v17 = if not v5 and props.description ~= nil then module2.createElement(text, {
		LayoutOrder = 2,
		Text = props.description,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
	}) else nil
	v16.Description = v17

	local v18 = if v5 and props.onRetry ~= nil then module2.createElement(button, {
		LayoutOrder = 2,
		onActivated = props.onRetry,
		size = inputSize.Small,
		text = "Try again",
		testId = "friends-activity-feed-state-retry",
		variant = buttonVariant.Utility
	}) else nil
	v16.Retry = v18
	children.Copy = createElement4(view, v15, v16)
	return createElement(view, v7, children)
end

return FriendsActivityFeedState

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local icon = Foundation.Icon
local progress = Foundation.Progress
local text = Foundation.Text
local view = Foundation.View

local iconSize = Foundation.Enums.IconSize
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize

local function PostStatusRowView(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-large radius-medium bg-shift-300",
		testId = "moments-post-status-row"
	}

	local createElement2 = React.createElement

	local v10 = if props.variant == "posting" then React.createElement(progress, {
		shape = progressShape.Circle,
		size = progressSize.Medium,
		value = props.progress,
		testId = "moments-post-status-row-progress"
	}) else React.createElement(icon, {
		name = BuilderIcons.Icon.TriangleExclamation,
		size = iconSize.Medium,
		testId = "moments-post-status-row-warning"
	})
	return createElement(view, v6, {
		Media = createElement2(
			view,
			{
				LayoutOrder = 1,
				tag = "row align-x-center align-y-center size-1000-1000"
			},
			{ Indicator = v10 }
		),
		Text = React.createElement(
			view,
			{ LayoutOrder = 2, tag = "col align-x-left align-y-center grow auto-y" },
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
					Text = props.title
				}),
				Body = React.createElement(text, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					Text = props.body
				})
			}
		)
	})
end

return PostStatusRowView

local parent = script:FindFirstAncestor("Moments").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local Progress = Foundation.Progress
local Text = Foundation.Text
local View = Foundation.View

local IconSize = Foundation.Enums.IconSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local function PostStatusRowView(props)
	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-large radius-medium bg-shift-300",
		testId = "moments-post-status-row"
	}

	local createElement2 = React.createElement
	local indicator

	if props.variant == "posting" then
		indicator = React.createElement(Progress, {
			shape = ProgressShape.Circle,
			size = ProgressSize.Medium,
			value = props.progress,
			testId = "moments-post-status-row-progress"
		})
	else
		indicator = React.createElement(Icon, {
			name = BuilderIcons.Icon.TriangleExclamation,
			size = IconSize.Medium,
			testId = "moments-post-status-row-warning"
		})
	end

	return createElement(View, v, {
		Media = createElement2(View, {
			LayoutOrder = 1,
			tag = "row align-x-center align-y-center size-1000-1000"
		}, {
			Indicator = indicator
		}),
		Text = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-left align-y-center grow auto-y"
		}, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
				Text = props.title
			}),
			Body = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
				Text = props.body
			})
		})
	})
end

return PostStatusRowView

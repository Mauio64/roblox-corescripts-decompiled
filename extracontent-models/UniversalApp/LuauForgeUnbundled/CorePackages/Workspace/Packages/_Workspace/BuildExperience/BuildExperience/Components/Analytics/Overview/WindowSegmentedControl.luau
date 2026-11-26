local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local view = Foundation.View
local text = Foundation.Text
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")

local function WindowSegmentedControl(props)
	local testId = props.testId or "WindowSegmentedControl"

	local children = {}

	for k, window in props.windows do
		local v5 = window.id == props.selectedWindowId
		children[`Tab_{window.id}`] = React.createElement(view, {
			LayoutOrder = k,
			tag = {
				["row align-x-center align-y-center fill auto-y padding-x-medium padding-y-small radius-circle"] = true,
				["bg-shift-300"] = v5
			},
			stateLayer = { affordance = stateLayerAffordance.Background },
			onActivated = function()
				props.onWindowSelected(window.id)
			end,
			testId = `{testId}-segment-{window.id}`
		}, {
			Label = React.createElement(text, {
				Text = window.label,
				tag = {
					["size-full-0 auto-y text-label-medium text-align-x-center text-truncate-end"] = true,
					["content-emphasis"] = v5,
					["content-default"] = not v5
				}
			})
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center gap-xxsmall size-full-0 auto-y padding-xsmall stroke-standard stroke-emphasis radius-circle",
			testId = testId
		},
		children
	)
end

return WindowSegmentedControl

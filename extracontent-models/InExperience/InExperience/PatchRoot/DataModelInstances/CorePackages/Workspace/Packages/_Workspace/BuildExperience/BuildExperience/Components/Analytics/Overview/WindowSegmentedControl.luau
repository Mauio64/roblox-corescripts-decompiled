local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

require(BuildExperience.Analytics.AnalyticsWindow)

local function WindowSegmentedControl(props)
	local testId = props.testId or "WindowSegmentedControl"

	local children = {}

	for k, window in props.windows do
		local v = window.id == props.selectedWindowId
		children[`Tab_{window.id}`] = React.createElement(View, {
			LayoutOrder = k,
			tag = {
				["row align-x-center align-y-center fill auto-y padding-x-medium padding-y-small radius-circle"] = true,
				["bg-shift-300"] = v
			},
			stateLayer = { affordance = StateLayerAffordance.Background },
			onActivated = function()
				props.onWindowSelected(window.id)
			end,
			testId = `{testId}-segment-{window.id}`
		}, {
			Label = React.createElement(Text, {
				Text = window.label,
				tag = {
					["size-full-0 auto-y text-label-medium text-align-x-center text-truncate-end"] = true,
					["content-emphasis"] = v,
					["content-default"] = not v
				}
			})
		})
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center gap-xxsmall size-full-0 auto-y padding-xsmall stroke-standard stroke-emphasis radius-circle",
			testId = testId
		},
		children
	)
end

return WindowSegmentedControl

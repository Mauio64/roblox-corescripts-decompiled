local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View

local InstantStatCard = require(script.Parent.InstantStatCard)

local function InstantStatsRow(props)
	local children = {}

	for k, stat in props.stats do
		children[`Cell{k}`] = React.createElement(View, { LayoutOrder = k, tag = "fill auto-y" }, {
			Card = React.createElement(InstantStatCard, {
				label = stat.label,
				valueText = stat.valueText,
				icon = stat.icon,
				isLoading = stat.isLoading,
				testId = stat.testId
			})
		})
	end

	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		tag = "row gap-medium size-full-0 auto-y",
		testId = props.testId or "InstantStatsRow"
	}, children)
end

return InstantStatsRow

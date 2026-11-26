local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation").View

local InstantStatCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/InstantStatCard")

local function InstantStatsRow(props)
	local children = {}

	for k, stat in props.stats do
		children[`Cell{k}`] = React.createElement(view, {
			LayoutOrder = k,
			tag = "fill auto-y"
		}, {
			Card = React.createElement(InstantStatCard, {
				label = stat.label,
				valueText = stat.valueText,
				icon = stat.icon,
				isLoading = stat.isLoading,
				testId = stat.testId
			})
		})
	end

	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		tag = "row gap-medium size-full-0 auto-y",
		testId = props.testId or "InstantStatsRow"
	}, children)
end

return InstantStatsRow

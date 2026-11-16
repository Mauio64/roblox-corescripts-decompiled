local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local view = Foundation.View
local useBreakpoint = Foundation.Hooks.useBreakpoint

local StatsCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCard")
local getStatsCardColumns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/getStatsCardColumns")

local function StatsCardContainer(props)
	local state, setState = React.useState(nil)

	local v5, v6 = useBreakpoint(state)
	local v7 = not (v6.X > 0) and 2 or getStatsCardColumns(v6.X)

	local cards = props.cards
	local children = {}

	for i = 1, math.ceil(#cards / v7) do
		local children2 = {}

		for j = 1, v7 do
			local card = cards[(i - 1) * v7 + j]

			if card ~= nil then
				children2[`Cell{j}`] = React.createElement(
					view,
					{ LayoutOrder = j, tag = "fill auto-y" },
					{
						Card = React.createElement(StatsCard, card)
					}
				)
			end
		end

		children[`Row{i}`] = React.createElement(
			view,
			{ LayoutOrder = i, tag = "row gap-medium size-full-0 auto-y" },
			children2
		)
	end

	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = props.testId or "StatsCardContainer",
		ref = setState
	}, children)
end

return StatsCardContainer

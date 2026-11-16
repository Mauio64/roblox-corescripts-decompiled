local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local useBreakpoint = Foundation.Hooks.useBreakpoint

local StatsCard = require(script.Parent.StatsCard.StatsCard)
local getStatsCardColumns = require(script.Parent.getStatsCardColumns)

local function StatsCardContainer(props)
	local state, setState = React.useState(nil)

	local _, v = useBreakpoint(state)
	local v2 = not (v.X > 0) and 2 or getStatsCardColumns(v.X)

	local cards = props.cards
	local children = {}

	for i = 1, math.ceil(#cards / v2) do
		local children2 = {}

		for j = 1, v2 do
			local card = cards[(i - 1) * v2 + j]

			if card ~= nil then
				children2[`Cell{j}`] = React.createElement(View, {
					LayoutOrder = j,
					tag = "fill auto-y"
				}, {
					Card = React.createElement(StatsCard, card)
				})
			end
		end

		children[`Row{i}`] = React.createElement(
			View,
			{ LayoutOrder = i, tag = "row gap-medium size-full-0 auto-y" },
			children2
		)
	end

	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-medium size-full-0 auto-y",
		testId = props.testId or "StatsCardContainer",
		ref = setState
	}, children)
end

return StatsCardContainer

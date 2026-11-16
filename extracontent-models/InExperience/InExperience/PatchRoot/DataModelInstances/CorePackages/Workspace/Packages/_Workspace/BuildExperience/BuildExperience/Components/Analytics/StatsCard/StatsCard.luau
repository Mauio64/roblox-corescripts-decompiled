local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local StatsCardView = require(script.Parent.StatsCardView)
local useStatsCardViewModel = require(script.Parent.useStatsCardViewModel)

local function StatsCard(p)
	local v = useStatsCardViewModel(p)
	return React.createElement(StatsCardView, v)
end

return StatsCard

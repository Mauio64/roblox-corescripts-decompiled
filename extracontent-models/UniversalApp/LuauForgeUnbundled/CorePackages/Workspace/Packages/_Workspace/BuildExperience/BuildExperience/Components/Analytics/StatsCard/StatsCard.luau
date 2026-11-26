local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local StatsCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCardView")
local useStatsCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/useStatsCardViewModel")

local function StatsCard(p2)
	local v5 = useStatsCardViewModel(p2)
	return React.createElement(StatsCardView, v5)
end

return StatsCard

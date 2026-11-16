local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Navigation").useRouteName
require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsVisualizer")

local ImpressionsTrackerWithoutNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTrackerWithoutNavigation")

return function(p2)
	local v5 = useRouteName()
	local joined = Cryo.Dictionary.join(p2, { routeName = v5 })
	return React.createElement(ImpressionsTrackerWithoutNavigation, joined)
end

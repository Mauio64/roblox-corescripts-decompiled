local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local MetricDetailSheetView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/MetricDetailSheet/MetricDetailSheetView")
local useMetricDetailSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/MetricDetailSheet/useMetricDetailSheetViewModel")

local function MetricDetailSheet(p2)
	local v5 = useMetricDetailSheetViewModel(p2)
	return React.createElement(MetricDetailSheetView, v5)
end

return MetricDetailSheet

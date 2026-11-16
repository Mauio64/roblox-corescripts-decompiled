local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local MetricDetailSheetView = require(script.Parent.MetricDetailSheetView)
local useMetricDetailSheetViewModel = require(script.Parent.useMetricDetailSheetViewModel)

local function MetricDetailSheet(p)
	local v = useMetricDetailSheetViewModel(p)
	return React.createElement(MetricDetailSheetView, v)
end

return MetricDetailSheet

local parent = script:FindFirstAncestor("Impressions").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useRouteName = Navigation.useRouteName
require(script.Parent.ImpressionsVisualizer)

local ImpressionsTrackerWithoutNavigation = require(script.Parent.ImpressionsTrackerWithoutNavigation)

return function(p)
	local routeName = useRouteName()
	local joined = Cryo.Dictionary.join(p, { routeName = routeName })
	return React.createElement(ImpressionsTrackerWithoutNavigation, joined)
end

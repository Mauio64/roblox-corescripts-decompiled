local Parent = script:FindFirstAncestor("Impressions").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local useRouteName = require(Parent.Navigation).useRouteName

require(script.Parent.ImpressionsVisualizer)

local ImpressionsTrackerWithoutNavigation = require(script.Parent.ImpressionsTrackerWithoutNavigation)

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: useRouteName (copy), Cryo (copy), React (copy), ImpressionsTrackerWithoutNavigation (copy)
	local v7 = useRouteName()
	local v8 = Cryo.Dictionary.join(t1, {
		routeName = v7
	})

	return React.createElement(ImpressionsTrackerWithoutNavigation, v8)
end
